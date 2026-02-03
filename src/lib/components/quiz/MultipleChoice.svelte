<script lang="ts">
	import { cn } from '$lib/utils';
	import type { QuizAnswer } from '$lib/types/quiz';
	import { Check, Square, CheckSquare } from 'lucide-svelte';

	interface Props {
		answers: QuizAnswer[];
		selected: string[];
		onToggle: (code: string) => void;
	}

	let { answers, selected, onToggle }: Props = $props();

	function isSelected(code: string): boolean {
		return selected.includes(code);
	}

	function handleToggle(answer: QuizAnswer) {
		// If this is an exclusive answer (like "None of the above"), clear others
		if (answer.isExclusive && !isSelected(answer.code)) {
			// Clear all selections and select only this one
			selected.forEach((code) => {
				if (code !== answer.code) onToggle(code);
			});
		} else if (!answer.isExclusive) {
			// If selecting a non-exclusive answer, deselect any exclusive answers
			answers
				.filter((a) => a.isExclusive && isSelected(a.code))
				.forEach((a) => onToggle(a.code));
		}
		onToggle(answer.code);
	}
</script>

<div class="space-y-3">
	{#each answers as answer (answer.id)}
		<button
			type="button"
			class={cn(
				'relative flex w-full cursor-pointer items-center rounded-lg border-2 p-4 text-left transition-all',
				isSelected(answer.code)
					? 'border-primary bg-primary/5'
					: 'border-border hover:border-primary/50 hover:bg-accent/50',
				answer.isExclusive && 'border-dashed'
			)}
			onclick={() => handleToggle(answer)}
		>
			<div class="mr-4 flex h-5 w-5 items-center justify-center text-muted-foreground">
				{#if isSelected(answer.code)}
					<CheckSquare class="h-5 w-5 text-primary" />
				{:else}
					<Square class="h-5 w-5" />
				{/if}
			</div>
			<span class="flex-1 text-sm font-medium">
				{answer.text}
				{#if answer.isExclusive}
					<span class="ml-2 text-xs text-muted-foreground">(exclusive)</span>
				{/if}
			</span>
		</button>
	{/each}
</div>

<p class="mt-2 text-center text-xs text-muted-foreground">
	Select all that apply
</p>
