<script lang="ts">
	interface Props {
		value: string;
		placeholder?: string;
		onChange: (value: string) => void;
	}

	let { value, placeholder = 'Enter your answer...', onChange }: Props = $props();

	function handleInput(event: Event) {
		const target = event.target as HTMLTextAreaElement;
		onChange(target.value);
	}
</script>

<div class="space-y-2">
	<textarea
		class="min-h-[120px] w-full rounded-lg border-2 border-border bg-background p-4 text-sm placeholder:text-muted-foreground focus:border-primary focus:outline-none focus:ring-2 focus:ring-ring"
		{placeholder}
		{value}
		oninput={handleInput}
	></textarea>
	<p class="text-right text-xs text-muted-foreground">
		{value?.length || 0} characters
	</p>
</div>
