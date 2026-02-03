<script lang="ts">
	import type { Snippet } from 'svelte';
	import { page } from '$app/stores';
	import {
		LayoutDashboard,
		FileQuestion,
		Users,
		BarChart3,
		Settings,
		Mail,
		LogOut
	} from 'lucide-svelte';
	import { cn } from '$lib/utils';

	interface Props {
		children: Snippet;
	}

	let { children }: Props = $props();

	const navItems = [
		{ href: '/admin', icon: LayoutDashboard, label: 'Dashboard' },
		{ href: '/admin/questions', icon: FileQuestion, label: 'Questions' },
		{ href: '/admin/sessions', icon: Users, label: 'Sessions' },
		{ href: '/admin/analytics', icon: BarChart3, label: 'Analytics' },
		{ href: '/admin/emails', icon: Mail, label: 'Emails' },
		{ href: '/admin/settings', icon: Settings, label: 'Settings' }
	];
</script>

<div class="flex min-h-screen">
	<!-- Sidebar -->
	<aside class="fixed inset-y-0 left-0 z-50 w-64 border-r bg-card">
		<div class="flex h-16 items-center border-b px-6">
			<a href="/admin" class="text-xl font-bold">
				Sleep Admin
			</a>
		</div>

		<nav class="space-y-1 p-4">
			{#each navItems as item (item.href)}
				{@const Icon = item.icon}
				{@const isActive = $page.url.pathname === item.href ||
					($page.url.pathname.startsWith(item.href) && item.href !== '/admin')}
				<a
					href={item.href}
					class={cn(
						'flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors',
						isActive
							? 'bg-primary text-primary-foreground'
							: 'text-muted-foreground hover:bg-accent hover:text-accent-foreground'
					)}
				>
					<Icon class="h-5 w-5" />
					{item.label}
				</a>
			{/each}
		</nav>

		<div class="absolute bottom-0 left-0 right-0 border-t p-4">
			<a
				href="/logout"
				class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-accent hover:text-accent-foreground"
			>
				<LogOut class="h-5 w-5" />
				Logout
			</a>
		</div>
	</aside>

	<!-- Main content -->
	<main class="ml-64 flex-1 p-8">
		{@render children()}
	</main>
</div>
