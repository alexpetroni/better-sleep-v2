<script lang="ts">
	import '../app.css';
	import type { Snippet } from 'svelte';
	import { Moon, Sun } from 'lucide-svelte';

	interface Props {
		children: Snippet;
	}

	let { children }: Props = $props();

	let isDark = $state(false);

	function toggleTheme() {
		isDark = !isDark;
		document.documentElement.classList.toggle('dark', isDark);
	}
</script>

<svelte:head>
	<title>Sleep Detective - Discover What's Affecting Your Sleep</title>
	<meta
		name="description"
		content="Take our comprehensive sleep assessment quiz to discover the factors affecting your sleep quality and get personalized recommendations."
	/>
</svelte:head>

<div class="min-h-screen bg-background">
	<!-- Header -->
	<header class="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
		<div class="container mx-auto flex h-16 items-center justify-between px-4">
			<a href="/" class="flex items-center gap-2">
				<Moon class="h-6 w-6 text-primary" />
				<span class="text-xl font-bold">Sleep Detective</span>
			</a>

			<nav class="flex items-center gap-4">
				<a href="/quiz" class="text-sm font-medium hover:text-primary">
					Take Quiz
				</a>
				<a href="/about" class="text-sm font-medium hover:text-primary">
					About
				</a>
				<button
					type="button"
					class="rounded-md p-2 hover:bg-accent"
					onclick={toggleTheme}
					aria-label="Toggle theme"
				>
					{#if isDark}
						<Sun class="h-5 w-5" />
					{:else}
						<Moon class="h-5 w-5" />
					{/if}
				</button>
			</nav>
		</div>
	</header>

	<!-- Main content -->
	<main class="container mx-auto px-4 py-8">
		{@render children()}
	</main>

	<!-- Footer -->
	<footer class="border-t bg-muted/50">
		<div class="container mx-auto px-4 py-8">
			<div class="grid gap-8 sm:grid-cols-2 md:grid-cols-4">
				<div>
					<div class="flex items-center gap-2">
						<Moon class="h-5 w-5 text-primary" />
						<span class="font-bold">Sleep Detective</span>
					</div>
					<p class="mt-2 text-sm text-muted-foreground">
						Helping you understand and improve your sleep health.
					</p>
				</div>

				<div>
					<h4 class="font-semibold">Resources</h4>
					<ul class="mt-2 space-y-1 text-sm text-muted-foreground">
						<li><a href="/blog" class="hover:text-foreground">Sleep Blog</a></li>
						<li><a href="/tips" class="hover:text-foreground">Sleep Tips</a></li>
						<li><a href="/faq" class="hover:text-foreground">FAQ</a></li>
					</ul>
				</div>

				<div>
					<h4 class="font-semibold">Legal</h4>
					<ul class="mt-2 space-y-1 text-sm text-muted-foreground">
						<li><a href="/privacy" class="hover:text-foreground">Privacy Policy</a></li>
						<li><a href="/terms" class="hover:text-foreground">Terms of Service</a></li>
						<li><a href="/disclaimer" class="hover:text-foreground">Medical Disclaimer</a></li>
					</ul>
				</div>

				<div>
					<h4 class="font-semibold">Contact</h4>
					<ul class="mt-2 space-y-1 text-sm text-muted-foreground">
						<li><a href="mailto:hello@sleepdetective.com" class="hover:text-foreground">hello@sleepdetective.com</a></li>
					</ul>
				</div>
			</div>

			<div class="mt-8 border-t pt-8 text-center text-sm text-muted-foreground">
				<p>&copy; {new Date().getFullYear()} Sleep Detective. All rights reserved.</p>
				<p class="mt-1">
					This tool is for informational purposes only and does not constitute medical advice.
				</p>
			</div>
		</div>
	</footer>
</div>
