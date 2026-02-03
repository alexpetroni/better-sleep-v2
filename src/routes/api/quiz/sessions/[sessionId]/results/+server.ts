import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { quizService } from '$lib/server/quiz';

// GET /api/quiz/sessions/[sessionId]/results - Get quiz results
export const GET: RequestHandler = async ({ params }) => {
	const { sessionId } = params;

	try {
		const session = await quizService.getSession(sessionId);
		if (!session) {
			throw error(404, { message: 'Session not found' });
		}

		const result = await quizService.getResults(sessionId);
		if (!result) {
			throw error(404, { message: 'Results not found. Quiz may not be complete.' });
		}

		return json({
			session,
			result
		});
	} catch (err) {
		console.error('Failed to get results:', err);
		if (err && typeof err === 'object' && 'status' in err) throw err;
		throw error(500, { message: 'Failed to get results' });
	}
};

// POST /api/quiz/sessions/[sessionId]/results - Force calculate results (for incomplete quizzes)
export const POST: RequestHandler = async ({ params }) => {
	const { sessionId } = params;

	try {
		const session = await quizService.getSession(sessionId);
		if (!session) {
			throw error(404, { message: 'Session not found' });
		}

		// Check if already has results
		const existingResult = await quizService.getResults(sessionId);
		if (existingResult) {
			return json({
				session,
				result: existingResult,
				message: 'Results already exist'
			});
		}

		// Calculate and save results
		const result = await quizService.completeSession(sessionId, session.locale);

		return json({
			session,
			result
		});
	} catch (err) {
		console.error('Failed to calculate results:', err);
		if (err && typeof err === 'object' && 'status' in err) throw err;
		throw error(500, { message: 'Failed to calculate results' });
	}
};
