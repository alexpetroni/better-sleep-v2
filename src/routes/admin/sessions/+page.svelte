<script lang="ts">
	import { Card, Button } from '$lib/components/ui';
	import { Search, Eye, Download, Filter } from 'lucide-svelte';

	// Mock data
	const sessions = [
		{
			id: '1',
			mode: 'RAPID',
			locale: 'en',
			startedAt: new Date('2024-01-15T10:30:00'),
			completedAt: new Date('2024-01-15T10:45:00'),
			overallScore: 42,
			topRisk: 'Stress & Psychology'
		},
		{
			id: '2',
			mode: 'COMPLETE',
			locale: 'ro',
			startedAt: new Date('2024-01-15T09:00:00'),
			completedAt: new Date('2024-01-15T09:25:00'),
			overallScore: 68,
			topRisk: 'Sleep Disorders'
		},
		{
			id: '3',
			mode: 'RAPID',
			locale: 'en',
			startedAt: new Date('2024-01-14T16:20:00'),
			completedAt: null,
			overallScore: null,
			topRisk: null
		},
		{
			id: '4',
			mode: 'COMPLETE',
			locale: 'en',
			startedAt: new Date('2024-01-14T14:00:00'),
			completedAt: new Date('2024-01-14T14:30:00'),
			overallScore: 35,
			topRisk: 'Lifestyle Factors'
		},
		{
			id: '5',
			mode: 'RAPID',
			locale: 'en',
			startedAt: new Date('2024-01-14T11:45:00'),
			completedAt: new Date('2024-01-14T11:52:00'),
			overallScore: 55,
			topRisk: 'Circadian Rhythm'
		}
	];

	let searchQuery = $state('');
	let filterMode = $state<'ALL' | 'RAPID' | 'COMPLETE'>('ALL');
	let filterStatus = $state<'ALL' | 'COMPLETED' | 'INCOMPLETE'>('ALL');

	const filteredSessions = $derived(
		sessions.filter((s) => {
			if (filterMode !== 'ALL' && s.mode !== filterMode) return false;
			if (filterStatus === 'COMPLETED' && !s.completedAt) return false;
			if (filterStatus === 'INCOMPLETE' && s.completedAt) return false;
			if (searchQuery && !s.id.includes(searchQuery)) return false;
			return true;
		})
	);

	function formatDate(date: Date | null): string {
		if (!date) return '-';
		return date.toLocaleDateString('en', {
			month: 'short',
			day: 'numeric',
			hour: '2-digit',
			minute: '2-digit'
		});
	}

	function getScoreColor(score: number | null): string {
		if (score === null) return 'text-muted-foreground';
		if (score >= 75) return 'text-destructive';
		if (score >= 50) return 'text-warning';
		if (score >= 25) return 'text-yellow-500';
		return 'text-success';
	}
</script>

<div class="space-y-6">
	<div class="flex items-center justify-between">
		<div>
			<h1 class="text-3xl font-bold">Sessions</h1>
			<p class="text-muted-foreground">View and manage quiz sessions</p>
		</div>
		<Button variant="outline">
			<Download class="mr-2 h-4 w-4" />
			Export CSV
		</Button>
	</div>

	<!-- Filters -->
	<Card class="p-4">
		<div class="flex flex-wrap items-center gap-4">
			<div class="relative flex-1">
				<Search class="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
				<input
					type="text"
					placeholder="Search by session ID..."
					class="w-full rounded-lg border bg-background py-2 pl-10 pr-4 text-sm focus:border-primary focus:outline-none"
					bind:value={searchQuery}
				/>
			</div>

			<select
				class="rounded-lg border bg-background px-3 py-2 text-sm"
				bind:value={filterMode}
			>
				<option value="ALL">All Modes</option>
				<option value="RAPID">Rapid</option>
				<option value="COMPLETE">Complete</option>
			</select>

			<select
				class="rounded-lg border bg-background px-3 py-2 text-sm"
				bind:value={filterStatus}
			>
				<option value="ALL">All Status</option>
				<option value="COMPLETED">Completed</option>
				<option value="INCOMPLETE">Incomplete</option>
			</select>
		</div>
	</Card>

	<!-- Sessions Table -->
	<Card class="overflow-hidden">
		<table class="w-full">
			<thead class="border-b bg-muted/50">
				<tr>
					<th class="px-4 py-3 text-left text-sm font-medium">Session ID</th>
					<th class="px-4 py-3 text-left text-sm font-medium">Mode</th>
					<th class="px-4 py-3 text-left text-sm font-medium">Locale</th>
					<th class="px-4 py-3 text-left text-sm font-medium">Started</th>
					<th class="px-4 py-3 text-left text-sm font-medium">Completed</th>
					<th class="px-4 py-3 text-left text-sm font-medium">Score</th>
					<th class="px-4 py-3 text-left text-sm font-medium">Top Risk</th>
					<th class="px-4 py-3 text-left text-sm font-medium">Actions</th>
				</tr>
			</thead>
			<tbody>
				{#each filteredSessions as session (session.id)}
					<tr class="border-b last:border-0 hover:bg-muted/50">
						<td class="px-4 py-3 text-sm font-mono">{session.id}</td>
						<td class="px-4 py-3">
							<span
								class="rounded-full px-2 py-0.5 text-xs font-medium {session.mode === 'RAPID'
									? 'bg-primary/10 text-primary'
									: 'bg-secondary text-secondary-foreground'}"
							>
								{session.mode}
							</span>
						</td>
						<td class="px-4 py-3 text-sm uppercase">{session.locale}</td>
						<td class="px-4 py-3 text-sm">{formatDate(session.startedAt)}</td>
						<td class="px-4 py-3 text-sm">
							{#if session.completedAt}
								{formatDate(session.completedAt)}
							{:else}
								<span class="text-warning">In Progress</span>
							{/if}
						</td>
						<td class="px-4 py-3">
							<span class="font-semibold {getScoreColor(session.overallScore)}">
								{session.overallScore ?? '-'}
							</span>
						</td>
						<td class="px-4 py-3 text-sm">{session.topRisk ?? '-'}</td>
						<td class="px-4 py-3">
							<Button variant="ghost" size="icon">
								<Eye class="h-4 w-4" />
							</Button>
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</Card>
</div>
