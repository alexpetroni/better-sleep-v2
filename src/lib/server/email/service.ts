import { Resend } from 'resend';
import { RESEND_API_KEY, EMAIL_FROM } from '$env/static/private';
import { supabaseAdmin } from '../supabase';
import type { EmailStatus } from '$lib/types/database';

const resend = new Resend(RESEND_API_KEY);

export interface EmailTemplate {
	id: string;
	code: string;
	sequenceOrder: number;
	delayDays: number;
	subject: string;
	bodyHtml: string;
	bodyText: string;
}

export interface QueuedEmail {
	id: string;
	sessionId: string;
	templateId: string;
	toEmail: string;
	status: EmailStatus;
	scheduledFor: Date;
	sentAt?: Date;
	error?: string;
}

/**
 * Email service for sending follow-up emails
 */
export class EmailService {
	/**
	 * Queue follow-up emails for a completed quiz session
	 */
	async queueFollowUpEmails(
		sessionId: string,
		userEmail: string,
		locale = 'en'
	): Promise<void> {
		// Get all email templates for the sequence
		const { data: templates, error } = await supabaseAdmin
			.from('email_templates')
			.select(`
				*,
				email_templates_i18n!inner(subject, body_html, body_text)
			`)
			.eq('email_templates_i18n.locale', locale)
			.order('sequence_order');

		if (error) {
			console.error('Failed to get email templates:', error);
			return;
		}

		if (!templates || templates.length === 0) {
			console.log('No email templates found');
			return;
		}

		// Queue each email
		const now = new Date();
		const emailsToQueue = templates.map((template) => ({
			session_id: sessionId,
			template_id: template.id,
			to_email: userEmail,
			status: 'PENDING' as EmailStatus,
			scheduled_for: new Date(
				now.getTime() + template.delay_days * 24 * 60 * 60 * 1000
			).toISOString()
		}));

		const { error: queueError } = await supabaseAdmin
			.from('email_queue')
			.insert(emailsToQueue);

		if (queueError) {
			console.error('Failed to queue emails:', queueError);
		}
	}

	/**
	 * Process pending emails that are due to be sent
	 */
	async processPendingEmails(): Promise<{ sent: number; failed: number }> {
		const now = new Date().toISOString();

		// Get emails that are due
		const { data: emails, error } = await supabaseAdmin
			.from('email_queue')
			.select(`
				*,
				email_templates(
					code,
					email_templates_i18n(subject, body_html, body_text, locale)
				),
				quiz_sessions(
					locale,
					quiz_results(overall_score, top_risks, recommendations)
				)
			`)
			.eq('status', 'PENDING')
			.lte('scheduled_for', now)
			.limit(50);

		if (error || !emails) {
			console.error('Failed to get pending emails:', error);
			return { sent: 0, failed: 0 };
		}

		let sent = 0;
		let failed = 0;

		for (const email of emails) {
			try {
				const template = email.email_templates;
				const session = email.quiz_sessions;
				const locale = session?.locale || 'en';

				// Get localized template content
				const i18n = template?.email_templates_i18n?.find(
					(t: { locale: string }) => t.locale === locale
				) || template?.email_templates_i18n?.[0];

				if (!i18n) {
					throw new Error('No template translation found');
				}

				// Render template with data
				const result = session?.quiz_results?.[0];
				const html = this.renderTemplate(i18n.body_html, {
					overallScore: result?.overall_score || 0,
					topRisks: result?.top_risks || [],
					recommendations: result?.recommendations || []
				});

				const text = this.renderTemplate(i18n.body_text, {
					overallScore: result?.overall_score || 0,
					topRisks: result?.top_risks || [],
					recommendations: result?.recommendations || []
				});

				// Send email
				await resend.emails.send({
					from: EMAIL_FROM,
					to: email.to_email,
					subject: i18n.subject,
					html,
					text
				});

				// Mark as sent
				await supabaseAdmin
					.from('email_queue')
					.update({
						status: 'SENT',
						sent_at: new Date().toISOString()
					})
					.eq('id', email.id);

				sent++;
			} catch (err) {
				console.error(`Failed to send email ${email.id}:`, err);

				// Mark as failed
				await supabaseAdmin
					.from('email_queue')
					.update({
						status: 'FAILED',
						error: err instanceof Error ? err.message : 'Unknown error'
					})
					.eq('id', email.id);

				failed++;
			}
		}

		return { sent, failed };
	}

	/**
	 * Cancel pending emails for a session
	 */
	async cancelPendingEmails(sessionId: string): Promise<void> {
		await supabaseAdmin
			.from('email_queue')
			.update({ status: 'CANCELLED' })
			.eq('session_id', sessionId)
			.eq('status', 'PENDING');
	}

	/**
	 * Simple template rendering
	 */
	private renderTemplate(
		template: string,
		data: {
			overallScore: number;
			topRisks: string[];
			recommendations: unknown[];
		}
	): string {
		return template
			.replace(/\{\{overallScore\}\}/g, String(data.overallScore))
			.replace(/\{\{topRisksCount\}\}/g, String(data.topRisks.length))
			.replace(/\{\{recommendationsCount\}\}/g, String(data.recommendations.length));
	}
}

export const emailService = new EmailService();
