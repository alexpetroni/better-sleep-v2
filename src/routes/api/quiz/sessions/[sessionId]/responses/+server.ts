import { json, error } from '@sveltejs/kit';
import { dev } from '$app/environment';
import type { RequestHandler } from './$types';
import { quizService, GateEvaluator, defaultGateRules } from '$lib/server/quiz';
import { z } from 'zod';

const submitResponseSchema = z.object({
	questionId: z.string().uuid(),
	questionCode: z.string(),
	answerCodes: z.array(z.string()).optional().default([]),
	scaleValue: z.number().optional(),
	textValue: z.string().optional()
});

// POST /api/quiz/sessions/[sessionId]/responses - Submit a response
export const POST: RequestHandler = async ({ params, request }) => {
	const { sessionId } = params;

	try {
		const body = await request.json();
		const parsed = submitResponseSchema.safeParse(body);

		if (!parsed.success) {
			throw error(400, { message: 'Invalid request body', errors: parsed.error.flatten() });
		}

		const { questionId, questionCode, answerCodes, scaleValue, textValue } = parsed.data;

		// Get session
		const session = await quizService.getSession(sessionId);
		if (!session) {
			throw error(404, { message: 'Session not found' });
		}

		if (session.completedAt) {
			throw error(400, { message: 'Quiz already completed' });
		}

		// Save response
		const response = await quizService.saveResponse(
			sessionId,
			questionId,
			questionCode,
			answerCodes,
			scaleValue,
			textValue
		);

		// Get all responses for gate evaluation
		const allResponses = await quizService.getResponses(sessionId);

		// Evaluate gate rules
		const gateEvaluator = new GateEvaluator(defaultGateRules);
		const { skipSections, skipQuestions } = gateEvaluator.evaluate(allResponses);

		// Merge with existing skips
		const newSkippedSections = [...new Set([...session.skippedSections, ...skipSections])];
		const newSkippedQuestions = [...new Set([...session.skippedQuestions, ...skipQuestions])];

		// Get sections and find next question
		const sections = await quizService.getSections(session.mode, session.locale);

		// Find current position and next question
		let currentSectionIndex = session.currentSectionIndex;
		let currentQuestionIndex = session.currentQuestionIndex;

		// Get current section questions
		let currentSection = sections[currentSectionIndex];
		let questions = await quizService.getSectionQuestions(
			currentSection.id,
			session.mode,
			session.locale
		);

		// Move to next question
		currentQuestionIndex++;

		// Skip questions in skip list
		while (currentQuestionIndex < questions.length) {
			if (!newSkippedQuestions.includes(questions[currentQuestionIndex].code)) {
				break;
			}
			currentQuestionIndex++;
		}

		// If we've exhausted current section, move to next
		while (currentQuestionIndex >= questions.length) {
			currentSectionIndex++;

			// Skip sections in skip list
			while (
				currentSectionIndex < sections.length &&
				newSkippedSections.includes(sections[currentSectionIndex].code)
			) {
				currentSectionIndex++;
			}

			// Check if quiz is complete
			if (currentSectionIndex >= sections.length) {
				// Calculate final valid counts for completion
				let finalTotalQuestions = 0;
				const finalValidCodes = new Set<string>();
				for (const section of sections) {
					if (!newSkippedSections.includes(section.code)) {
						const sectionQuestions = await quizService.getSectionQuestions(
							section.id,
							session.mode,
							session.locale
						);
						for (const q of sectionQuestions) {
							if (!newSkippedQuestions.includes(q.code)) {
								finalValidCodes.add(q.code);
								finalTotalQuestions++;
							}
						}
					}
				}
				const finalValidResponses = allResponses.filter(
					(r) => finalValidCodes.has(r.questionCode)
				).length;

				// Complete the quiz
				const result = await quizService.completeSession(sessionId, session.locale);

				return json({
					response,
					isComplete: true,
					result,
					progress: quizService.calculateProgress(
						finalTotalQuestions,
						finalValidResponses,
						newSkippedQuestions.length,
						'Complete',
						sections.length,
						sections.length
					)
				});
			}

			// Get next section's questions
			currentSection = sections[currentSectionIndex];
			questions = await quizService.getSectionQuestions(
				currentSection.id,
				session.mode,
				session.locale
			);
			currentQuestionIndex = 0;

			// Skip questions in skip list
			while (currentQuestionIndex < questions.length) {
				if (!newSkippedQuestions.includes(questions[currentQuestionIndex].code)) {
					break;
				}
				currentQuestionIndex++;
			}
		}

		// Update session progress
		await quizService.updateSessionProgress(
			sessionId,
			currentSectionIndex,
			currentQuestionIndex,
			newSkippedSections,
			newSkippedQuestions
		);

		const nextQuestion = questions[currentQuestionIndex];

		// Calculate progress
		let totalQuestions = 0;
		const validQuestionCodes = new Set<string>();

		for (const section of sections) {
			if (!newSkippedSections.includes(section.code)) {
				const sectionQuestions = await quizService.getSectionQuestions(
					section.id,
					session.mode,
					session.locale
				);
				for (const q of sectionQuestions) {
					if (!newSkippedQuestions.includes(q.code)) {
						validQuestionCodes.add(q.code);
						totalQuestions++;
					}
				}
			}
		}

		// Count only responses for non-skipped questions
		// Note: allResponses already includes the current response (fetched after save)
		const validResponseCount = allResponses.filter(
			(r) => validQuestionCodes.has(r.questionCode)
		).length;

		// Debug logging (development only)
		if (dev) {
			console.log('=== PROGRESS DEBUG ===');
			console.log('Total valid questions:', totalQuestions);
			console.log('Valid question codes:', validQuestionCodes.size);
			console.log('All responses count:', allResponses.length);
			console.log('Valid response count:', validResponseCount);
			console.log('Skipped sections:', newSkippedSections);
			console.log('Skipped questions:', newSkippedQuestions);
			const invalidResponses = allResponses.filter((r) => !validQuestionCodes.has(r.questionCode));
			if (invalidResponses.length > 0) {
				console.log(
					'WARNING: Responses for skipped questions:',
					invalidResponses.map((r) => r.questionCode)
				);
			}
			console.log('=== END PROGRESS DEBUG ===');
		}

		const progress = quizService.calculateProgress(
			totalQuestions,
			validResponseCount,
			newSkippedQuestions.length,
			currentSection.title,
			currentSectionIndex,
			sections.length
		);

		return json({
			response,
			isComplete: false,
			nextQuestion,
			nextSection: {
				...currentSection,
				questions
			},
			progress,
			skippedSections: [...newSkippedSections],
			skippedQuestions: [...newSkippedQuestions]
		});
	} catch (err) {
		console.error('Failed to submit response:', err);
		if (err && typeof err === 'object' && 'status' in err) throw err;
		throw error(500, { message: 'Failed to submit response' });
	}
};

// GET /api/quiz/sessions/[sessionId]/responses - Get all responses
export const GET: RequestHandler = async ({ params }) => {
	const { sessionId } = params;

	try {
		const session = await quizService.getSession(sessionId);
		if (!session) {
			throw error(404, { message: 'Session not found' });
		}

		const responses = await quizService.getResponses(sessionId);

		return json({ responses });
	} catch (err) {
		console.error('Failed to get responses:', err);
		if (err && typeof err === 'object' && 'status' in err) throw err;
		throw error(500, { message: 'Failed to get responses' });
	}
};
