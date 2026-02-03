import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
	return twMerge(clsx(inputs));
}

export function formatDate(date: Date | string, locale = 'en'): string {
	const d = typeof date === 'string' ? new Date(date) : date;
	return d.toLocaleDateString(locale, {
		year: 'numeric',
		month: 'long',
		day: 'numeric'
	});
}

export function formatPercent(value: number): string {
	return `${Math.round(value)}%`;
}

export function sleep(ms: number): Promise<void> {
	return new Promise((resolve) => setTimeout(resolve, ms));
}

export function debounce<T extends (...args: unknown[]) => unknown>(
	func: T,
	wait: number
): (...args: Parameters<T>) => void {
	let timeout: ReturnType<typeof setTimeout> | null = null;
	return (...args: Parameters<T>) => {
		if (timeout) clearTimeout(timeout);
		timeout = setTimeout(() => func(...args), wait);
	};
}

export function generateId(): string {
	return crypto.randomUUID();
}
