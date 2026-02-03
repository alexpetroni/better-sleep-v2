/**
 * Script to re-run the seed data migration
 * Run with: npx tsx scripts/reseed-database.ts
 */
import { createClient } from '@supabase/supabase-js';
import { readFileSync } from 'fs';
import { join } from 'path';

const supabaseUrl = process.env.PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SECRET_KEY;

if (!supabaseUrl || !supabaseKey) {
	console.error('Missing SUPABASE_URL or SUPABASE_SECRET_KEY environment variables');
	process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function reseed() {
	console.log('Reading migration file...');
	const sqlPath = join(process.cwd(), 'supabase/migrations/002_seed_data.sql');
	const sql = readFileSync(sqlPath, 'utf-8');

	console.log('Running seed migration...');

	// Split by semicolons but be careful with strings containing semicolons
	// For simplicity, run the whole thing - Supabase should handle it
	const { error } = await supabase.rpc('exec_sql', { sql_query: sql });

	if (error) {
		// If exec_sql doesn't exist, we need to use the REST API directly
		console.log('exec_sql not available, trying direct execution...');

		// Use the postgres connection through supabase
		const response = await fetch(`${supabaseUrl}/rest/v1/rpc/exec_sql`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json',
				'apikey': supabaseKey,
				'Authorization': `Bearer ${supabaseKey}`
			},
			body: JSON.stringify({ sql_query: sql })
		});

		if (!response.ok) {
			console.error('Direct execution failed. Please run the SQL manually:');
			console.error('1. Go to your Supabase dashboard');
			console.error('2. Open SQL Editor');
			console.error('3. Paste the contents of supabase/migrations/002_seed_data.sql');
			console.error('4. Run the query');
			process.exit(1);
		}
	}

	console.log('Seed migration completed successfully!');
}

reseed().catch(console.error);
