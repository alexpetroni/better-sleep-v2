<script lang="ts">
	import { Card } from '$lib/components/ui';
	import { TrendingUp, TrendingDown, Minus } from 'lucide-svelte';

	// Mock analytics data
	const weeklyData = [
		{ day: 'Mon', sessions: 45, completed: 38 },
		{ day: 'Tue', sessions: 52, completed: 44 },
		{ day: 'Wed', sessions: 49, completed: 41 },
		{ day: 'Thu', sessions: 63, completed: 55 },
		{ day: 'Fri', sessions: 58, completed: 49 },
		{ day: 'Sat', sessions: 71, completed: 62 },
		{ day: 'Sun', sessions: 68, completed: 58 }
	];

	const modeDistribution = [
		{ mode: 'RAPID', count: 782, percentage: 65 },
		{ mode: 'COMPLETE', count: 421, percentage: 35 }
	];

	const completionRate = 84;
	const avgScore = 47;
	const avgDuration = '8:32';

	const topFlags = [
		{ code: 'SLEEP_APNEA', count: 156, percentage: 12.6 },
		{ code: 'CHRONIC_INSOMNIA', count: 134, percentage: 10.9 },
		{ code: 'ANXIETY_DISORDER', count: 98, percentage: 7.9 },
		{ code: 'CAFFEINE_OVERUSE', count: 312, percentage: 25.3 },
		{ code: 'CIRCADIAN_DISORDER', count: 67, percentage: 5.4 }
	];
</script>

<div class="space-y-6">
	<div>
		<h1 class="text-3xl font-bold">Analytics</h1>
		<p class="text-muted-foreground">Quiz performance and insights</p>
	</div>

	<!-- Key Metrics -->
	<div class="grid gap-4 md:grid-cols-3">
		<Card class="p-6">
			<div class="flex items-center justify-between">
				<div>
					<p class="text-sm text-muted-foreground">Completion Rate</p>
					<p class="text-3xl font-bold">{completionRate}%</p>
				</div>
				<TrendingUp class="h-8 w-8 text-success" />
			</div>
			<p class="mt-2 text-sm text-success">+2.3% from last week</p>
		</Card>

		<Card class="p-6">
			<div class="flex items-center justify-between">
				<div>
					<p class="text-sm text-muted-foreground">Average Score</p>
					<p class="text-3xl font-bold">{avgScore}</p>
				</div>
				<Minus class="h-8 w-8 text-muted-foreground" />
			</div>
			<p class="mt-2 text-sm text-muted-foreground">No change</p>
		</Card>

		<Card class="p-6">
			<div class="flex items-center justify-between">
				<div>
					<p class="text-sm text-muted-foreground">Avg. Duration</p>
					<p class="text-3xl font-bold">{avgDuration}</p>
				</div>
				<TrendingDown class="h-8 w-8 text-warning" />
			</div>
			<p class="mt-2 text-sm text-warning">+30s from last week</p>
		</Card>
	</div>

	<!-- Charts -->
	<div class="grid gap-6 lg:grid-cols-2">
		<!-- Weekly Sessions -->
		<Card class="p-6">
			<h2 class="mb-4 text-lg font-semibold">Weekly Sessions</h2>
			<div class="flex h-64 items-end justify-between gap-2">
				{#each weeklyData as day}
					<div class="flex flex-1 flex-col items-center gap-2">
						<div class="relative flex w-full flex-1 flex-col justify-end">
							<div
								class="w-full rounded-t bg-primary/20"
								style="height: {(day.sessions / 80) * 100}%"
							>
								<div
									class="absolute bottom-0 w-full rounded-t bg-primary"
									style="height: {(day.completed / day.sessions) * 100}%"
								></div>
							</div>
						</div>
						<span class="text-xs text-muted-foreground">{day.day}</span>
					</div>
				{/each}
			</div>
			<div class="mt-4 flex items-center justify-center gap-6 text-sm">
				<div class="flex items-center gap-2">
					<div class="h-3 w-3 rounded bg-primary/20"></div>
					<span>Started</span>
				</div>
				<div class="flex items-center gap-2">
					<div class="h-3 w-3 rounded bg-primary"></div>
					<span>Completed</span>
				</div>
			</div>
		</Card>

		<!-- Mode Distribution -->
		<Card class="p-6">
			<h2 class="mb-4 text-lg font-semibold">Quiz Mode Distribution</h2>
			<div class="flex h-64 items-center justify-center">
				<div class="relative h-48 w-48">
					<svg viewBox="0 0 100 100" class="h-full w-full -rotate-90">
						<circle
							cx="50"
							cy="50"
							r="40"
							fill="none"
							stroke="currentColor"
							stroke-width="20"
							class="text-secondary"
						/>
						<circle
							cx="50"
							cy="50"
							r="40"
							fill="none"
							stroke="currentColor"
							stroke-width="20"
							stroke-dasharray="{modeDistribution[0].percentage * 2.51} 251"
							class="text-primary"
						/>
					</svg>
					<div class="absolute inset-0 flex flex-col items-center justify-center">
						<span class="text-3xl font-bold">{modeDistribution[0].percentage}%</span>
						<span class="text-sm text-muted-foreground">RAPID</span>
					</div>
				</div>
			</div>
			<div class="mt-4 flex justify-center gap-8">
				{#each modeDistribution as mode}
					<div class="text-center">
						<p class="text-2xl font-bold">{mode.count}</p>
						<p class="text-sm text-muted-foreground">{mode.mode}</p>
					</div>
				{/each}
			</div>
		</Card>
	</div>

	<!-- Top Medical Flags -->
	<Card class="p-6">
		<h2 class="mb-4 text-lg font-semibold">Most Common Medical Flags</h2>
		<div class="space-y-4">
			{#each topFlags as flag}
				<div class="flex items-center gap-4">
					<div class="w-40 truncate text-sm font-medium">{flag.code.replace(/_/g, ' ')}</div>
					<div class="flex-1">
						<div class="h-2 w-full rounded-full bg-secondary">
							<div
								class="h-full rounded-full bg-primary"
								style="width: {flag.percentage}%"
							></div>
						</div>
					</div>
					<div class="w-20 text-right text-sm">
						<span class="font-medium">{flag.count}</span>
						<span class="text-muted-foreground"> ({flag.percentage}%)</span>
					</div>
				</div>
			{/each}
		</div>
	</Card>
</div>
