<script lang="ts">
	import type { QuizResult, CategoryScore, MedicalFlag, Recommendation } from '$lib/types/quiz';
	import { Card, Button } from '$lib/components/ui';
	import { cn } from '$lib/utils';
	import {
		AlertTriangle,
		AlertCircle,
		Info,
		CheckCircle,
		ChevronDown,
		ChevronUp,
		ExternalLink
	} from 'lucide-svelte';

	interface Props {
		result: QuizResult;
		onRetake?: () => void;
	}

	let { result, onRetake }: Props = $props();

	let expandedCategories = $state<Set<string>>(new Set());
	let expandedFlags = $state<Set<string>>(new Set());

	function toggleCategory(code: string) {
		const newSet = new Set(expandedCategories);
		if (newSet.has(code)) {
			newSet.delete(code);
		} else {
			newSet.add(code);
		}
		expandedCategories = newSet;
	}

	function toggleFlag(code: string) {
		const newSet = new Set(expandedFlags);
		if (newSet.has(code)) {
			newSet.delete(code);
		} else {
			newSet.add(code);
		}
		expandedFlags = newSet;
	}

	function getRiskLevelColor(level: string): string {
		switch (level) {
			case 'CRITICAL':
				return 'text-destructive';
			case 'HIGH':
				return 'text-warning';
			case 'MODERATE':
				return 'text-yellow-500';
			default:
				return 'text-success';
		}
	}

	function getSeverityIcon(severity: string) {
		switch (severity) {
			case 'URGENT':
				return AlertTriangle;
			case 'IMPORTANT':
				return AlertCircle;
			case 'MODERATE':
				return Info;
			default:
				return CheckCircle;
		}
	}

	function getSeverityColor(severity: string): string {
		switch (severity) {
			case 'URGENT':
				return 'bg-destructive/10 border-destructive text-destructive';
			case 'IMPORTANT':
				return 'bg-warning/10 border-warning text-warning';
			case 'MODERATE':
				return 'bg-yellow-500/10 border-yellow-500 text-yellow-600';
			default:
				return 'bg-muted border-muted-foreground text-muted-foreground';
		}
	}

	const overallScoreColor = $derived(() => {
		if (result.overallScore >= 75) return 'text-destructive';
		if (result.overallScore >= 50) return 'text-warning';
		if (result.overallScore >= 25) return 'text-yellow-500';
		return 'text-success';
	});
</script>

