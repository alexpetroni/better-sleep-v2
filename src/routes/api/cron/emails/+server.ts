import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { emailService } from '$lib/server/email';
import { CRON_SECRET } from '$env/static/private';

// POST /api/cron/emails - Process pending emails (called by cron job)
export const POST: RequestHandler = async ({ request }) => {
	// Verify cron secret
	const authHeader = request.headers.get('authorization');
	const expectedAuth = `Bearer ${CRON_SECRET}`;

	if (authHeader !== expectedAuth) {
		throw error(401, { message: 'Unauthorized' });
	}

	try {
		const result = await emailService.processPendingEmails();

		return json({
			success: true,
			sent: result.sent,
			failed: result.failed,
			processedAt: new Date().toISOString()
		});
	} catch (err) {
		console.error('Failed to process emails:', err);
		throw error(500, { message: 'Failed to process emails' });
	}
};
