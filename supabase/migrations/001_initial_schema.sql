-- Sleep Quiz Application Database Schema
-- Version: 1.0.0

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Grant schema usage to roles
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;

-- Enums
CREATE TYPE quiz_mode AS ENUM ('RAPID', 'COMPLETE');
CREATE TYPE question_type AS ENUM ('SINGLE', 'MULTIPLE', 'SCALE', 'TEXT');
CREATE TYPE flag_severity AS ENUM ('URGENT', 'IMPORTANT', 'MODERATE', 'INFO');
CREATE TYPE scoring_rule_type AS ENUM ('SINGLE', 'MULTI', 'COMBINATION', 'THRESHOLD');
CREATE TYPE email_status AS ENUM ('PENDING', 'SENT', 'FAILED', 'CANCELLED');
CREATE TYPE user_role AS ENUM ('user', 'admin');

-- Users table (extends Supabase auth.users)
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    role user_role DEFAULT 'user',
    locale TEXT DEFAULT 'en',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Quiz Sections
CREATE TABLE quiz_sections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT NOT NULL UNIQUE,
    order_index INTEGER NOT NULL,
    modes quiz_mode[] NOT NULL DEFAULT '{RAPID,COMPLETE}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE quiz_sections_i18n (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    section_id UUID NOT NULL REFERENCES quiz_sections(id) ON DELETE CASCADE,
    locale TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    UNIQUE(section_id, locale)
);

-- Quiz Questions
CREATE TABLE quiz_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    section_id UUID NOT NULL REFERENCES quiz_sections(id) ON DELETE CASCADE,
    code TEXT NOT NULL UNIQUE,
    type question_type NOT NULL,
    order_index INTEGER NOT NULL,
    is_gate BOOLEAN DEFAULT FALSE,
    modes quiz_mode[] NOT NULL DEFAULT '{RAPID,COMPLETE}',
    scale_config JSONB, -- For SCALE type: {min, max, step, minLabel, maxLabel}
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE quiz_questions_i18n (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
    locale TEXT NOT NULL,
    text TEXT NOT NULL,
    help_text TEXT,
    UNIQUE(question_id, locale)
);

-- Quiz Answers
CREATE TABLE quiz_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
    code TEXT NOT NULL,
    order_index INTEGER NOT NULL,
    is_exclusive BOOLEAN DEFAULT FALSE, -- "None of the above" type answers
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(question_id, code)
);

CREATE TABLE quiz_answers_i18n (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    answer_id UUID NOT NULL REFERENCES quiz_answers(id) ON DELETE CASCADE,
    locale TEXT NOT NULL,
    text TEXT NOT NULL,
    UNIQUE(answer_id, locale)
);

-- Gate Rules (conditional logic for skipping sections/questions)
CREATE TABLE gate_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
    condition JSONB NOT NULL, -- {questionCode, operator, value} or composite
    skips_sections TEXT[] DEFAULT '{}',
    skips_questions TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Risk Categories
CREATE TABLE risk_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT NOT NULL UNIQUE,
    order_index INTEGER NOT NULL,
    max_score INTEGER DEFAULT 100,
    weight DECIMAL(3,2) DEFAULT 1.0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE risk_categories_i18n (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES risk_categories(id) ON DELETE CASCADE,
    locale TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    UNIQUE(category_id, locale)
);

-- Scoring Rules
CREATE TABLE scoring_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES risk_categories(id) ON DELETE CASCADE,
    rule_type scoring_rule_type NOT NULL,
    condition JSONB NOT NULL,
    points INTEGER NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Medical Flag Rules
CREATE TABLE medical_flag_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT NOT NULL UNIQUE,
    severity flag_severity NOT NULL,
    condition JSONB NOT NULL,
    requires_professional BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE medical_flag_rules_i18n (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rule_id UUID NOT NULL REFERENCES medical_flag_rules(id) ON DELETE CASCADE,
    locale TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    recommendation TEXT NOT NULL,
    UNIQUE(rule_id, locale)
);

-- Quiz Sessions
CREATE TABLE quiz_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    mode quiz_mode NOT NULL,
    locale TEXT DEFAULT 'en',
    started_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    current_section_index INTEGER DEFAULT 0,
    current_question_index INTEGER DEFAULT 0,
    skipped_sections TEXT[] DEFAULT '{}',
    skipped_questions TEXT[] DEFAULT '{}'
);

-- Quiz Responses
CREATE TABLE quiz_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES quiz_sessions(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
    answer_codes TEXT[] DEFAULT '{}',
    scale_value INTEGER,
    text_value TEXT,
    responded_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(session_id, question_id)
);

