<script lang="ts">
	import { cn } from '$lib/utils';
	import type { QuizAnswer } from '$lib/types/quiz';
	import { Check } from 'lucide-svelte';

	interface Props {
		answers: QuizAnswer[];
		selected: string[];
		onSelect: (code: string) => void;
	}

	let { answers, selected, onSelect }: Props = $props();

	function isSelected(code: string): boolean {
		return selected.includes(code);
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
					: 'border-border hover:border-primary/50 hover:bg-accent/50'
			)}
			onclick={() => onSelect(answer.code)}
		>
			<div
				class={cn(
					'mr-4 flex h-5 w-5 items-center justify-center rounded-full border-2 transition-colors',
					isSelected(answer.code)
						? 'border-primary bg-primary text-primary-foreground'
						: 'border-muted-foreground'
				)}
			>
				{#if isSelected(answer.code)}
					<Check class="h-3 w-3" />
				{/if}
			</div>
			<span class="flex-1 text-sm font-medium">{answer.text}</span>
		</button>
	{/each}
</div>
