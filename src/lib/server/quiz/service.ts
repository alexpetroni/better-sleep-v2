import { supabaseAdmin } from '../supabase';
import { ScoreCalculator, createResponseMap, riskCategories, scoringRules } from '../scoring';
import { MedicalFlagsGenerator, defaultFlagRules, defaultFlagTranslations } from '../scoring/flags';
import type { QuizMode } from '$lib/types/database';
import type {
	QuizSession,
	QuizSection,
	QuizQuestion,
	QuizResponse,
	QuizResult,
	QuizProgress,
	GateRule,
	Recommendation
} from '$lib/types/quiz';

/**
 * Quiz service for managing quiz flow
 */
export class QuizService {
	private calculator: ScoreCalculator;
	private flagsGenerator: MedicalFlagsGenerator;

	constructor() {
		this.calculator = new ScoreCalculator(scoringRules, riskCategories);
		this.flagsGenerator = new MedicalFlagsGenerator(defaultFlagRules, defaultFlagTranslations);
	}

	/**
	 * Create a new quiz session
	 */
	async createSession(mode: QuizMode, locale = 'en', userId?: string): Promise<QuizSession> {
		const { data, error } = await supabaseAdmin
			.from('quiz_sessions')
			.insert({
				mode,
				locale,
				user_id: userId || null,
				current_section_index: 0,
				current_question_index: 0,
				skipped_sections: [],
				skipped_questions: []
			})
			.select()
			.single();

		if (error) throw new Error(`Failed to create session: ${error.message}`);

		return this.mapSession(data);
	}

	/**
	 * Get session by ID
	 */
	async getSession(sessionId: string): Promise<QuizSession | null> {
		const { data, error } = await supabaseAdmin
			.from('quiz_sessions')
			.select()
			.eq('id', sessionId)
			.single();

		if (error || !data) return null;
		return this.mapSession(data);
	}

	/**
	 * Get all sections for a quiz mode with translations
	 */
	async getSections(mode: QuizMode, locale = 'en'): Promise<QuizSection[]> {
		const { data: sections, error } = await supabaseAdmin
			.from('quiz_sections')
			.select(`
				*,
				quiz_sections_i18n!inner(title, description)
			`)
			.contains('modes', [mode])
			.eq('quiz_sections_i18n.locale', locale)
			.order('order_index');

		if (error) throw new Error(`Failed to get sections: ${error.message}`);

		return sections?.map((s) => ({
			id: s.id,
			code: s.code,
			title: s.quiz_sections_i18n[0]?.title || s.code,
			description: s.quiz_sections_i18n[0]?.description || undefined,
			orderIndex: s.order_index,
			modes: s.modes as QuizMode[],
			questions: []
		})) || [];
	}

	/**
	 * Get questions for a section with translations
	 */
	async getSectionQuestions(
		sectionId: string,
		mode: QuizMode,
		locale = 'en'
	): Promise<QuizQuestion[]> {
		const { data: questions, error } = await supabaseAdmin
			.from('quiz_questions')
			.select(`
				*,
				quiz_questions_i18n!inner(text, help_text),
				quiz_answers(
					*,
					quiz_answers_i18n!inner(text)
				)
			`)
			.eq('section_id', sectionId)
			.contains('modes', [mode])
			.eq('quiz_questions_i18n.locale', locale)
			.eq('quiz_answers.quiz_answers_i18n.locale', locale)
			.order('order_index');

		if (error) throw new Error(`Failed to get questions: ${error.message}`);

		return questions?.map((q) => ({
			id: q.id,
			sectionId: q.section_id,
			code: q.code,
			text: q.quiz_questions_i18n[0]?.text || q.code,
			helpText: q.quiz_questions_i18n[0]?.help_text || undefined,
			type: q.type as QuizQuestion['type'],
			orderIndex: q.order_index,
			isGate: q.is_gate,
			modes: q.modes as QuizMode[],
			answers: q.quiz_answers?.map((a: Record<string, unknown>) => ({
				id: a.id as string,
				questionId: a.question_id as string,
				code: a.code as string,
				text: (a.quiz_answers_i18n as Array<{ text: string }>)?.[0]?.text || (a.code as string),
				orderIndex: a.order_index as number,
				isExclusive: a.is_exclusive as boolean
			})) || []
		})) || [];
	}

