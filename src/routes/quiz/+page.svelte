<script lang="ts">
	import { quizStore } from '$lib/stores/quiz.svelte';
	import { Button, Card } from '$lib/components/ui';
	import { QuizProgress, QuizQuestion, QuizResults } from '$lib/components/quiz';
	import { Moon, Clock, Zap, AlertCircle } from 'lucide-svelte';
	import type { QuizMode } from '$lib/types/database';

	type QuizStage = 'select-mode' | 'quiz' | 'results';

	let stage = $state<QuizStage>('select-mode');

	async function startQuiz(mode: QuizMode) {
		try {
			await quizStore.startQuiz(mode, 'en');
			stage = 'quiz';
		} catch (err) {
			console.error('Failed to start quiz:', err);
		}
	}

	async function handleSubmit(answerCodes: string[], scaleValue?: number, textValue?: string) {
		try {
			await quizStore.submitAnswer(answerCodes, scaleValue, textValue);
			if (quizStore.isComplete) {
				stage = 'results';
			}
		} catch (err) {
			console.error('Failed to submit answer:', err);
		}
	}

	function retakeQuiz() {
		quizStore.reset();
		stage = 'select-mode';
	}
</script>

<div class="mx-auto max-w-4xl py-8">
	{#if stage === 'select-mode'}
		<!-- Mode Selection -->
		<div class="text-center">
			<h1 class="mb-4 text-3xl font-bold">Choose Your Assessment Type</h1>
			<p class="mb-8 text-muted-foreground">
				Select the assessment that best fits your needs and available time.
			</p>
		</div>

		<div class="grid gap-6 md:grid-cols-2">
			<!-- Rapid Mode -->
			<Card class="relative overflow-hidden p-6 transition-all hover:border-primary hover:shadow-lg">
				<div class="absolute right-4 top-4 rounded-full bg-primary/10 px-3 py-1 text-xs font-medium text-primary">
					Recommended
				</div>
				<div class="mb-4 inline-flex rounded-lg bg-primary/10 p-3">
					<Zap class="h-6 w-6 text-primary" />
				</div>
				<h2 class="mb-2 text-xl font-semibold">Quick Assessment</h2>
				<p class="mb-4 text-sm text-muted-foreground">
					A focused evaluation of the most common sleep factors.
					Perfect if you're short on time or want a quick overview.
				</p>
				<ul class="mb-6 space-y-2 text-sm">
					<li class="flex items-center gap-2">
						<Clock class="h-4 w-4 text-muted-foreground" />
						<span>5-7 minutes</span>
					</li>
					<li class="flex items-center gap-2">
						<Moon class="h-4 w-4 text-muted-foreground" />
						<span>30-40 questions</span>
					</li>
				</ul>
				<Button class="w-full" onclick={() => startQuiz('RAPID')}>
					Start Quick Assessment
				</Button>
			</Card>

			<!-- Complete Mode -->
			<Card class="p-6 transition-all hover:border-primary hover:shadow-lg">
				<div class="mb-4 inline-flex rounded-lg bg-secondary p-3">
					<Moon class="h-6 w-6" />
				</div>
				<h2 class="mb-2 text-xl font-semibold">Comprehensive Assessment</h2>
				<p class="mb-4 text-sm text-muted-foreground">
					A thorough analysis covering all 78 sleep-affecting factors.
					Best for detailed insights and personalized recommendations.
				</p>
				<ul class="mb-6 space-y-2 text-sm">
					<li class="flex items-center gap-2">
						<Clock class="h-4 w-4 text-muted-foreground" />
						<span>10-15 minutes</span>
					</li>
					<li class="flex items-center gap-2">
						<Moon class="h-4 w-4 text-muted-foreground" />
						<span>50-70 questions</span>
					</li>
				</ul>
				<Button variant="outline" class="w-full" onclick={() => startQuiz('COMPLETE')}>
					Start Comprehensive Assessment
				</Button>
			</Card>
		</div>

		<Card class="mt-8 bg-muted/50 p-4">
			<div class="flex items-start gap-3">
				<AlertCircle class="mt-0.5 h-5 w-5 flex-shrink-0 text-muted-foreground" />
				<div class="text-sm text-muted-foreground">
					<p class="font-medium text-foreground">Privacy Notice</p>
					<p>
						Your responses are used only to generate your personalized assessment.
						We do not store personal health information without your explicit consent.
					</p>
				</div>
			</div>
		</Card>
	{:else if stage === 'quiz'}
		<!-- Quiz in Progress -->
		<div class="space-y-6">
			<!-- Progress bar -->
			<QuizProgress progress={quizStore.progress} />

			<!-- Current question -->
			{#if quizStore.currentQuestion}
				<QuizQuestion
					question={quizStore.currentQuestion}
					onSubmit={handleSubmit}
					isLoading={quizStore.isLoading}
				/>
			{/if}

			<!-- Error display -->
			{#if quizStore.error}
				<Card class="border-destructive bg-destructive/10 p-4">
					<div class="flex items-center gap-2 text-destructive">
						<AlertCircle class="h-5 w-5" />
						<p>{quizStore.error}</p>
					</div>
				</Card>
			{/if}
		</div>
	{:else if stage === 'results'}
		<!-- Results -->
		{#if quizStore.result}
			<QuizResults result={quizStore.result} onRetake={retakeQuiz} />
		{:else}
			<Card class="p-6 text-center">
				<p>Loading results...</p>
			</Card>
		{/if}
	{/if}
</div>
