<script lang="ts">
	import { Card } from '$lib/components/ui';
	import { Users, FileQuestion, CheckCircle, AlertTriangle } from 'lucide-svelte';

	// In production, these would come from the server
	const stats = [
		{
			label: 'Total Sessions',
			value: '1,234',
			change: '+12%',
			icon: Users
		},
		{
			label: 'Completed Quizzes',
			value: '987',
			change: '+8%',
			icon: CheckCircle
		},
		{
			label: 'Active Questions',
			value: '78',
			change: '0%',
			icon: FileQuestion
		},
		{
			label: 'Medical Flags',
			value: '156',
			change: '+5%',
			icon: AlertTriangle
		}
	];
</script>

<div class="space-y-8">
	<div>
		<h1 class="text-3xl font-bold">Dashboard</h1>
		<p class="text-muted-foreground">Overview of your sleep quiz application</p>
	</div>

	<!-- Stats Grid -->
	<div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
		{#each stats as stat (stat.label)}
			{@const Icon = stat.icon}
			<Card class="p-6">
				<div class="flex items-center justify-between">
					<div>
						<p class="text-sm font-medium text-muted-foreground">{stat.label}</p>
						<p class="text-2xl font-bold">{stat.value}</p>
						<p class="text-xs text-muted-foreground">{stat.change} from last month</p>
					</div>
					<div class="rounded-full bg-primary/10 p-3">
						<Icon class="h-6 w-6 text-primary" />
					</div>
				</div>
			</Card>
		{/each}
	</div>

	<!-- Recent Activity -->
	<div class="grid gap-8 lg:grid-cols-2">
		<Card class="p-6">
			<h2 class="mb-4 text-lg font-semibold">Recent Sessions</h2>
			<div class="space-y-4">
				{#each Array(5) as _, i}
					<div class="flex items-center justify-between border-b pb-2 last:border-0">
						<div>
							<p class="font-medium">Session #{1234 - i}</p>
							<p class="text-sm text-muted-foreground">
								{i === 0 ? 'Just now' : `${i * 2} hours ago`}
							</p>
						</div>
						<span
							class="rounded-full px-2 py-1 text-xs font-medium {i % 3 === 0
								? 'bg-success/10 text-success'
								: 'bg-warning/10 text-warning'}"
						>
							{i % 3 === 0 ? 'Completed' : 'In Progress'}
						</span>
					</div>
				{/each}
			</div>
		</Card>

		<Card class="p-6">
			<h2 class="mb-4 text-lg font-semibold">Top Risk Categories</h2>
			<div class="space-y-4">
				{#each [
					{ name: 'Stress & Psychology', percentage: 45 },
					{ name: 'Sleep Environment', percentage: 38 },
					{ name: 'Lifestyle Factors', percentage: 32 },
					{ name: 'Circadian Rhythm', percentage: 28 },
					{ name: 'Substances', percentage: 25 }
				] as category}
					<div class="space-y-1">
						<div class="flex justify-between text-sm">
							<span>{category.name}</span>
							<span class="font-medium">{category.percentage}%</span>
						</div>
						<div class="h-2 w-full rounded-full bg-secondary">
							<div
								class="h-full rounded-full bg-primary"
								style="width: {category.percentage}%"
							/>
						</div>
					</div>
				{/each}
			</div>
		</Card>
	</div>
</div>