	/**
	 * Get gate rules for a session
	 */
	async getGateRules(): Promise<GateRule[]> {
		const { data, error } = await supabaseAdmin.from('gate_rules').select(`
			*,
			quiz_questions!inner(code)
		`);

		if (error) throw new Error(`Failed to get gate rules: ${error.message}`);

		return data?.map((r) => ({
			id: r.id,
			questionId: r.question_id,
			condition: r.condition as GateRule['condition'],
			skipsSections: r.skips_sections || [],
			skipsQuestions: r.skips_questions || []
		})) || [];
	}

	/**
	 * Save a response
	 */
	async saveResponse(
		sessionId: string,
		questionId: string,
		questionCode: string,
		answerCodes: string[],
		scaleValue?: number,
		textValue?: string
	): Promise<QuizResponse> {
		const { data, error } = await supabaseAdmin
			.from('quiz_responses')
			.upsert(
				{
					session_id: sessionId,
					question_id: questionId,
					answer_codes: answerCodes,
					scale_value: scaleValue ?? null,
					text_value: textValue ?? null
				},
				{ onConflict: 'session_id,question_id' }
			)
			.select()
			.single();

		if (error) throw new Error(`Failed to save response: ${error.message}`);

		return {
			id: data.id,
			sessionId: data.session_id,
			questionId: data.question_id,
			questionCode,
			answerCodes: data.answer_codes,
			scaleValue: data.scale_value ?? undefined,
			textValue: data.text_value ?? undefined,
			respondedAt: new Date(data.responded_at)
		};
	}

	/**
	 * Get all responses for a session
	 */
	async getResponses(sessionId: string): Promise<QuizResponse[]> {
		const { data, error } = await supabaseAdmin
			.from('quiz_responses')
			.select(`
				*,
				quiz_questions!inner(code)
			`)
			.eq('session_id', sessionId);

		if (error) throw new Error(`Failed to get responses: ${error.message}`);

		return data?.map((r) => ({
			id: r.id,
			sessionId: r.session_id,
			questionId: r.question_id,
			questionCode: r.quiz_questions.code,
			answerCodes: r.answer_codes,
			scaleValue: r.scale_value ?? undefined,
			textValue: r.text_value ?? undefined,
			respondedAt: new Date(r.responded_at)
		})) || [];
	}

	/**
	 * Update session progress
	 */
	async updateSessionProgress(
		sessionId: string,
		sectionIndex: number,
		questionIndex: number,
		skippedSections: string[],
		skippedQuestions: string[]
	): Promise<void> {
		const { error } = await supabaseAdmin
			.from('quiz_sessions')
			.update({
				current_section_index: sectionIndex,
				current_question_index: questionIndex,
				skipped_sections: skippedSections,
				skipped_questions: skippedQuestions
			})
			.eq('id', sessionId);

		if (error) throw new Error(`Failed to update session: ${error.message}`);
	}

	/**
	 * Mark session as complete and calculate results
	 */
	async completeSession(sessionId: string, locale = 'en'): Promise<QuizResult> {
		// Get all responses
		const responses = await this.getResponses(sessionId);

		// Debug logging (development only)
		if (import.meta.env.DEV) {
			console.log('=== COMPLETION DEBUG ===');
			console.log('Session ID:', sessionId);
			console.log('Total responses:', responses.length);
			console.log(
				'Responses:',
				responses.map((r) => ({ code: r.questionCode, answers: r.answerCodes }))
			);
		}

		// Create response map for scoring
		const responseMap = createResponseMap(
			responses.map((r) => ({
				questionCode: r.questionCode,
				answerCodes: r.answerCodes,
				scaleValue: r.scaleValue
			}))
		);

		// Calculate scores
		const scoringResult = this.calculator.calculate(responseMap);

		// Debug logging (development only)
		if (import.meta.env.DEV) {
			console.log('Overall score:', scoringResult.overallScore, scoringResult.overallRiskLevel);
			console.log('Top risks:', scoringResult.topRisks);
			console.log('Triggered rules:', scoringResult.triggeredRules.length);
			console.log('=== END COMPLETION DEBUG ===');
		}

		// Generate medical flags
		const medicalFlags = this.flagsGenerator.generate(responseMap, locale);

		// Generate recommendations (simplified - in production would be more sophisticated)
		const recommendations = this.generateRecommendations(scoringResult.topRisks, locale);

		// Save results
		const { data, error } = await supabaseAdmin
			.from('quiz_results')
			.insert({
				session_id: sessionId,
				overall_score: scoringResult.overallScore,
				category_scores: scoringResult.categoryScores,
				top_risks: scoringResult.topRisks,
				medical_flags: medicalFlags,
				recommendations
			})
			.select()
			.single();

		if (error) throw new Error(`Failed to save results: ${error.message}`);

		// Mark session as complete
		await supabaseAdmin
			.from('quiz_sessions')
			.update({ completed_at: new Date().toISOString() })
			.eq('id', sessionId);

		return {
			id: data.id,
			sessionId: data.session_id,
			overallScore: data.overall_score,
			categoryScores: data.category_scores as QuizResult['categoryScores'],
			topRisks: data.top_risks,
			medicalFlags: data.medical_flags as QuizResult['medicalFlags'],
			recommendations: data.recommendations as QuizResult['recommendations'],
			createdAt: new Date(data.created_at)
		};
	}

