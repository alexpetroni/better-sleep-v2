import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { quizService } from '$lib/server/quiz';
import type { QuizMode } from '$lib/types/database';
import { z } from 'zod';

const createSessionSchema = z.object({
	mode: z.enum(['RAPID', 'COMPLETE']),
	locale: z.string().default('en'),
	userId: z.string().uuid().optional()
});

// POST /api/quiz/sessions - Create new session
export const POST: RequestHandler = async ({ request }) => {
	try {
		const body = await request.json();
		const parsed = createSessionSchema.safeParse(body);

		if (!parsed.success) {
			throw error(400, { message: 'Invalid request body', errors: parsed.error.flatten() });
		}

		const { mode, locale, userId } = parsed.data;

		// Create session
		const session = await quizService.createSession(mode as QuizMode, locale, userId);

		// Get sections and first question
		const sections = await quizService.getSections(mode as QuizMode, locale);
		if (sections.length === 0) {
			throw error(500, { message: 'No sections found for quiz mode' });
		}

		const firstSection = sections[0];
		const questions = await quizService.getSectionQuestions(firstSection.id, mode as QuizMode, locale);

		if (questions.length === 0) {
			throw error(500, { message: 'No questions found in first section' });
		}

		return json({
			session,
			section: { ...firstSection, questions },
			question: questions[0],
			totalSections: sections.length
		});
	} catch (err) {
		console.error('Failed to create session:', err);
		if (err && typeof err === 'object' && 'status' in err) throw err;
		throw error(500, { message: 'Failed to create quiz session' });
	}
};
