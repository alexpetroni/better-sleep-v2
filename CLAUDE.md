# Sleep Detective

A comprehensive sleep assessment application that helps users identify factors affecting their sleep quality through an intelligent quiz system.

## Tech Stack

- **Framework**: SvelteKit 2 with Svelte 5 (Runes)
- **Styling**: TailwindCSS 4
- **Language**: TypeScript (strict mode)
- **Database**: Supabase (PostgreSQL)
- **Email**: Resend
- **Runtime**: Node.js (via @sveltejs/adapter-node)
- **Validation**: Zod

## Folder Structure

```
src/
├── app.css                 # Global styles, Tailwind theme config
├── app.html                # HTML template
├── app.d.ts                # App-level type definitions
├── lib/
│   ├── components/
│   │   ├── ui/             # Reusable UI primitives (Button, Card, Progress)
│   │   └── quiz/           # Quiz-specific components (QuizQuestion, QuizResults)
│   ├── server/
│   │   ├── supabase.ts     # Supabase client initialization
│   │   ├── scoring/        # Scoring engine, rules, medical flags generator
│   │   ├── quiz/           # Quiz service, gate rule evaluator
│   │   └── email/          # Email queue and sending service
│   ├── stores/
│   │   └── quiz.svelte.ts  # Quiz state management (Svelte 5 $state/$derived)
│   ├── types/
│   │   ├── database.ts     # Supabase/database types
│   │   └── quiz.ts         # Domain types (QuizSession, QuizQuestion, etc.)
│   ├── utils.ts            # Utility functions (cn, formatDate, etc.)
│   └── index.ts            # Public exports
├── routes/
│   ├── +layout.svelte      # Root layout with header/footer
│   ├── +page.svelte        # Homepage
│   ├── quiz/               # Quiz flow pages
│   ├── admin/              # Admin dashboard (protected)
│   └── api/                # API endpoints
│       ├── quiz/           # Quiz session/response endpoints
│       └── cron/           # Scheduled job endpoints
static/                     # Static assets (favicon, robots.txt)
supabase/
└── migrations/             # SQL migration files
```

## Coding Conventions

### Style
- Use TypeScript strict mode; avoid `any`
- Prefer `const` over `let`; never use `var`
- Use Svelte 5 runes (`$state`, `$derived`, `$effect`) not legacy stores
- Component filenames: PascalCase (e.g., `QuizQuestion.svelte`)
- Other files: camelCase (e.g., `quizService.ts`)

### Error Handling
- Use Zod for input validation in API endpoints
- Throw SvelteKit `error()` for HTTP errors
- Log errors to console with context before throwing
- Never expose internal error details to clients

### Naming
- Database columns: snake_case
- TypeScript properties: camelCase
- Constants: SCREAMING_SNAKE_CASE
- Semantic answer codes: SCREAMING_SNAKE_CASE (e.g., `SNORING_LOUD`)

### Logging
- Use `console.error` for errors with descriptive messages
- Include relevant IDs (sessionId, questionId) in log messages
- No sensitive data in logs (emails, tokens)
- Debug logging should be wrapped in dev-mode checks:
  - In routes/API: `import { dev } from '$app/environment'`
  - In lib/server: `import.meta.env.DEV`

## Behavior Guidelines

When editing code in this repository:

1. **Ask before big refactors** - Propose changes and get approval before restructuring files, changing APIs, or modifying the database schema.

2. **Preserve multi-language support** - All user-facing text must use semantic codes with i18n tables; never hardcode display text.

3. **Test gate rules carefully** - Changes to gate logic affect quiz flow; verify skip conditions work correctly.

4. **Keep scoring rules documented** - When adding scoring rules, include comments explaining the sleep science rationale.

5. **Don't break the API contract** - API responses should maintain backward compatibility; add new fields rather than changing existing ones.

6. **Use the types** - Import and use types from `$lib/types`; don't create ad-hoc inline types.

7. **Follow existing patterns** - Match the style of surrounding code; check similar files for conventions.
