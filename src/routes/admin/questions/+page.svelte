<script lang="ts">
	import { Card, Button } from '$lib/components/ui';
	import { Plus, Search, Edit, Trash2, ChevronRight } from 'lucide-svelte';

	// Mock data - in production, this would come from the server
	const sections = [
		{
			id: '1',
			code: 'SECTION_PROFILE',
			title: 'Your Profile',
			questionsCount: 5,
			modes: ['RAPID', 'COMPLETE']
		},
		{
			id: '2',
			code: 'SECTION_SLEEP_QUALITY',
			title: 'Sleep Quality',
			questionsCount: 8,
			modes: ['RAPID', 'COMPLETE']
		},
		{
			id: '3',
			code: 'SECTION_STRESS_MENTAL',
			title: 'Stress & Mental Health',
			questionsCount: 12,
			modes: ['RAPID', 'COMPLETE']
		},
		{
			id: '4',
			code: 'SECTION_LIFESTYLE',
			title: 'Lifestyle',
			questionsCount: 10,
			modes: ['RAPID', 'COMPLETE']
		},
		{
			id: '5',
			code: 'SECTION_ENVIRONMENT',
			title: 'Sleep Environment',
			questionsCount: 7,
			modes: ['RAPID', 'COMPLETE']
		},
		{
			id: '6',
			code: 'SECTION_HEALTH',
			title: 'Health Conditions',
			questionsCount: 15,
			modes: ['COMPLETE']
		}
	];

	let searchQuery = $state('');

	const filteredSections = $derived(
		sections.filter(
			(s) =>
				s.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
				s.code.toLowerCase().includes(searchQuery.toLowerCase())
		)
	);
</script>

<div class="space-y-6">
	<div class="flex items-center justify-between">
		<div>
			<h1 class="text-3xl font-bold">Questions</h1>
			<p class="text-muted-foreground">Manage quiz sections and questions</p>
		</div>
		<Button>
			<Plus class="mr-2 h-4 w-4" />
			Add Section
		</Button>
	</div>

	<!-- Search -->
	<div class="relative">
		<Search class="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
		<input
			type="text"
			placeholder="Search sections..."
			class="w-full rounded-lg border bg-background py-2 pl-10 pr-4 text-sm focus:border-primary focus:outline-none focus:ring-2 focus:ring-ring"
			bind:value={searchQuery}
		/>
	</div>

	<!-- Sections List -->
	<div class="space-y-4">
		{#each filteredSections as section (section.id)}
			<Card class="p-4 transition-colors hover:bg-accent/50">
				<div class="flex items-center justify-between">
					<div class="flex items-center gap-4">
						<div>
							<h3 class="font-semibold">{section.title}</h3>
							<p class="text-sm text-muted-foreground">
								{section.code} &middot; {section.questionsCount} questions
							</p>
						</div>
					</div>

					<div class="flex items-center gap-2">
						<div class="flex gap-1">
							{#each section.modes as mode}
								<span
									class="rounded-full px-2 py-0.5 text-xs font-medium {mode === 'RAPID'
										? 'bg-primary/10 text-primary'
										: 'bg-secondary text-secondary-foreground'}"
								>
									{mode}
								</span>
							{/each}
						</div>

						<Button variant="ghost" size="icon">
							<Edit class="h-4 w-4" />
						</Button>
						<Button variant="ghost" size="icon">
							<Trash2 class="h-4 w-4 text-destructive" />
						</Button>
						<a href="/admin/questions/{section.id}">
							<Button variant="ghost" size="icon">
								<ChevronRight class="h-4 w-4" />
							</Button>
						</a>
					</div>
				</div>
			</Card>
		{/each}
	</div>
</div>
