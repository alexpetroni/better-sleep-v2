# Decisions

## 2026-02-01 | Use semantic answer codes instead of translated text
**Decision**: Store answer values as semantic codes (e.g., `SNORING_LOUD`) not localized text.

**Why**: Enables multi-language support without data migration. Scoring rules reference codes that work across all languages. Human-readable codes make debugging easier than UUIDs.

**Alternatives considered**: Store translated text (rejected: can't add languages without migrating data), store answer IDs only (rejected: harder to debug and write scoring rules).

---

## 2026-02-01 | Two quiz modes: RAPID and COMPLETE
**Decision**: Offer two quiz variants - quick (30-40 questions) and comprehensive (50-70 questions).

**Why**: Users have different time availability. RAPID covers most common issues for quick insights. COMPLETE provides thorough analysis for users willing to invest time.

**Alternatives considered**: Single adaptive quiz (rejected: harder to estimate duration), three+ modes (rejected: unnecessary complexity).

---

## 2026-02-01 | Gate rules for conditional question skipping
**Decision**: Use declarative gate rules stored in database to skip irrelevant questions.

**Why**: Males shouldn't see menopause questions. People without children shouldn't answer parenting questions. Reduces quiz length and improves relevance.

**Alternatives considered**: Hardcoded conditionals (rejected: inflexible), AI-driven selection (rejected: unpredictable, overkill).

---

## 2026-02-01 | Supabase for database and auth
**Decision**: Use Supabase (PostgreSQL) with Row Level Security.

**Why**: Managed PostgreSQL with built-in auth, real-time, and RLS. Free tier sufficient for MVP. TypeScript SDK with good DX.

**Alternatives considered**: PlanetScale (rejected: no free tier in EU), Firebase (rejected: vendor lock-in, document DB less suitable), self-hosted Postgres (rejected: operational overhead).

---

## 2026-02-01 | Svelte 5 Runes for state management
**Decision**: Use Svelte 5 `$state` and `$derived` instead of stores or external state libraries.

**Why**: Built-in, reactive, simple. Quiz state is straightforward; no need for Redux-like complexity. Runes are the future of Svelte.

**Alternatives considered**: Svelte stores (rejected: legacy), Zustand (rejected: unnecessary dependency), URL state (rejected: too complex for quiz flow).

---

## 2026-02-01 | TailwindCSS 4 with custom theme
**Decision**: Use Tailwind 4 with CSS-first configuration and oklch colors.

**Why**: Tailwind 4 is faster, CSS-native config is cleaner. oklch provides better color consistency across light/dark modes.

**Alternatives considered**: Tailwind 3 (rejected: older), vanilla CSS (rejected: slower development), Shadcn-svelte (partially used for inspiration but custom components preferred for control).

---

## 2026-02-01 | In-memory scoring calculation
**Decision**: Calculate scores in TypeScript on quiz completion, not SQL functions.

**Why**: Easier to test and debug. Rules are complex with combinations and thresholds. ~100 rules per completion is fast enough.

**Alternatives considered**: PostgreSQL functions (rejected: harder to test, complex rule logic), edge functions (rejected: cold start latency).

---

## 2026-02-02 | 78 Sleep Causes Quiz structure with 14 sections
**Decision**: Organize quiz into 14 sections based on sleep cause categories, with mode-specific availability.

**Why**: Covers all 78 documented sleep causes comprehensively. RAPID mode uses 8 most common sections (~30 questions), COMPLETE mode uses all 14 sections (~80 questions). Gate rules skip irrelevant questions based on profile answers (gender, age, children, pets, living situation).

**Sections**: Profile, Neuro-Hormonal, Physiological, Neurological, Psychological, Nervous System, Microbiome, Circadian, Environment, Bed Setup, Dental, Social, Substances, Life Stages.

---

## 2026-02-02 | Overall score averages only tested categories
**Decision**: When calculating overall risk score, only include categories that have points (rawScore > 0).

**Why**: In RAPID mode, only 8 sections are tested but there are 14 risk categories. Previously, untested categories (with 0 points) dragged down the weighted average, resulting in misleadingly low scores (e.g., 23/100 when selecting severe conditions). Now the score reflects actual risk in tested areas.

**Alternatives considered**: Always average all 14 categories (rejected: misleading in RAPID mode), mode-specific category lists (rejected: adds complexity, categories may cross sections).

---

## 2026-02-02 | Progress tracking counts only valid responses
**Decision**: Quiz progress (e.g., "15/27") counts only responses for non-skipped questions.

**Why**: When gate rules trigger mid-quiz, some already-answered questions become "skipped". Previously, response count could exceed total (e.g., "30/27") because all responses were counted but total excluded skipped questions. Now both numerator and denominator use the same valid question set.

---

## 2026-02-02 | QuizProgress component uses totalQuestions directly
**Decision**: Display progress as `answeredQuestions / totalQuestions` without additional subtraction.

**Why**: The server sends `totalQuestions` already excluding skipped questions. The `skippedQuestions` field is informational only. Previously, the component did `totalQuestions - skippedQuestions` which double-subtracted, causing displays like "29/26" when it should be "26/26".

---

## 2026-02-02 | Gate rules defined in code must match database
**Decision**: The `defaultGateRules` in `gate-evaluator.ts` must use the same question codes as the database seed file.

**Why**: Gate rules were failing silently because hardcoded rules referenced non-existent question codes (e.g., `YOUNG_CHILDREN` instead of `CHILDCARE_DISRUPTION`). Questions about children and caffeine timing were shown despite profile answers that should have skipped them.

**Lesson**: When adding gate rules, update BOTH `002_seed_data.sql` AND `gate-evaluator.ts` with matching codes.

---

## 2026-02-02 | Dev-mode debug logging
**Decision**: Wrap verbose debug logging in development mode checks rather than removing it entirely.

**Why**: Debug output for progress calculation and scoring is valuable during development but noisy in production. Using `import.meta.env.DEV` (in lib/server) or `dev` from `$app/environment` (in routes) provides conditional logging without code changes between environments.

**Pattern**:
```typescript
if (import.meta.env.DEV) {
  console.log('=== DEBUG ===');
  console.log('values:', data);
}
```
