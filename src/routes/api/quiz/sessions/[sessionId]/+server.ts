import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { quizService } from '$lib/server/quiz';

// GET /api/quiz/sessions/[sessionId] - Get session details
export const GET: RequestHandler = async ({ params }) => {
	const { sessionId } = params;

	try {
		const session = await quizService.getSession(sessionId);

		if (!session) {
			throw error(404, { message: 'Session not found' });
		}

		// Get current progress
		const sections = await quizService.getSections(session.mode, session.locale);
		const responses = await quizService.getResponses(sessionId);

		// Calculate total questions (excluding skipped)
		let totalQuestions = 0;
		for (const section of sections) {
			if (!session.skippedSections.includes(section.code)) {
				const questions = await quizService.getSectionQuestions(
					section.id,
					session.mode,
					session.locale
				);
				totalQuestions += questions.filter(
					(q) => !session.skippedQuestions.includes(q.code)
				).length;
			}
		}

		const currentSection = sections[session.currentSectionIndex];
		const progress = quizService.calculateProgress(
			totalQuestions,
			responses.length,
			session.skippedQuestions.length,
			currentSection?.title || '',
			session.currentSectionIndex,
			sections.length
		);

		return json({
			session,
			progress,
			isComplete: !!session.completedAt
		});
	} catch (err) {
		console.error('Failed to get session:', err);
		if (err && typeof err === 'object' && 'status' in err) throw err;
		throw error(500, { message: 'Failed to get session' });
	}
};
