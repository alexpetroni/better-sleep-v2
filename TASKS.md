# Tasks

## Completed (2026-02-02)

- [x] Implement complete 78 Sleep Causes Quiz (14 sections, 81 questions)
- [x] Add gate rules for gender, age, children, pets, living situation
- [x] Update scoring rules to match new question codes (~70 rules)
- [x] Update medical flag rules for new question codes
- [x] Fix progress calculation bug (answered > total)
- [x] Fix overall score calculation (average only tested categories)
- [x] Test full quiz flow end-to-end with real database
- [x] Verify scoring produces reasonable results
- [x] Fix QuizProgress component double-subtraction bug
- [x] Fix gate rules to match database question codes
- [x] Add caffeine gate rule (skip timing when no caffeine)
- [x] Restore debug logging with dev-mode checks

## Next

- [ ] Re-run database migration to apply new gate rules
- [ ] Add Romanian translations for all content
- [ ] Add unit tests for scoring calculator
- [ ] Add unit tests for gate evaluator
- [ ] Create login/register pages for user authentication
- [ ] Implement question editing in admin dashboard
- [ ] Create results sharing/export functionality
- [ ] Implement quiz session resume (continue later)

## Backlog

- [ ] Add analytics tracking (page views, quiz completion funnel)
- [ ] Implement A/B testing for question order
- [ ] Add progress persistence to localStorage
- [ ] Create PDF report generation
- [ ] Add social sharing for results
- [ ] Implement premium features/paywall
- [ ] Add sleep diary/tracking feature
- [ ] Create mobile app (Capacitor or similar)
- [ ] Add admin user management
- [ ] Implement rate limiting on API endpoints
- [ ] Add response caching for quiz content
- [ ] Create webhook integrations
