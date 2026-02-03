import type {
	QuizSession,
	QuizSection,
	QuizQuestion,
	QuizResponse,
	QuizProgress,
	QuizResult,
	QuizMode
} from '$lib/types/quiz';

/**
 * Quiz state store using Svelte 5 runes
 */
class QuizStore {
	// State
	session = $state<QuizSession | null>(null);
	currentSection = $state<QuizSection | null>(null);
	currentQuestion = $state<QuizQuestion | null>(null);
	responses = $state<Map<string, QuizResponse>>(new Map());
	progress = $state<QuizProgress>({
		totalQuestions: 0,
		answeredQuestions: 0,
		skippedQuestions: 0,
		percentage: 0,
		currentSectionName: '',
		sectionsCompleted: 0,
		totalSections: 0
	});
	result = $state<QuizResult | null>(null);
	isLoading = $state(false);
	error = $state<string | null>(null);
	isComplete = $state(false);

	// Derived
	hasSession = $derived(this.session !== null);
	canGoBack = $derived(this.responses.size > 0 && !this.isComplete);
	currentAnswers = $derived(() => {
		if (!this.currentQuestion) return [];
		const response = this.responses.get(this.currentQuestion.code);
		return response?.answerCodes || [];
	});

	/**
	 * Start a new quiz session
	 */
	async startQuiz(mode: QuizMode, locale = 'en'): Promise<void> {
		this.isLoading = true;
		this.error = null;

		try {
			const response = await fetch('/api/quiz/sessions', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ mode, locale })
			});

			if (!response.ok) {
				const err = await response.json();
				throw new Error(err.message || 'Failed to start quiz');
			}

			const data = await response.json();

			this.session = data.session;
			this.currentSection = data.section;
			this.currentQuestion = data.question;
			this.progress = {
				totalQuestions: 0,
				answeredQuestions: 0,
				skippedQuestions: 0,
				percentage: 0,
				currentSectionName: data.section.title,
				sectionsCompleted: 0,
				totalSections: data.totalSections
			};
			this.responses = new Map();
			this.result = null;
			this.isComplete = false;
		} catch (err) {
			this.error = err instanceof Error ? err.message : 'An error occurred';
			throw err;
		} finally {
			this.isLoading = false;
		}
	}

	/**
	 * Submit an answer and get next question
	 */
	async submitAnswer(
		answerCodes: string[],
		scaleValue?: number,
		textValue?: string
	): Promise<void> {
		if (!this.session || !this.currentQuestion) {
			throw new Error('No active quiz session');
		}

		this.isLoading = true;
		this.error = null;

		try {
			const response = await fetch(
				`/api/quiz/sessions/${this.session.id}/responses`,
				{
					method: 'POST',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify({
						questionId: this.currentQuestion.id,
						questionCode: this.currentQuestion.code,
						answerCodes,
						scaleValue,
						textValue
					})
				}
			);

			if (!response.ok) {
				const err = await response.json();
				throw new Error(err.message || 'Failed to submit answer');
			}

			const data = await response.json();

			// Store response
			this.responses.set(this.currentQuestion.code, data.response);

			// Update progress
			if (data.progress) {
				this.progress = data.progress;
			}

			if (data.isComplete) {
				this.isComplete = true;
				this.result = data.result;
				this.currentQuestion = null;
			} else {
				this.currentSection = data.nextSection;
				this.currentQuestion = data.nextQuestion;
			}
		} catch (err) {
			this.error = err instanceof Error ? err.message : 'An error occurred';
			throw err;
		} finally {
			this.isLoading = false;
		}
	}

	/**
	 * Load existing session
	 */
	async loadSession(sessionId: string): Promise<void> {
		this.isLoading = true;
		this.error = null;

		try {
			const response = await fetch(`/api/quiz/sessions/${sessionId}`);

			if (!response.ok) {
				const err = await response.json();
				throw new Error(err.message || 'Failed to load session');
			}

			const data = await response.json();

			this.session = data.session;
			this.progress = data.progress;
			this.isComplete = data.isComplete;

			if (data.isComplete) {
				// Load results
				const resultsResponse = await fetch(
					`/api/quiz/sessions/${sessionId}/results`
				);
				if (resultsResponse.ok) {
					const resultsData = await resultsResponse.json();
					this.result = resultsData.result;
				}
			}
		} catch (err) {
			this.error = err instanceof Error ? err.message : 'An error occurred';
			throw err;
		} finally {
			this.isLoading = false;
		}
	}

	/**
	 * Reset quiz state
	 */
	reset(): void {
		this.session = null;
		this.currentSection = null;
		this.currentQuestion = null;
		this.responses = new Map();
		this.progress = {
			totalQuestions: 0,
			answeredQuestions: 0,
			skippedQuestions: 0,
			percentage: 0,
			currentSectionName: '',
			sectionsCompleted: 0,
			totalSections: 0
		};
		this.result = null;
		this.isLoading = false;
		this.error = null;
		this.isComplete = false;
	}
}

export const quizStore = new QuizStore();
