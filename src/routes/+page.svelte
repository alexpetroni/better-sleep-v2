<script lang="ts">
	import { Button, Card } from '$lib/components/ui';
	import { Moon, Zap, Shield, Clock, ArrowRight, CheckCircle } from 'lucide-svelte';
</script>

<div class="mx-auto max-w-5xl">
	<!-- Hero Section -->
	<section class="py-12 text-center md:py-20">
		<div class="mx-auto max-w-3xl">
			<div class="mb-6 inline-flex items-center gap-2 rounded-full border bg-muted px-4 py-1.5 text-sm">
				<Moon class="h-4 w-4 text-primary" />
				<span>Free Sleep Assessment</span>
			</div>

			<h1 class="mb-6 text-4xl font-bold tracking-tight md:text-5xl lg:text-6xl">
				Discover What's Really
				<span class="text-primary"> Affecting Your Sleep</span>
			</h1>

			<p class="mb-8 text-lg text-muted-foreground md:text-xl">
				Take our comprehensive sleep assessment to uncover the hidden factors disrupting
				your rest. Get personalized recommendations based on 78 scientifically-backed sleep factors.
			</p>

			<div class="flex flex-col items-center justify-center gap-4 sm:flex-row">
				<a href="/quiz">
					<Button size="lg" class="gap-2">
						Start Free Assessment
						<ArrowRight class="h-4 w-4" />
					</Button>
				</a>
				<a href="/about">
					<Button variant="outline" size="lg">
						Learn More
					</Button>
				</a>
			</div>

			<p class="mt-4 text-sm text-muted-foreground">
				Takes 5-10 minutes. No signup required.
			</p>
		</div>
	</section>

	<!-- Features Section -->
	<section class="py-12">
		<div class="grid gap-6 md:grid-cols-3">
			<Card class="p-6">
				<div class="mb-4 inline-flex rounded-lg bg-primary/10 p-3">
					<Zap class="h-6 w-6 text-primary" />
				</div>
				<h3 class="mb-2 text-lg font-semibold">Smart Branching</h3>
				<p class="text-sm text-muted-foreground">
					Our intelligent quiz adapts to your answers, skipping irrelevant questions
					and focusing on what matters for your unique situation.
				</p>
			</Card>

			<Card class="p-6">
				<div class="mb-4 inline-flex rounded-lg bg-primary/10 p-3">
					<Shield class="h-6 w-6 text-primary" />
				</div>
				<h3 class="mb-2 text-lg font-semibold">Medical Flags</h3>
				<p class="text-sm text-muted-foreground">
					We identify potential sleep disorders that may require professional attention,
					from sleep apnea to restless leg syndrome.
				</p>
			</Card>

			<Card class="p-6">
				<div class="mb-4 inline-flex rounded-lg bg-primary/10 p-3">
					<Clock class="h-6 w-6 text-primary" />
				</div>
				<h3 class="mb-2 text-lg font-semibold">Two Modes</h3>
				<p class="text-sm text-muted-foreground">
					Choose between a quick 5-minute assessment or a comprehensive deep-dive
					covering all 78 sleep factors.
				</p>
			</Card>
		</div>
	</section>

	<!-- What We Analyze Section -->
	<section class="py-12">
		<div class="text-center">
			<h2 class="mb-4 text-3xl font-bold">What We Analyze</h2>
			<p class="mx-auto mb-8 max-w-2xl text-muted-foreground">
				Our assessment covers 14 major categories of sleep-affecting factors,
				based on the latest sleep science research.
			</p>
		</div>

		<div class="grid gap-4 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
			{#each [
				'Stress & Psychology',
				'Sleep Disorders',
				'Lifestyle Factors',
				'Sleep Environment',
				'Health Conditions',
				'Substances & Meds',
				'Circadian Rhythm',
				'Hormonal Factors',
				'Digestive Issues',
				'Respiratory Issues',
				'Pain & Discomfort',
				'Neurological',
				'External Factors',
				'Sleep Habits'
			] as category}
				<div class="flex items-center gap-2 rounded-lg border bg-card p-3">
					<CheckCircle class="h-4 w-4 flex-shrink-0 text-success" />
					<span class="text-sm font-medium">{category}</span>
				</div>
			{/each}
		</div>
	</section>

	<!-- How It Works Section -->
	<section class="py-12">
		<div class="text-center">
			<h2 class="mb-4 text-3xl font-bold">How It Works</h2>
			<p class="mx-auto mb-8 max-w-2xl text-muted-foreground">
				Get your personalized sleep analysis in three simple steps.
			</p>
		</div>

		<div class="grid gap-8 md:grid-cols-3">
			<div class="text-center">
				<div class="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-primary text-xl font-bold text-primary-foreground">
					1
				</div>
				<h3 class="mb-2 text-lg font-semibold">Answer Questions</h3>
				<p class="text-sm text-muted-foreground">
					Respond to personalized questions about your sleep habits, health, and lifestyle.
				</p>
			</div>

			<div class="text-center">
				<div class="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-primary text-xl font-bold text-primary-foreground">
					2
				</div>
				<h3 class="mb-2 text-lg font-semibold">Get Analysis</h3>
				<p class="text-sm text-muted-foreground">
					Our algorithm analyzes your responses against 78 known sleep-affecting factors.
				</p>
			</div>

			<div class="text-center">
				<div class="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-primary text-xl font-bold text-primary-foreground">
					3
				</div>
				<h3 class="mb-2 text-lg font-semibold">Take Action</h3>
				<p class="text-sm text-muted-foreground">
					Receive personalized recommendations and insights to improve your sleep quality.
				</p>
			</div>
		</div>

		<div class="mt-12 text-center">
			<a href="/quiz">
				<Button size="lg" class="gap-2">
					Start Your Assessment
					<ArrowRight class="h-4 w-4" />
				</Button>
			</a>
		</div>
	</section>

	<!-- Disclaimer Section -->
	<section class="py-12">
		<Card class="bg-muted/50 p-6">
			<h3 class="mb-2 font-semibold">Medical Disclaimer</h3>
			<p class="text-sm text-muted-foreground">
				This sleep assessment tool is designed for informational and educational purposes only.
				It is not intended to be a substitute for professional medical advice, diagnosis, or treatment.
				Always seek the advice of your physician or other qualified health provider with any questions
				you may have regarding a medical condition or sleep disorder. Never disregard professional
				medical advice or delay in seeking it because of something you have read on this website.
			</p>
		</Card>
	</section>
</div>
