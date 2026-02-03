# Architecture

## High-Level Components

```
┌─────────────────────────────────────────────────────────────┐
│                        Frontend                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Homepage   │  │  Quiz UI    │  │   Admin Dashboard   │  │
│  └─────────────┘  └──────┬──────┘  └─────────────────────┘  │
└──────────────────────────┼──────────────────────────────────┘
                           │
┌──────────────────────────┼──────────────────────────────────┐
│                     API Layer                                │
│  ┌─────────────────┐  ┌──┴───────────┐  ┌────────────────┐  │
│  │ Sessions API    │  │ Responses API │  │ Results API    │  │
│  └────────┬────────┘  └──────┬───────┘  └───────┬────────┘  │
└───────────┼──────────────────┼──────────────────┼───────────┘
            │                  │                  │
┌───────────┼──────────────────┼──────────────────┼───────────┐
│           │        Services Layer               │           │
│  ┌────────┴────────┐  ┌──────┴───────┐  ┌──────┴────────┐  │
│  │  Quiz Service   │  │ Gate Evaluator│  │Score Calculator│  │
│  └────────┬────────┘  └──────────────┘  └───────┬───────┘  │
│           │                                     │           │
│  ┌────────┴────────┐                   ┌───────┴────────┐  │
│  │ Email Service   │                   │ Flags Generator │  │
│  └─────────────────┘                   └────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           │
┌──────────────────────────┼──────────────────────────────────┐
│                     Data Layer                               │
│                    ┌─────┴─────┐                            │
│                    │ Supabase  │                            │
│                    │ PostgreSQL│                            │
│                    └───────────┘                            │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### Quiz Flow
1. User selects quiz mode:
   - **RAPID**: 8 sections, ~30 questions, quick assessment
   - **COMPLETE**: 14 sections, ~80 questions, comprehensive analysis
2. Frontend calls `POST /api/quiz/sessions` → creates session
3. For each question:
   - Frontend displays question from current state
   - User submits answer → `POST /api/quiz/sessions/[id]/responses`
   - Server evaluates gate rules → updates skip lists:
     - Gender-based skips (menopause vs andropause)
     - Age-based skips (age-related sleep changes)
     - Living situation skips (partner, children, pets)
     - Substance-based skips (caffeine timing if no caffeine)
   - Server returns next question or completion status
4. On completion, server calculates scores and generates flags
5. Frontend displays results from `GET /api/quiz/sessions/[id]/results`

### Key Entities
- **QuizSession**: Tracks user progress, mode, skipped items
- **QuizResponse**: Single answer to a question (codes, not text)
- **QuizResult**: Calculated scores, flags, recommendations
- **GateRule**: Condition that triggers section/question skips

## External Services

| Service | Purpose | Integration |
|---------|---------|-------------|
| Supabase | Database, Auth, RLS | `@supabase/supabase-js` |
| Resend | Transactional email | `resend` package |

## Constraints & Performance

### Database
- All queries use Supabase client with RLS enabled
- i18n tables joined on every content fetch (potential N+1)
- Session responses upserted to handle back-navigation

### Scoring
- All scoring rules evaluated in-memory per completion
- ~70 scoring rules across 14 risk categories
- Overall score = weighted average of categories WITH points (untested categories excluded)

### Rate Limits
- Supabase free tier: 500MB storage, 2GB bandwidth
- Resend free tier: 100 emails/day

### Known Issues
- No caching layer; repeated section fetches hit DB
- Gate rule evaluation happens on every response submission
- Email queue processed by external cron (not real-time)