	/**
	 * Get results for a session
	 */
	async getResults(sessionId: string): Promise<QuizResult | null> {
		const { data, error } = await supabaseAdmin
			.from('quiz_results')
			.select()
			.eq('session_id', sessionId)
			.single();

		if (error || !data) return null;

		return {
			id: data.id,
			sessionId: data.session_id,
			overallScore: data.overall_score,
			categoryScores: data.category_scores as QuizResult['categoryScores'],
			topRisks: data.top_risks,
			medicalFlags: data.medical_flags as QuizResult['medicalFlags'],
			recommendations: data.recommendations as QuizResult['recommendations'],
			createdAt: new Date(data.created_at)
		};
	}

	/**
	 * Calculate progress
	 * Note: totalQuestions should already exclude skipped questions
	 */
	calculateProgress(
		totalQuestions: number,
		answeredCount: number,
		skippedCount: number,
		currentSectionName: string,
		sectionsCompleted: number,
		totalSections: number
	): QuizProgress {
		// totalQuestions already excludes skipped questions, so use it directly
		const percentage = totalQuestions > 0 ? Math.round((answeredCount / totalQuestions) * 100) : 0;
		// Cap percentage at 100 to handle edge cases
		const cappedPercentage = Math.min(percentage, 100);

		return {
			totalQuestions,
			answeredQuestions: Math.min(answeredCount, totalQuestions),
			skippedQuestions: skippedCount,
			percentage: cappedPercentage,
			currentSectionName,
			sectionsCompleted,
			totalSections
		};
	}

	// Private helpers
	private mapSession(data: Record<string, unknown>): QuizSession {
		return {
			id: data.id as string,
			userId: data.user_id as string | undefined,
			mode: data.mode as QuizMode,
			locale: data.locale as string,
			startedAt: new Date(data.started_at as string),
			completedAt: data.completed_at ? new Date(data.completed_at as string) : undefined,
			currentSectionIndex: data.current_section_index as number,
			currentQuestionIndex: data.current_question_index as number,
			skippedSections: data.skipped_sections as string[],
			skippedQuestions: data.skipped_questions as string[]
		};
	}

