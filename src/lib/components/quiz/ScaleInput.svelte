<script lang="ts">
	import { cn } from '$lib/utils';

	interface Props {
		min?: number;
		max?: number;
		step?: number;
		value: number | undefined;
		minLabel?: string;
		maxLabel?: string;
		onChange: (value: number) => void;
	}

	let {
		min = 0,
		max = 10,
		step = 1,
		value,
		minLabel,
		maxLabel,
		onChange
	}: Props = $props();

	const steps = $derived(() => {
		const arr = [];
		for (let i = min; i <= max; i += step) {
			arr.push(i);
		}
		return arr;
	});

	function handleClick(val: number) {
		onChange(val);
	}
</script>

<div class="space-y-4">
	<div class="flex justify-between text-sm text-muted-foreground">
		<span>{minLabel || min}</span>
		<span>{maxLabel || max}</span>
	</div>

	<div class="flex justify-between gap-1">
		{#each steps() as stepValue (stepValue)}
			<button
				type="button"
				class={cn(
					'flex h-12 flex-1 items-center justify-center rounded-lg border-2 text-sm font-medium transition-all',
					value === stepValue
						? 'border-primary bg-primary text-primary-foreground'
						: 'border-border hover:border-primary/50 hover:bg-accent/50'
				)}
				onclick={() => handleClick(stepValue)}
			>
				{stepValue}
			</button>
		{/each}
	</div>

	{#if value !== undefined}
		<p class="text-center text-sm">
			Selected: <span class="font-semibold">{value}</span>
		</p>
	{/if}
</div>
