import { createClient } from '@supabase/supabase-js';
import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_PUBLISHABLE_KEY } from '$env/static/public';
import { SUPABASE_SECRET_KEY } from '$env/static/private';
import type { Database } from '$lib/types/database';

// Client for browser/authenticated requests
export function createSupabaseClient(accessToken?: string) {
	return createClient<Database>(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_PUBLISHABLE_KEY, {
		global: {
			headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : {}
		}
	});
}

// Admin client for server-side operations
export const supabaseAdmin = createClient<Database>(
	PUBLIC_SUPABASE_URL,
	SUPABASE_SECRET_KEY,
	{
		auth: {
			autoRefreshToken: false,
			persistSession: false
		}
	}
);

// Type-safe query helpers
export type Tables = Database['public']['Tables'];
export type QuizSessionRow = Tables['quiz_sessions']['Row'];
export type QuizResponseRow = Tables['quiz_responses']['Row'];
export type QuizResultRow = Tables['quiz_results']['Row'];
