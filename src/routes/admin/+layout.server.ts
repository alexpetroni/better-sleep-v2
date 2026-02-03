import { redirect } from '@sveltejs/kit';
import type { LayoutServerLoad } from './$types';

export const load: LayoutServerLoad = async ({ locals }) => {
	// Check if user is authenticated and is admin
	const session = await locals.safeGetSession();

	if (!session.user) {
		throw redirect(303, '/login?redirect=/admin');
	}

	// In production, check user role from database
	// For now, we'll allow access for authenticated users
	// const { data: user } = await locals.supabase
	//   .from('users')
	//   .select('role')
	//   .eq('id', session.user.id)
	//   .single();
	//
	// if (user?.role !== 'admin') {
	//   throw redirect(303, '/');
	// }

	return {
		user: session.user
	};
};