<div class="mx-auto max-w-3xl space-y-8">
	<!-- Overall Score -->
	<Card class="p-6 text-center">
		<h2 class="mb-4 text-2xl font-bold">Your Sleep Health Score</h2>
		<div class="mb-2">
			<span class={cn('text-6xl font-bold', overallScoreColor())}>
				{result.overallScore}
			</span>
			<span class="text-2xl text-muted-foreground">/100</span>
		</div>
		<p class="text-muted-foreground">
			{#if result.overallScore >= 75}
				Multiple factors are significantly impacting your sleep. Professional consultation recommended.
			{:else if result.overallScore >= 50}
				Several factors are affecting your sleep quality. Consider addressing the top risks below.
			{:else if result.overallScore >= 25}
				Some factors may be affecting your sleep. Small adjustments could help improve your rest.
			{:else}
				Your sleep health looks good! Keep up the healthy habits.
			{/if}
		</p>
	</Card>

	<!-- Medical Flags -->
	{#if result.medicalFlags.length > 0}
		<Card class="p-6">
			<h3 class="mb-4 text-xl font-semibold">Important Health Indicators</h3>
			<div class="space-y-3">
				{#each result.medicalFlags as flag (flag.code)}
					{@const Icon = getSeverityIcon(flag.severity)}
					<div
						class={cn(
							'rounded-lg border-2 p-4',
							getSeverityColor(flag.severity)
						)}
					>
						<button
							type="button"
							class="flex w-full items-start justify-between text-left"
							onclick={() => toggleFlag(flag.code)}
						>
							<div class="flex items-start gap-3">
								<Icon class="mt-0.5 h-5 w-5 flex-shrink-0" />
								<div>
									<h4 class="font-semibold">{flag.title}</h4>
									{#if flag.requiresProfessional}
										<span class="text-xs font-medium uppercase tracking-wide">
											Professional consultation recommended
										</span>
									{/if}
								</div>
							</div>
							{#if expandedFlags.has(flag.code)}
								<ChevronUp class="h-5 w-5 flex-shrink-0" />
							{:else}
								<ChevronDown class="h-5 w-5 flex-shrink-0" />
							{/if}
						</button>

						{#if expandedFlags.has(flag.code)}
							<div class="mt-3 space-y-2 pl-8">
								<p class="text-sm">{flag.description}</p>
								<p class="text-sm font-medium">{flag.recommendation}</p>
							</div>
						{/if}
					</div>
				{/each}
			</div>
		</Card>
	{/if}

	<!-- Top Risk Categories -->
	<Card class="p-6">
		<h3 class="mb-4 text-xl font-semibold">Risk Categories</h3>
		<div class="space-y-3">
			{#each result.categoryScores.filter((c) => c.percentage > 0).sort((a, b) => b.percentage - a.percentage) as category (category.categoryCode)}
				<div class="rounded-lg border p-4">
					<button
						type="button"
						class="flex w-full items-center justify-between"
						onclick={() => toggleCategory(category.categoryCode)}
					>
						<div class="flex-1">
							<div class="flex items-center justify-between">
								<h4 class="font-medium">{category.categoryName}</h4>
								<span class={cn('font-semibold', getRiskLevelColor(category.riskLevel))}>
									{category.percentage}%
								</span>
							</div>
							<div class="mt-2 h-2 w-full rounded-full bg-secondary">
								<div
									class={cn(
										'h-full rounded-full transition-all',
										category.riskLevel === 'CRITICAL' && 'bg-destructive',
										category.riskLevel === 'HIGH' && 'bg-warning',
										category.riskLevel === 'MODERATE' && 'bg-yellow-500',
										category.riskLevel === 'LOW' && 'bg-success'
									)}
									style="width: {category.percentage}%"
								></div>
							</div>
						</div>
						<div class="ml-4">
							{#if expandedCategories.has(category.categoryCode)}
								<ChevronUp class="h-5 w-5 text-muted-foreground" />
							{:else}
								<ChevronDown class="h-5 w-5 text-muted-foreground" />
							{/if}
						</div>
					</button>

					{#if expandedCategories.has(category.categoryCode)}
						<div class="mt-3 border-t pt-3">
							<p class="text-sm text-muted-foreground">
								Raw score: {category.rawScore} / {category.maxPossible}
							</p>
							<p class="mt-1 text-sm">
								Risk level: <span class={cn('font-medium', getRiskLevelColor(category.riskLevel))}>
									{category.riskLevel}
								</span>
							</p>
						</div>
					{/if}
				</div>
			{/each}
		</div>
	</Card>

	<!-- Recommendations -->
	{#if result.recommendations.length > 0}
		<Card class="p-6">
			<h3 class="mb-4 text-xl font-semibold">Personalized Recommendations</h3>
			<div class="space-y-4">
				{#each result.recommendations as rec, index (rec.categoryCode)}
					<div class="rounded-lg border bg-card p-4">
						<div class="flex items-start gap-3">
							<div class="flex h-6 w-6 flex-shrink-0 items-center justify-center rounded-full bg-primary text-xs font-bold text-primary-foreground">
								{index + 1}
							</div>
							<div class="flex-1">
								<h4 class="font-semibold">{rec.title}</h4>
								<p class="mt-1 text-sm text-muted-foreground">{rec.description}</p>
								{#if rec.actionItems.length > 0}
									<ul class="mt-3 space-y-1">
										{#each rec.actionItems as item}
											<li class="flex items-start gap-2 text-sm">
												<CheckCircle class="mt-0.5 h-4 w-4 flex-shrink-0 text-success" />
												<span>{item}</span>
											</li>
										{/each}
									</ul>
								{/if}
							</div>
						</div>
					</div>
				{/each}
			</div>
		</Card>
	{/if}

	<!-- Actions -->
	<div class="flex flex-col items-center gap-4 sm:flex-row sm:justify-center">
		{#if onRetake}
			<Button variant="outline" onclick={onRetake}>
				Take Quiz Again
			</Button>
		{/if}
		<Button>
			Get Personalized Sleep Plan
			<ExternalLink class="ml-2 h-4 w-4" />
		</Button>
	</div>
</div>