	private generateRecommendations(topRisks: string[], locale: string): Recommendation[] {
		const recommendations: Record<string, Recommendation> = {
			R1_STRESS_PSYCH: {
				categoryCode: 'R1_STRESS_PSYCH',
				priority: 1,
				title: locale === 'ro' ? 'Gestionarea Stresului' : 'Stress Management',
				description:
					locale === 'ro'
						? 'Stresul și anxietatea afectează semnificativ somnul dumneavoastră.'
						: 'Stress and anxiety are significantly affecting your sleep.',
				actionItems:
					locale === 'ro'
						? [
								'Practicați tehnici de relaxare înainte de culcare',
								'Considerați meditația sau exercițiile de respirație',
								'Țineți un jurnal pentru a procesa grijile'
							]
						: [
								'Practice relaxation techniques before bed',
								'Consider meditation or breathing exercises',
								'Keep a worry journal to process concerns'
							]
			},
			R2_SLEEP_DISORDERS: {
				categoryCode: 'R2_SLEEP_DISORDERS',
				priority: 1,
				title: locale === 'ro' ? 'Consultație Medicală' : 'Medical Consultation',
				description:
					locale === 'ro'
						? 'Simptomele sugerează o posibilă tulburare de somn.'
						: 'Symptoms suggest a possible sleep disorder.',
				actionItems:
					locale === 'ro'
						? [
								'Programați o consultație cu un specialist în somn',
								'Considerați un studiu de somn (polisomnografie)',
								'Documentați simptomele pentru medic'
							]
						: [
								'Schedule a consultation with a sleep specialist',
								'Consider a sleep study (polysomnography)',
								'Document symptoms for your doctor'
							]
			},
			R3_LIFESTYLE: {
				categoryCode: 'R3_LIFESTYLE',
				priority: 2,
				title: locale === 'ro' ? 'Ajustări ale Stilului de Viață' : 'Lifestyle Adjustments',
				description:
					locale === 'ro'
						? 'Schimbări simple ale stilului de viață pot îmbunătăți somnul.'
						: 'Simple lifestyle changes can improve your sleep.',
				actionItems:
					locale === 'ro'
						? [
								'Faceți exerciții regulate, dar nu aproape de culcare',
								'Limitați expunerea la ecrane cu 1 oră înainte de somn',
								'Stabiliți o rutină relaxantă înainte de culcare'
							]
						: [
								'Exercise regularly but not close to bedtime',
								'Limit screen exposure 1 hour before bed',
								'Establish a relaxing pre-sleep routine'
							]
			},
			R4_ENVIRONMENT: {
				categoryCode: 'R4_ENVIRONMENT',
				priority: 2,
				title: locale === 'ro' ? 'Optimizarea Mediului de Somn' : 'Sleep Environment Optimization',
				description:
					locale === 'ro'
						? 'Mediul dormitorului poate fi îmbunătățit pentru un somn mai bun.'
						: 'Your bedroom environment can be improved for better sleep.',
				actionItems:
					locale === 'ro'
						? [
								'Mențineți dormitorul răcoros (16-19°C)',
								'Folosiți perdele opace sau o mască de somn',
								'Considerați dopuri de urechi sau zgomot alb'
							]
						: [
								'Keep bedroom cool (60-67°F/16-19°C)',
								'Use blackout curtains or a sleep mask',
								'Consider earplugs or white noise'
							]
			},
			R6_SUBSTANCES: {
				categoryCode: 'R6_SUBSTANCES',
				priority: 1,
				title: locale === 'ro' ? 'Reducerea Substanțelor' : 'Substance Reduction',
				description:
					locale === 'ro'
						? 'Anumite substanțe interferează cu somnul.'
						: 'Certain substances are interfering with your sleep.',
				actionItems:
					locale === 'ro'
						? [
								'Limitați cafeina după prânz',
								'Evitați alcoolul cu 3 ore înainte de culcare',
								'Discutați efectele secundare ale medicamentelor cu medicul'
							]
						: [
								'Limit caffeine after noon',
								'Avoid alcohol within 3 hours of bedtime',
								'Discuss medication side effects with your doctor'
							]
			},
			R7_CIRCADIAN: {
				categoryCode: 'R7_CIRCADIAN',
				priority: 1,
				title: locale === 'ro' ? 'Reglarea Ritmului Circadian' : 'Circadian Rhythm Regulation',
				description:
					locale === 'ro'
						? 'Ceasul dumneavoastră intern are nevoie de reglare.'
						: 'Your internal clock needs regulation.',
				actionItems:
					locale === 'ro'
						? [
								'Mențineți ore constante de somn/trezire',
								'Obțineți expunere la lumină dimineața',
								'Considerați terapia cu lumină pentru munca în schimburi'
							]
						: [
								'Maintain consistent sleep/wake times',
								'Get morning light exposure',
								'Consider light therapy for shift work'
							]
			}
		};

		return topRisks
			.filter((risk) => recommendations[risk])
			.map((risk) => recommendations[risk])
			.sort((a, b) => a.priority - b.priority);
	}
}

// Singleton instance
export const quizService = new QuizService();
