<script lang="ts">
	import type { QuizQuestion } from '$lib/types/quiz';
	import { Card, Button } from '$lib/components/ui';
	import SingleChoice from './SingleChoice.svelte';
	import MultipleChoice from './MultipleChoice.svelte';
	import ScaleInput from './ScaleInput.svelte';
	import TextInput from './TextInput.svelte';
	import { HelpCircle } from 'lucide-svelte';

	interface Props {
		question: QuizQuestion;
		onSubmit: (answerCodes: string[], scaleValue?: number, textValue?: string) => void;
		isLoading?: boolean;
	}

	let { question, onSubmit, isLoading = false }: Props = $props();

	let selectedAnswers = $state<string[]>([]);
	let scaleValue = $state<number | undefined>(undefined);
	let textValue = $state('');
	let showHelp = $state(false);

	// Reset state when question changes
	$effect(() => {
		if (question) {
			selectedAnswers = [];
			scaleValue = undefined;
			textValue = '';
			showHelp = false;
		}
	});

	function handleSingleSelect(code: string) {
		selectedAnswers = [code];
	}

	function handleMultiToggle(code: string) {
		if (selectedAnswers.includes(code)) {
			selectedAnswers = selectedAnswers.filter((c) => c !== code);
		} else {
			selectedAnswers = [...selectedAnswers, code];
		}
	}

	function handleScaleChange(value: number) {
		scaleValue = value;
	}

	function handleTextChange(value: string) {
		textValue = value;
	}

	function handleSubmit() {
		if (question.type === 'SCALE') {
			onSubmit([], scaleValue, undefined);
		} else if (question.type === 'TEXT') {
			onSubmit([], undefined, textValue);
		} else {
			onSubmit(selectedAnswers, undefined, undefined);
		}
	}

	const canSubmit = $derived(() => {
		if (isLoading) return false;
		if (question.type === 'SCALE') return scaleValue !== undefined;
		if (question.type === 'TEXT') return textValue.trim().length > 0;
		return selectedAnswers.length > 0;
	});
</script>

<Card class="mx-auto max-w-2xl p-6">
	<div class="space-y-6">
		<!-- Question text -->
		<div class="space-y-2">
			<h2 class="text-xl font-semibold leading-relaxed">
				{question.text}
			</h2>
			{#if question.helpText}
				<button
					type="button"
					class="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground"
					onclick={() => (showHelp = !showHelp)}
				>
					<HelpCircle class="h-4 w-4" />
					{showHelp ? 'Hide help' : 'Show help'}
				</button>
				{#if showHelp}
					<p class="rounded-lg bg-muted p-3 text-sm text-muted-foreground">
						{question.helpText}
					</p>
				{/if}
			{/if}
		</div>

		<!-- Answer options -->
		<div class="py-4">
			{#if question.type === 'SINGLE'}
				<SingleChoice
					answers={question.answers}
					selected={selectedAnswers}
					onSelect={handleSingleSelect}
				/>
			{:else if question.type === 'MULTIPLE'}
				<MultipleChoice
					answers={question.answers}
					selected={selectedAnswers}
					onToggle={handleMultiToggle}
				/>
			{:else if question.type === 'SCALE'}
				<ScaleInput
					min={question.scaleConfig?.min ?? 0}
					max={question.scaleConfig?.max ?? 10}
					step={question.scaleConfig?.step ?? 1}
					minLabel={question.scaleConfig?.minLabel}
					maxLabel={question.scaleConfig?.maxLabel}
					value={scaleValue}
					onChange={handleScaleChange}
				/>
			{:else if question.type === 'TEXT'}
				<TextInput value={textValue} onChange={handleTextChange} />
			{/if}
		</div>

		<!-- Submit button -->
		<div class="flex justify-end">
			<Button
				size="lg"
				disabled={!canSubmit()}
				onclick={handleSubmit}
			>
				{#if isLoading}
					<span class="mr-2 inline-block h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent"></span>
					Submitting...
				{:else}
					Continue
				{/if}
			</Button>
		</div>
	</div>
</Card>
