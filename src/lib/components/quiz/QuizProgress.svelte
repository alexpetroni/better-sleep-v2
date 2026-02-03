<script lang="ts">
	import { Progress } from '$lib/components/ui';
	import type { QuizProgress } from '$lib/types/quiz';

	interface Props {
		progress: QuizProgress;
	}

	let { progress }: Props = $props();
</script>

<div class="space-y-2">
	<div class="flex justify-between text-sm text-muted-foreground">
		<span>{progress.currentSectionName}</span>
		<span>
			{progress.answeredQuestions} / {progress.totalQuestions}
		</span>
	</div>
	<Progress value={progress.percentage} />
	<div class="flex justify-between text-xs text-muted-foreground">
		<span>Section {progress.sectionsCompleted + 1} of {progress.totalSections}</span>
		<span>{progress.percentage}% complete</span>
	</div>
</div>