-- Quiz Results
CREATE TABLE quiz_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL UNIQUE REFERENCES quiz_sessions(id) ON DELETE CASCADE,
    overall_score INTEGER NOT NULL,
    category_scores JSONB NOT NULL,
    top_risks TEXT[] DEFAULT '{}',
    medical_flags JSONB DEFAULT '[]',
    recommendations JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Email Templates
CREATE TABLE email_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT NOT NULL UNIQUE,
    sequence_order INTEGER NOT NULL,
    delay_days INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE email_templates_i18n (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    template_id UUID NOT NULL REFERENCES email_templates(id) ON DELETE CASCADE,
    locale TEXT NOT NULL,
    subject TEXT NOT NULL,
    body_html TEXT NOT NULL,
    body_text TEXT NOT NULL,
    UNIQUE(template_id, locale)
);

-- Email Queue
CREATE TABLE email_queue (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES quiz_sessions(id) ON DELETE CASCADE,
    template_id UUID NOT NULL REFERENCES email_templates(id) ON DELETE CASCADE,
    to_email TEXT NOT NULL,
    status email_status DEFAULT 'PENDING',
    scheduled_for TIMESTAMPTZ NOT NULL,
    sent_at TIMESTAMPTZ,
    error TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_quiz_sessions_user ON quiz_sessions(user_id);
CREATE INDEX idx_quiz_sessions_completed ON quiz_sessions(completed_at);
CREATE INDEX idx_quiz_responses_session ON quiz_responses(session_id);
CREATE INDEX idx_quiz_responses_question ON quiz_responses(question_id);
CREATE INDEX idx_email_queue_status ON email_queue(status, scheduled_for);
CREATE INDEX idx_quiz_questions_section ON quiz_questions(section_id);
CREATE INDEX idx_quiz_answers_question ON quiz_answers(question_id);

-- Row Level Security (RLS) - Enable on ALL public tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_sections_i18n ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions_i18n ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_answers_i18n ENABLE ROW LEVEL SECURITY;
ALTER TABLE gate_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE risk_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE risk_categories_i18n ENABLE ROW LEVEL SECURITY;
ALTER TABLE scoring_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_flag_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_flag_rules_i18n ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_templates_i18n ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_queue ENABLE ROW LEVEL SECURITY;

-- Policies
-- Users can read their own data
CREATE POLICY "Users can read own data" ON users
    FOR SELECT USING (auth.uid() = id);

-- Users can read/write their own sessions
CREATE POLICY "Users can read own sessions" ON quiz_sessions
    FOR SELECT USING (user_id IS NULL OR auth.uid() = user_id);

CREATE POLICY "Users can create sessions" ON quiz_sessions
    FOR INSERT WITH CHECK (user_id IS NULL OR auth.uid() = user_id);

CREATE POLICY "Users can update own sessions" ON quiz_sessions
    FOR UPDATE USING (user_id IS NULL OR auth.uid() = user_id);

-- Users can read/write responses for their sessions
CREATE POLICY "Users can manage responses" ON quiz_responses
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM quiz_sessions
            WHERE quiz_sessions.id = quiz_responses.session_id
            AND (quiz_sessions.user_id IS NULL OR quiz_sessions.user_id = auth.uid())
        )
    );

-- Users can read their own results
CREATE POLICY "Users can read own results" ON quiz_results
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM quiz_sessions
            WHERE quiz_sessions.id = quiz_results.session_id
            AND (quiz_sessions.user_id IS NULL OR quiz_sessions.user_id = auth.uid())
        )
    );

-- Public read access for quiz content and related tables
CREATE POLICY "Public read quiz sections" ON quiz_sections FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read quiz sections i18n" ON quiz_sections_i18n FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read quiz questions" ON quiz_questions FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read quiz questions i18n" ON quiz_questions_i18n FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read quiz answers" ON quiz_answers FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read quiz answers i18n" ON quiz_answers_i18n FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read gate rules" ON gate_rules FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read risk categories" ON risk_categories FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read risk categories i18n" ON risk_categories_i18n FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read scoring rules" ON scoring_rules FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read medical flag rules" ON medical_flag_rules FOR SELECT TO PUBLIC USING (true);
CREATE POLICY "Public read medical flag rules i18n" ON medical_flag_rules_i18n FOR SELECT TO PUBLIC USING (true);

-- Admin-only access for email tables (service role only)
CREATE POLICY "Service role read email templates" ON email_templates FOR SELECT TO service_role USING (true);
CREATE POLICY "Service role read email templates i18n" ON email_templates_i18n FOR SELECT TO service_role USING (true);
CREATE POLICY "Service role manage email queue" ON email_queue FOR ALL TO service_role USING (true);

-- Functions
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql
SET search_path = '';

CREATE TRIGGER users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();
