-- Seed Data for Sleep Quiz Application
-- Complete 78 Sleep Causes Quiz
-- Version: 2.0.0

-- =====================================================
-- CLEANUP: Remove existing seed data before re-seeding
-- Order matters due to foreign key constraints
-- =====================================================
TRUNCATE TABLE email_queue CASCADE;
TRUNCATE TABLE email_templates CASCADE;
TRUNCATE TABLE quiz_results CASCADE;
TRUNCATE TABLE quiz_responses CASCADE;
TRUNCATE TABLE quiz_sessions CASCADE;
TRUNCATE TABLE gate_rules CASCADE;
TRUNCATE TABLE scoring_rules CASCADE;
TRUNCATE TABLE medical_flag_rules CASCADE;
TRUNCATE TABLE quiz_answers CASCADE;
TRUNCATE TABLE quiz_questions CASCADE;
TRUNCATE TABLE quiz_sections CASCADE;
TRUNCATE TABLE risk_categories CASCADE;

-- =====================================================
-- RISK CATEGORIES (14 categories)
-- =====================================================
INSERT INTO risk_categories (code, order_index, max_score, weight) VALUES
('R1_STRESS_PSYCH', 1, 30, 1.2),
('R2_SLEEP_DISORDERS', 2, 25, 1.3),
('R3_LIFESTYLE', 3, 25, 1.0),
('R4_ENVIRONMENT', 4, 20, 0.9),
('R5_HEALTH', 5, 25, 1.2),
('R6_SUBSTANCES', 6, 20, 1.1),
('R7_CIRCADIAN', 7, 20, 1.0),
('R8_HORMONAL', 8, 15, 1.0),
('R9_DIGESTIVE', 9, 15, 0.8),
('R10_RESPIRATORY', 10, 20, 1.1),
('R11_PAIN', 11, 20, 1.0),
('R12_NEUROLOGICAL', 12, 15, 1.1),
('R13_EXTERNAL', 13, 15, 0.7),
('R14_SLEEP_HABITS', 14, 20, 0.9);

-- Risk Categories i18n (English)
INSERT INTO risk_categories_i18n (category_id, locale, name, description)
SELECT id, 'en',
    CASE code
        WHEN 'R1_STRESS_PSYCH' THEN 'Stress & Psychology'
        WHEN 'R2_SLEEP_DISORDERS' THEN 'Sleep Disorders'
        WHEN 'R3_LIFESTYLE' THEN 'Lifestyle Factors'
        WHEN 'R4_ENVIRONMENT' THEN 'Sleep Environment'
        WHEN 'R5_HEALTH' THEN 'Health Conditions'
        WHEN 'R6_SUBSTANCES' THEN 'Substances & Medications'
        WHEN 'R7_CIRCADIAN' THEN 'Circadian Rhythm'
        WHEN 'R8_HORMONAL' THEN 'Hormonal Factors'
        WHEN 'R9_DIGESTIVE' THEN 'Digestive Issues'
        WHEN 'R10_RESPIRATORY' THEN 'Respiratory Issues'
        WHEN 'R11_PAIN' THEN 'Pain & Discomfort'
        WHEN 'R12_NEUROLOGICAL' THEN 'Neurological Factors'
        WHEN 'R13_EXTERNAL' THEN 'External Factors'
        WHEN 'R14_SLEEP_HABITS' THEN 'Sleep Habits'
    END,
    CASE code
        WHEN 'R1_STRESS_PSYCH' THEN 'Mental health factors including stress, anxiety, and depression'
        WHEN 'R2_SLEEP_DISORDERS' THEN 'Clinical sleep disorders requiring professional evaluation'
        WHEN 'R3_LIFESTYLE' THEN 'Daily habits and activities affecting sleep'
        WHEN 'R4_ENVIRONMENT' THEN 'Bedroom conditions and sleeping environment'
        WHEN 'R5_HEALTH' THEN 'Physical health conditions impacting sleep'
        WHEN 'R6_SUBSTANCES' THEN 'Caffeine, alcohol, nicotine, and medications'
        WHEN 'R7_CIRCADIAN' THEN 'Internal body clock and sleep timing'
        WHEN 'R8_HORMONAL' THEN 'Hormone-related sleep disruptions'
        WHEN 'R9_DIGESTIVE' THEN 'Digestive issues affecting sleep'
        WHEN 'R10_RESPIRATORY' THEN 'Breathing problems during sleep'
        WHEN 'R11_PAIN' THEN 'Physical pain and discomfort'
        WHEN 'R12_NEUROLOGICAL' THEN 'Brain and nervous system factors'
        WHEN 'R13_EXTERNAL' THEN 'External disruptions to sleep'
        WHEN 'R14_SLEEP_HABITS' THEN 'Sleep-related behaviors and routines'
    END
FROM risk_categories;

-- =====================================================
-- QUIZ SECTIONS (14 sections)
-- =====================================================
INSERT INTO quiz_sections (code, order_index, modes) VALUES
('SECTION_PROFILE', 1, '{RAPID,COMPLETE}'),
('SECTION_NEURO_HORMONAL', 2, '{COMPLETE}'),
('SECTION_PHYSIOLOGICAL', 3, '{RAPID,COMPLETE}'),
('SECTION_NEUROLOGICAL', 4, '{COMPLETE}'),
('SECTION_PSYCHOLOGICAL', 5, '{RAPID,COMPLETE}'),
('SECTION_NERVOUS_SYSTEM', 6, '{COMPLETE}'),
('SECTION_MICROBIOME', 7, '{COMPLETE}'),
('SECTION_CIRCADIAN', 8, '{RAPID,COMPLETE}'),
('SECTION_ENVIRONMENT', 9, '{RAPID,COMPLETE}'),
('SECTION_BED_SETUP', 10, '{RAPID,COMPLETE}'),
('SECTION_DENTAL', 11, '{COMPLETE}'),
('SECTION_SOCIAL', 12, '{RAPID,COMPLETE}'),
('SECTION_SUBSTANCES', 13, '{RAPID,COMPLETE}'),
('SECTION_LIFE_STAGES', 14, '{COMPLETE}');

-- Quiz Sections i18n (English)
INSERT INTO quiz_sections_i18n (section_id, locale, title, description)
SELECT id, 'en',
    CASE code
        WHEN 'SECTION_PROFILE' THEN 'Your Profile'
        WHEN 'SECTION_NEURO_HORMONAL' THEN 'Hormones & Metabolism'
        WHEN 'SECTION_PHYSIOLOGICAL' THEN 'Physical Health'
        WHEN 'SECTION_NEUROLOGICAL' THEN 'Neurological Factors'
        WHEN 'SECTION_PSYCHOLOGICAL' THEN 'Mental & Emotional Health'
        WHEN 'SECTION_NERVOUS_SYSTEM' THEN 'Nervous System'
        WHEN 'SECTION_MICROBIOME' THEN 'Gut Health'
        WHEN 'SECTION_CIRCADIAN' THEN 'Sleep Schedule'
        WHEN 'SECTION_ENVIRONMENT' THEN 'Sleep Environment'
        WHEN 'SECTION_BED_SETUP' THEN 'Bed & Bedding'
        WHEN 'SECTION_DENTAL' THEN 'Dental & Jaw'
        WHEN 'SECTION_SOCIAL' THEN 'Social Factors'
        WHEN 'SECTION_SUBSTANCES' THEN 'Substances & Medications'
        WHEN 'SECTION_LIFE_STAGES' THEN 'Life Stage'
    END,
    CASE code
        WHEN 'SECTION_PROFILE' THEN 'Basic information to personalize your assessment'
        WHEN 'SECTION_NEURO_HORMONAL' THEN 'Hormonal and metabolic factors affecting sleep'
        WHEN 'SECTION_PHYSIOLOGICAL' THEN 'Physical health conditions that impact sleep'
        WHEN 'SECTION_NEUROLOGICAL' THEN 'Brain and nervous system related sleep issues'
        WHEN 'SECTION_PSYCHOLOGICAL' THEN 'Mental health and emotional factors'
        WHEN 'SECTION_NERVOUS_SYSTEM' THEN 'Nervous system regulation and hypervigilance'
        WHEN 'SECTION_MICROBIOME' THEN 'Gut-brain connection and digestive health'
        WHEN 'SECTION_CIRCADIAN' THEN 'Your internal body clock and sleep timing'
        WHEN 'SECTION_ENVIRONMENT' THEN 'Your bedroom and sleeping conditions'
        WHEN 'SECTION_BED_SETUP' THEN 'Mattress, pillow, and bedding comfort'
        WHEN 'SECTION_DENTAL' THEN 'Teeth grinding, jaw issues, and tinnitus'
        WHEN 'SECTION_SOCIAL' THEN 'Partner, pets, and caregiving responsibilities'
        WHEN 'SECTION_SUBSTANCES' THEN 'Caffeine, alcohol, nicotine, and medications'
        WHEN 'SECTION_LIFE_STAGES' THEN 'Age and life-stage related sleep changes'
    END
FROM quiz_sections;

-- =====================================================
-- SECTION 1: PROFILE (Gate Questions)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('GENDER', 'SINGLE', 1, TRUE, '{RAPID,COMPLETE}'),
    ('AGE_GROUP', 'SINGLE', 2, TRUE, '{RAPID,COMPLETE}'),
    ('HAS_YOUNG_CHILDREN', 'SINGLE', 3, TRUE, '{RAPID,COMPLETE}'),
    ('HAS_PETS_BEDROOM', 'SINGLE', 4, TRUE, '{RAPID,COMPLETE}'),
    ('LIVING_SITUATION', 'SINGLE', 5, TRUE, '{RAPID,COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_PROFILE';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'GENDER' THEN 'What is your biological sex?'
        WHEN 'AGE_GROUP' THEN 'What is your age group?'
        WHEN 'HAS_YOUNG_CHILDREN' THEN 'Do you have young children (under 5 years old)?'
        WHEN 'HAS_PETS_BEDROOM' THEN 'Do you have pets that sleep in your bedroom?'
        WHEN 'LIVING_SITUATION' THEN 'What is your living situation?'
    END,
    CASE q.code
        WHEN 'GENDER' THEN 'This helps us customize questions relevant to your biology'
        WHEN 'AGE_GROUP' THEN 'Sleep patterns often change with age'
        WHEN 'HAS_YOUNG_CHILDREN' THEN 'Young children can significantly impact sleep patterns'
        WHEN 'HAS_PETS_BEDROOM' THEN 'Pets can sometimes disrupt sleep'
        WHEN 'LIVING_SITUATION' THEN 'This affects questions about sleep environment'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_PROFILE';

-- GENDER answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE
FROM quiz_questions q
CROSS JOIN (VALUES ('MALE', 1), ('FEMALE', 2), ('OTHER', 3)) AS a(code, order_index)
WHERE q.code = 'GENDER';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en',
    CASE a.code WHEN 'MALE' THEN 'Male' WHEN 'FEMALE' THEN 'Female' WHEN 'OTHER' THEN 'Other / Prefer not to say' END
FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'GENDER';

-- AGE_GROUP answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE
FROM quiz_questions q
CROSS JOIN (VALUES ('18_25', 1), ('26_35', 2), ('36_45', 3), ('46_55', 4), ('56_65', 5), ('65_PLUS', 6)) AS a(code, order_index)
WHERE q.code = 'AGE_GROUP';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en',
    CASE a.code
        WHEN '18_25' THEN '18-25 years' WHEN '26_35' THEN '26-35 years' WHEN '36_45' THEN '36-45 years'
        WHEN '46_55' THEN '46-55 years' WHEN '56_65' THEN '56-65 years' WHEN '65_PLUS' THEN '65+ years'
    END
FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'AGE_GROUP';

-- HAS_YOUNG_CHILDREN answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE
FROM quiz_questions q
CROSS JOIN (VALUES ('YES', 1), ('NO', 2)) AS a(code, order_index)
WHERE q.code = 'HAS_YOUNG_CHILDREN';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code WHEN 'YES' THEN 'Yes' WHEN 'NO' THEN 'No' END
FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'HAS_YOUNG_CHILDREN';

-- HAS_PETS_BEDROOM answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE
FROM quiz_questions q
CROSS JOIN (VALUES ('YES', 1), ('NO', 2)) AS a(code, order_index)
WHERE q.code = 'HAS_PETS_BEDROOM';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code WHEN 'YES' THEN 'Yes' WHEN 'NO' THEN 'No' END
FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'HAS_PETS_BEDROOM';

-- LIVING_SITUATION answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE
FROM quiz_questions q
CROSS JOIN (VALUES ('ALONE', 1), ('WITH_PARTNER', 2), ('WITH_FAMILY', 3), ('WITH_ROOMMATES', 4)) AS a(code, order_index)
WHERE q.code = 'LIVING_SITUATION';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en',
    CASE a.code
        WHEN 'ALONE' THEN 'I live alone' WHEN 'WITH_PARTNER' THEN 'With a partner'
        WHEN 'WITH_FAMILY' THEN 'With family' WHEN 'WITH_ROOMMATES' THEN 'With roommates'
    END
FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'LIVING_SITUATION';

-- =====================================================
-- GATE RULES
-- =====================================================
-- Male: Skip female-specific questions
INSERT INTO gate_rules (question_id, condition, skips_questions)
SELECT q.id,
    '{"questionCode": "GENDER", "operator": "EQUALS", "value": "MALE"}'::jsonb,
    ARRAY['MENOPAUSE_SYMPTOMS', 'PREGNANCY_STATUS', 'POSTPARTUM', 'MENSTRUAL_CYCLE']
FROM quiz_questions q WHERE q.code = 'GENDER';

-- Female: Skip male-specific questions
INSERT INTO gate_rules (question_id, condition, skips_questions)
SELECT q.id,
    '{"questionCode": "GENDER", "operator": "EQUALS", "value": "FEMALE"}'::jsonb,
    ARRAY['ANDROPAUSE_SYMPTOMS', 'PROSTATE_ISSUES']
FROM quiz_questions q WHERE q.code = 'GENDER';

-- Young age: Skip age-related questions
INSERT INTO gate_rules (question_id, condition, skips_questions)
SELECT q.id,
    '{"questionCode": "AGE_GROUP", "operator": "IN", "value": ["18_25", "26_35", "36_45"]}'::jsonb,
    ARRAY['AGE_RELATED_SLEEP', 'MENOPAUSE_SYMPTOMS', 'ANDROPAUSE_SYMPTOMS']
FROM quiz_questions q WHERE q.code = 'AGE_GROUP';

-- No children: Skip childcare questions
INSERT INTO gate_rules (question_id, condition, skips_questions)
SELECT q.id,
    '{"questionCode": "HAS_YOUNG_CHILDREN", "operator": "EQUALS", "value": "NO"}'::jsonb,
    ARRAY['CHILDCARE_DISRUPTION']
FROM quiz_questions q WHERE q.code = 'HAS_YOUNG_CHILDREN';

-- No pets: Skip pet questions
INSERT INTO gate_rules (question_id, condition, skips_questions)
SELECT q.id,
    '{"questionCode": "HAS_PETS_BEDROOM", "operator": "EQUALS", "value": "NO"}'::jsonb,
    ARRAY['PET_DISTURBANCE']
FROM quiz_questions q WHERE q.code = 'HAS_PETS_BEDROOM';

-- Lives alone: Skip partner questions
INSERT INTO gate_rules (question_id, condition, skips_questions)
SELECT q.id,
    '{"questionCode": "LIVING_SITUATION", "operator": "EQUALS", "value": "ALONE"}'::jsonb,
    ARRAY['PARTNER_SNORING', 'PARTNER_MOVEMENT', 'PARTNER_SCHEDULE']
FROM quiz_questions q WHERE q.code = 'LIVING_SITUATION';

-- No caffeine: Skip caffeine timing question
INSERT INTO gate_rules (question_id, condition, skips_questions)
SELECT q.id,
    '{"questionCode": "CAFFEINE_AMOUNT", "operator": "EQUALS", "value": "NONE"}'::jsonb,
    ARRAY['CAFFEINE_TIMING']
FROM quiz_questions q WHERE q.code = 'CAFFEINE_AMOUNT';

-- =====================================================
-- SECTION 2: NEURO-HORMONAL & METABOLIC (Causes 1-5)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('BLUE_LIGHT_EXPOSURE', 'SINGLE', 1, FALSE, '{COMPLETE}'),
    ('EVENING_STRESS', 'SINGLE', 2, FALSE, '{COMPLETE}'),
    ('BLOOD_SUGAR_SYMPTOMS', 'SINGLE', 3, FALSE, '{COMPLETE}'),
    ('NUTRITIONAL_DEFICIENCY', 'MULTIPLE', 4, FALSE, '{COMPLETE}'),
    ('ENERGY_LEVELS', 'SINGLE', 5, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_NEURO_HORMONAL';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'BLUE_LIGHT_EXPOSURE' THEN 'How much time do you spend on screens (phone, laptop, TV) in the 2 hours before bed?'
        WHEN 'EVENING_STRESS' THEN 'Do you often feel stressed or have racing thoughts in the evening?'
        WHEN 'BLOOD_SUGAR_SYMPTOMS' THEN 'Do you wake up between 2-4 AM feeling alert, sweaty, or with a racing heart?'
        WHEN 'NUTRITIONAL_DEFICIENCY' THEN 'Do you experience any of these symptoms? (Select all that apply)'
        WHEN 'ENERGY_LEVELS' THEN 'How would you describe your overall energy levels during the day?'
    END,
    CASE q.code
        WHEN 'BLUE_LIGHT_EXPOSURE' THEN 'Blue light suppresses melatonin production'
        WHEN 'EVENING_STRESS' THEN 'Elevated cortisol can cause 2-4 AM awakenings'
        WHEN 'BLOOD_SUGAR_SYMPTOMS' THEN 'These can indicate nighttime blood sugar drops'
        WHEN 'NUTRITIONAL_DEFICIENCY' THEN 'Deficiencies in magnesium, zinc, B vitamins, or iron affect sleep'
        WHEN 'ENERGY_LEVELS' THEN 'Mitochondrial function affects both energy and sleep quality'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_NEURO_HORMONAL';

-- BLUE_LIGHT_EXPOSURE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE
FROM quiz_questions q
CROSS JOIN (VALUES
    ('NONE', 1), ('LESS_THAN_30', 2), ('30_TO_60', 3), ('MORE_THAN_60', 4)
) AS a(code, order_index)
WHERE q.code = 'BLUE_LIGHT_EXPOSURE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en',
    CASE a.code
        WHEN 'NONE' THEN 'I avoid screens before bed'
        WHEN 'LESS_THAN_30' THEN 'Less than 30 minutes'
        WHEN '30_TO_60' THEN '30-60 minutes'
        WHEN 'MORE_THAN_60' THEN 'More than an hour'
    END
FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'BLUE_LIGHT_EXPOSURE';

-- EVENING_STRESS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE
FROM quiz_questions q
CROSS JOIN (VALUES
    ('RARELY', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('EVERY_NIGHT', 4)
) AS a(code, order_index)
WHERE q.code = 'EVENING_STRESS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en',
    CASE a.code
        WHEN 'RARELY' THEN 'Rarely or never'
        WHEN 'SOMETIMES' THEN 'Sometimes'
        WHEN 'OFTEN' THEN 'Often'
        WHEN 'EVERY_NIGHT' THEN 'Almost every night'
    END
FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'EVENING_STRESS';

-- BLOOD_SUGAR_SYMPTOMS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE
FROM quiz_questions q
CROSS JOIN (VALUES
    ('NEVER', 1), ('OCCASIONALLY', 2), ('FREQUENTLY', 3), ('MOST_NIGHTS', 4)
) AS a(code, order_index)
WHERE q.code = 'BLOOD_SUGAR_SYMPTOMS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en',
    CASE a.code
        WHEN 'NEVER' THEN 'Never or rarely'
        WHEN 'OCCASIONALLY' THEN 'Occasionally'
        WHEN 'FREQUENTLY' THEN 'Frequently'
        WHEN 'MOST_NIGHTS' THEN 'Most nights'
    END
FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'BLOOD_SUGAR_SYMPTOMS';

-- NUTRITIONAL_DEFICIENCY answers (MULTIPLE type)
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, a.is_exclusive
FROM quiz_questions q
CROSS JOIN (VALUES
    ('MUSCLE_CRAMPS', 1, FALSE),
    ('RESTLESS_LEGS', 2, FALSE),
    ('FATIGUE', 3, FALSE),
    ('BRAIN_FOG', 4, FALSE),
    ('NONE', 5, TRUE)
) AS a(code, order_index, is_exclusive)
WHERE q.code = 'NUTRITIONAL_DEFICIENCY';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en',
    CASE a.code
        WHEN 'MUSCLE_CRAMPS' THEN 'Muscle cramps or twitches'
        WHEN 'RESTLESS_LEGS' THEN 'Restless leg sensations'
        WHEN 'FATIGUE' THEN 'Chronic fatigue'
        WHEN 'BRAIN_FOG' THEN 'Brain fog or difficulty concentrating'
        WHEN 'NONE' THEN 'None of these'
    END
FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'NUTRITIONAL_DEFICIENCY';

-- ENERGY_LEVELS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE
FROM quiz_questions q
CROSS JOIN (VALUES
    ('GOOD', 1), ('VARIABLE', 2), ('LOW', 3), ('VERY_LOW', 4)
) AS a(code, order_index)
WHERE q.code = 'ENERGY_LEVELS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en',
    CASE a.code
        WHEN 'GOOD' THEN 'Good and consistent'
        WHEN 'VARIABLE' THEN 'Variable throughout the day'
        WHEN 'LOW' THEN 'Generally low'
        WHEN 'VERY_LOW' THEN 'Very low, always tired'
    END
FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ENERGY_LEVELS';

-- =====================================================
-- SECTION 3: PHYSIOLOGICAL & MEDICAL (Causes 6-21)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('SNORING_SEVERITY', 'SINGLE', 1, FALSE, '{RAPID,COMPLETE}'),
    ('BREATHING_PAUSES', 'SINGLE', 2, FALSE, '{RAPID,COMPLETE}'),
    ('ACID_REFLUX', 'SINGLE', 3, FALSE, '{RAPID,COMPLETE}'),
    ('NOCTURIA', 'SINGLE', 4, FALSE, '{RAPID,COMPLETE}'),
    ('CHRONIC_PAIN', 'SINGLE', 5, FALSE, '{RAPID,COMPLETE}'),
    ('CIRCULATION_ISSUES', 'SINGLE', 6, FALSE, '{COMPLETE}'),
    ('BLOOD_PRESSURE', 'SINGLE', 7, FALSE, '{COMPLETE}'),
    ('HEADACHES_MORNING', 'SINGLE', 8, FALSE, '{COMPLETE}'),
    ('NASAL_CONGESTION', 'SINGLE', 9, FALSE, '{RAPID,COMPLETE}'),
    ('RESTLESS_LEGS_SYNDROME', 'SINGLE', 10, FALSE, '{COMPLETE}'),
    ('LEG_CRAMPS', 'SINGLE', 11, FALSE, '{COMPLETE}'),
    ('THYROID_ISSUES', 'SINGLE', 12, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_PHYSIOLOGICAL';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'SNORING_SEVERITY' THEN 'Do you snore or has anyone told you that you snore?'
        WHEN 'BREATHING_PAUSES' THEN 'Has anyone observed you stop breathing or gasp during sleep?'
        WHEN 'ACID_REFLUX' THEN 'Do you experience heartburn, acid reflux, or wake up with a sour taste?'
        WHEN 'NOCTURIA' THEN 'How often do you wake up to use the bathroom at night?'
        WHEN 'CHRONIC_PAIN' THEN 'Do you have chronic pain that affects your sleep?'
        WHEN 'CIRCULATION_ISSUES' THEN 'Do you experience cold hands/feet or numbness during sleep?'
        WHEN 'BLOOD_PRESSURE' THEN 'Do you have blood pressure issues?'
        WHEN 'HEADACHES_MORNING' THEN 'Do you wake up with headaches?'
        WHEN 'NASAL_CONGESTION' THEN 'Do you have nasal congestion or difficulty breathing through your nose?'
        WHEN 'RESTLESS_LEGS_SYNDROME' THEN 'Do you feel an urge to move your legs or uncomfortable sensations at rest?'
        WHEN 'LEG_CRAMPS' THEN 'Do you experience leg cramps during the night?'
        WHEN 'THYROID_ISSUES' THEN 'Do you have thyroid problems (hyper or hypothyroidism)?'
    END,
    CASE q.code
        WHEN 'SNORING_SEVERITY' THEN 'Snoring may indicate airway obstruction'
        WHEN 'BREATHING_PAUSES' THEN 'This is a key sign of sleep apnea - seek evaluation if yes'
        WHEN 'ACID_REFLUX' THEN 'Reflux worsens when lying down and fragments sleep'
        WHEN 'NOCTURIA' THEN 'Frequent urination disrupts sleep cycles'
        WHEN 'CHRONIC_PAIN' THEN 'Pain prevents deep, restorative sleep'
        WHEN 'CIRCULATION_ISSUES' THEN 'Poor circulation can trigger awakenings'
        WHEN 'BLOOD_PRESSURE' THEN 'Both high and low BP can affect sleep'
        WHEN 'HEADACHES_MORNING' THEN 'Morning headaches can indicate sleep apnea or teeth grinding'
        WHEN 'NASAL_CONGESTION' THEN 'Nasal breathing is important for quality sleep'
        WHEN 'RESTLESS_LEGS_SYNDROME' THEN 'RLS is a common sleep disorder'
        WHEN 'LEG_CRAMPS' THEN 'May indicate dehydration or mineral deficiency'
        WHEN 'THYROID_ISSUES' THEN 'Thyroid imbalances significantly affect sleep'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_PHYSIOLOGICAL';

-- SNORING_SEVERITY answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('LIGHT', 2), ('LOUD', 3), ('WITH_PAUSES', 4)) AS a(code, order_index)
WHERE q.code = 'SNORING_SEVERITY';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No snoring' WHEN 'LIGHT' THEN 'Light snoring occasionally'
    WHEN 'LOUD' THEN 'Loud snoring regularly' WHEN 'WITH_PAUSES' THEN 'Snoring with breathing pauses'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'SNORING_SEVERITY';

-- BREATHING_PAUSES answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('UNSURE', 2), ('OCCASIONALLY', 3), ('FREQUENTLY', 4)) AS a(code, order_index)
WHERE q.code = 'BREATHING_PAUSES';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN 'UNSURE' THEN 'Not sure / no one has observed'
    WHEN 'OCCASIONALLY' THEN 'Yes, occasionally' WHEN 'FREQUENTLY' THEN 'Yes, frequently'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'BREATHING_PAUSES';

-- ACID_REFLUX answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('OCCASIONALLY', 2), ('FREQUENTLY', 3), ('NIGHTLY', 4)) AS a(code, order_index)
WHERE q.code = 'ACID_REFLUX';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never or rarely' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'FREQUENTLY' THEN 'Frequently' WHEN 'NIGHTLY' THEN 'Almost every night'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ACID_REFLUX';

-- NOCTURIA answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('ONCE', 2), ('TWICE', 3), ('THREE_PLUS', 4)) AS a(code, order_index)
WHERE q.code = 'NOCTURIA';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Rarely or never' WHEN 'ONCE' THEN 'Once per night'
    WHEN 'TWICE' THEN 'Twice per night' WHEN 'THREE_PLUS' THEN '3 or more times'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'NOCTURIA';

-- CHRONIC_PAIN answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('MILD', 2), ('MODERATE', 3), ('SEVERE', 4)) AS a(code, order_index)
WHERE q.code = 'CHRONIC_PAIN';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No chronic pain' WHEN 'MILD' THEN 'Mild pain occasionally'
    WHEN 'MODERATE' THEN 'Moderate pain affecting sleep' WHEN 'SEVERE' THEN 'Severe pain regularly disrupting sleep'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'CHRONIC_PAIN';

-- CIRCULATION_ISSUES answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('OCCASIONALLY', 2), ('OFTEN', 3), ('EVERY_NIGHT', 4)) AS a(code, order_index)
WHERE q.code = 'CIRCULATION_ISSUES';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'OFTEN' THEN 'Often' WHEN 'EVERY_NIGHT' THEN 'Every night'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'CIRCULATION_ISSUES';

-- BLOOD_PRESSURE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NORMAL', 1), ('HIGH', 2), ('LOW', 3), ('VARIABLE', 4)) AS a(code, order_index)
WHERE q.code = 'BLOOD_PRESSURE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NORMAL' THEN 'Normal' WHEN 'HIGH' THEN 'High blood pressure'
    WHEN 'LOW' THEN 'Low blood pressure' WHEN 'VARIABLE' THEN 'Variable / not sure'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'BLOOD_PRESSURE';

-- HEADACHES_MORNING answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('OCCASIONALLY', 2), ('FREQUENTLY', 3), ('DAILY', 4)) AS a(code, order_index)
WHERE q.code = 'HEADACHES_MORNING';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never or rarely' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'FREQUENTLY' THEN 'Frequently' WHEN 'DAILY' THEN 'Almost daily'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'HEADACHES_MORNING';

-- NASAL_CONGESTION answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('SEASONAL', 2), ('OFTEN', 3), ('CHRONIC', 4)) AS a(code, order_index)
WHERE q.code = 'NASAL_CONGESTION';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never or rarely' WHEN 'SEASONAL' THEN 'Seasonal allergies'
    WHEN 'OFTEN' THEN 'Often congested' WHEN 'CHRONIC' THEN 'Chronic congestion'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'NASAL_CONGESTION';

-- RESTLESS_LEGS_SYNDROME answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('OCCASIONALLY', 2), ('OFTEN', 3), ('EVERY_NIGHT', 4)) AS a(code, order_index)
WHERE q.code = 'RESTLESS_LEGS_SYNDROME';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'OFTEN' THEN 'Often' WHEN 'EVERY_NIGHT' THEN 'Almost every night'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'RESTLESS_LEGS_SYNDROME';

-- LEG_CRAMPS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('OCCASIONALLY', 2), ('FREQUENTLY', 3), ('NIGHTLY', 4)) AS a(code, order_index)
WHERE q.code = 'LEG_CRAMPS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never or rarely' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'FREQUENTLY' THEN 'Frequently' WHEN 'NIGHTLY' THEN 'Almost every night'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'LEG_CRAMPS';

-- THYROID_ISSUES answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('HYPO', 2), ('HYPER', 3), ('UNKNOWN', 4)) AS a(code, order_index)
WHERE q.code = 'THYROID_ISSUES';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No thyroid issues' WHEN 'HYPO' THEN 'Hypothyroidism (underactive)'
    WHEN 'HYPER' THEN 'Hyperthyroidism (overactive)' WHEN 'UNKNOWN' THEN 'Not sure / untested'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'THYROID_ISSUES';

-- =====================================================
-- SECTION 4: NEUROLOGICAL & PARASOMNIAS (Causes 22-29)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('NIGHTMARES', 'SINGLE', 1, FALSE, '{COMPLETE}'),
    ('VIVID_DREAMS', 'SINGLE', 2, FALSE, '{COMPLETE}'),
    ('SLEEPWALKING', 'SINGLE', 3, FALSE, '{COMPLETE}'),
    ('NIGHT_TERRORS', 'SINGLE', 4, FALSE, '{COMPLETE}'),
    ('SLEEP_PARALYSIS', 'SINGLE', 5, FALSE, '{COMPLETE}'),
    ('HYPNIC_JERKS', 'SINGLE', 6, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_NEUROLOGICAL';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'NIGHTMARES' THEN 'How often do you have nightmares or disturbing dreams?'
        WHEN 'VIVID_DREAMS' THEN 'Do you have unusually vivid or intense dreams?'
        WHEN 'SLEEPWALKING' THEN 'Do you sleepwalk, talk in your sleep, or act out dreams?'
        WHEN 'NIGHT_TERRORS' THEN 'Do you wake up screaming, confused, or with intense fear?'
        WHEN 'SLEEP_PARALYSIS' THEN 'Do you experience inability to move when waking up?'
        WHEN 'HYPNIC_JERKS' THEN 'Do you experience sudden jerks or a falling sensation when falling asleep?'
    END,
    CASE q.code
        WHEN 'NIGHTMARES' THEN 'Frequent nightmares can indicate stress or trauma'
        WHEN 'VIVID_DREAMS' THEN 'Can be caused by medications, stress, or sleep disorders'
        WHEN 'SLEEPWALKING' THEN 'These are parasomnias - sleep behaviors'
        WHEN 'NIGHT_TERRORS' THEN 'Night terrors are different from nightmares'
        WHEN 'SLEEP_PARALYSIS' THEN 'Brief paralysis on waking can be frightening but usually harmless'
        WHEN 'HYPNIC_JERKS' THEN 'These are common but can be worsened by stress or caffeine'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_NEUROLOGICAL';

-- NIGHTMARES answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('RARELY', 1), ('MONTHLY', 2), ('WEEKLY', 3), ('FREQUENTLY', 4)) AS a(code, order_index)
WHERE q.code = 'NIGHTMARES';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'RARELY' THEN 'Rarely or never' WHEN 'MONTHLY' THEN 'A few times a month'
    WHEN 'WEEKLY' THEN 'Weekly' WHEN 'FREQUENTLY' THEN 'Several times a week'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'NIGHTMARES';

-- VIVID_DREAMS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('EVERY_NIGHT', 4)) AS a(code, order_index)
WHERE q.code = 'VIVID_DREAMS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN 'SOMETIMES' THEN 'Sometimes'
    WHEN 'OFTEN' THEN 'Often' WHEN 'EVERY_NIGHT' THEN 'Almost every night'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'VIVID_DREAMS';

-- SLEEPWALKING answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('PAST', 2), ('OCCASIONALLY', 3), ('REGULARLY', 4)) AS a(code, order_index)
WHERE q.code = 'SLEEPWALKING';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never' WHEN 'PAST' THEN 'In the past but not anymore'
    WHEN 'OCCASIONALLY' THEN 'Occasionally' WHEN 'REGULARLY' THEN 'Regularly'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'SLEEPWALKING';

-- NIGHT_TERRORS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('RARELY', 2), ('SOMETIMES', 3), ('OFTEN', 4)) AS a(code, order_index)
WHERE q.code = 'NIGHT_TERRORS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never' WHEN 'RARELY' THEN 'Rarely'
    WHEN 'SOMETIMES' THEN 'Sometimes' WHEN 'OFTEN' THEN 'Often'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'NIGHT_TERRORS';

-- SLEEP_PARALYSIS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('RARELY', 2), ('SOMETIMES', 3), ('OFTEN', 4)) AS a(code, order_index)
WHERE q.code = 'SLEEP_PARALYSIS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never' WHEN 'RARELY' THEN 'Rarely'
    WHEN 'SOMETIMES' THEN 'Sometimes' WHEN 'OFTEN' THEN 'Often'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'SLEEP_PARALYSIS';

-- HYPNIC_JERKS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('OCCASIONALLY', 2), ('OFTEN', 3), ('NIGHTLY', 4)) AS a(code, order_index)
WHERE q.code = 'HYPNIC_JERKS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never or rarely' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'OFTEN' THEN 'Often' WHEN 'NIGHTLY' THEN 'Almost every night'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'HYPNIC_JERKS';

-- =====================================================
-- SECTION 5: PSYCHOLOGICAL & EMOTIONAL (Causes 30-37)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('ANXIETY_LEVEL', 'SINGLE', 1, FALSE, '{RAPID,COMPLETE}'),
    ('PANIC_ATTACKS', 'SINGLE', 2, FALSE, '{COMPLETE}'),
    ('TRAUMA_HISTORY', 'SINGLE', 3, FALSE, '{COMPLETE}'),
    ('DEPRESSION_SYMPTOMS', 'SINGLE', 4, FALSE, '{RAPID,COMPLETE}'),
    ('RACING_THOUGHTS', 'SINGLE', 5, FALSE, '{RAPID,COMPLETE}'),
    ('SLEEP_ANXIETY', 'SINGLE', 6, FALSE, '{RAPID,COMPLETE}'),
    ('CLOCK_WATCHING', 'SINGLE', 7, FALSE, '{COMPLETE}'),
    ('ANTICIPATORY_WAKING', 'SINGLE', 8, FALSE, '{COMPLETE}'),
    ('BED_ASSOCIATION', 'SINGLE', 9, FALSE, '{COMPLETE}'),
    ('EMOTIONAL_PROCESSING', 'SINGLE', 10, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_PSYCHOLOGICAL';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'ANXIETY_LEVEL' THEN 'How often do you experience anxiety or worry?'
        WHEN 'PANIC_ATTACKS' THEN 'Do you experience panic attacks, especially at night?'
        WHEN 'TRAUMA_HISTORY' THEN 'Have you experienced trauma that still affects your sleep?'
        WHEN 'DEPRESSION_SYMPTOMS' THEN 'Have you felt persistently sad, hopeless, or lost interest in things?'
        WHEN 'RACING_THOUGHTS' THEN 'Do you have racing thoughts when trying to sleep?'
        WHEN 'SLEEP_ANXIETY' THEN 'Do you worry about not being able to sleep?'
        WHEN 'CLOCK_WATCHING' THEN 'Do you check the time when you wake up at night?'
        WHEN 'ANTICIPATORY_WAKING' THEN 'Do you wake up before your alarm due to worry about the day ahead?'
        WHEN 'BED_ASSOCIATION' THEN 'Do you associate your bed with stress, work, or wakefulness?'
        WHEN 'EMOTIONAL_PROCESSING' THEN 'Do you process the day''s events or emotions when in bed?'
    END,
    CASE q.code
        WHEN 'ANXIETY_LEVEL' THEN 'Anxiety is a major cause of sleep problems'
        WHEN 'PANIC_ATTACKS' THEN 'Nocturnal panic attacks are different from nightmares'
        WHEN 'TRAUMA_HISTORY' THEN 'PTSD and trauma commonly cause sleep disturbance'
        WHEN 'DEPRESSION_SYMPTOMS' THEN 'Depression often causes early morning waking or excessive sleep'
        WHEN 'RACING_THOUGHTS' THEN 'An overactive mind prevents sleep'
        WHEN 'SLEEP_ANXIETY' THEN 'Worrying about sleep creates a vicious cycle'
        WHEN 'CLOCK_WATCHING' THEN 'Clock watching increases anxiety about sleep'
        WHEN 'ANTICIPATORY_WAKING' THEN 'Stress about upcoming events can cause early waking'
        WHEN 'BED_ASSOCIATION' THEN 'The bed should be associated only with sleep and intimacy'
        WHEN 'EMOTIONAL_PROCESSING' THEN 'Nighttime rumination interferes with sleep'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_PSYCHOLOGICAL';

-- ANXIETY_LEVEL answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('RARELY', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('CONSTANTLY', 4)) AS a(code, order_index)
WHERE q.code = 'ANXIETY_LEVEL';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'RARELY' THEN 'Rarely or never' WHEN 'SOMETIMES' THEN 'Sometimes'
    WHEN 'OFTEN' THEN 'Often' WHEN 'CONSTANTLY' THEN 'Almost constantly'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ANXIETY_LEVEL';

-- PANIC_ATTACKS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('RARELY', 2), ('SOMETIMES', 3), ('FREQUENTLY', 4)) AS a(code, order_index)
WHERE q.code = 'PANIC_ATTACKS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never' WHEN 'RARELY' THEN 'Rarely'
    WHEN 'SOMETIMES' THEN 'Sometimes' WHEN 'FREQUENTLY' THEN 'Frequently'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'PANIC_ATTACKS';

-- TRAUMA_HISTORY answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('PAST_RESOLVED', 2), ('YES_MILD', 3), ('YES_SIGNIFICANT', 4)) AS a(code, order_index)
WHERE q.code = 'TRAUMA_HISTORY';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN 'PAST_RESOLVED' THEN 'Past trauma, mostly resolved'
    WHEN 'YES_MILD' THEN 'Yes, mild impact on sleep' WHEN 'YES_SIGNIFICANT' THEN 'Yes, significant impact on sleep'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'TRAUMA_HISTORY';

-- DEPRESSION_SYMPTOMS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('PERSISTENTLY', 4)) AS a(code, order_index)
WHERE q.code = 'DEPRESSION_SYMPTOMS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN 'SOMETIMES' THEN 'Sometimes'
    WHEN 'OFTEN' THEN 'Often' WHEN 'PERSISTENTLY' THEN 'Persistently for 2+ weeks'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'DEPRESSION_SYMPTOMS';

-- RACING_THOUGHTS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('EVERY_NIGHT', 4)) AS a(code, order_index)
WHERE q.code = 'RACING_THOUGHTS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never or rarely' WHEN 'SOMETIMES' THEN 'Sometimes'
    WHEN 'OFTEN' THEN 'Often' WHEN 'EVERY_NIGHT' THEN 'Almost every night'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'RACING_THOUGHTS';

-- SLEEP_ANXIETY answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('ALWAYS', 4)) AS a(code, order_index)
WHERE q.code = 'SLEEP_ANXIETY';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No, I don''t think about it' WHEN 'SOMETIMES' THEN 'Sometimes'
    WHEN 'OFTEN' THEN 'Often' WHEN 'ALWAYS' THEN 'Yes, it''s a major concern'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'SLEEP_ANXIETY';

-- CLOCK_WATCHING answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('ALWAYS', 4)) AS a(code, order_index)
WHERE q.code = 'CLOCK_WATCHING';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never' WHEN 'SOMETIMES' THEN 'Sometimes'
    WHEN 'OFTEN' THEN 'Often' WHEN 'ALWAYS' THEN 'Always'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'CLOCK_WATCHING';

-- ANTICIPATORY_WAKING answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('OCCASIONALLY', 2), ('OFTEN', 3), ('REGULARLY', 4)) AS a(code, order_index)
WHERE q.code = 'ANTICIPATORY_WAKING';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'OFTEN' THEN 'Often' WHEN 'REGULARLY' THEN 'Regularly'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ANTICIPATORY_WAKING';

-- BED_ASSOCIATION answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('YES', 4)) AS a(code, order_index)
WHERE q.code = 'BED_ASSOCIATION';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No, bed means sleep' WHEN 'SOMETIMES' THEN 'Sometimes'
    WHEN 'OFTEN' THEN 'Often' WHEN 'YES' THEN 'Yes, I dread going to bed'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'BED_ASSOCIATION';

-- EMOTIONAL_PROCESSING answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('RARELY', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('EVERY_NIGHT', 4)) AS a(code, order_index)
WHERE q.code = 'EMOTIONAL_PROCESSING';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'RARELY' THEN 'Rarely' WHEN 'SOMETIMES' THEN 'Sometimes'
    WHEN 'OFTEN' THEN 'Often' WHEN 'EVERY_NIGHT' THEN 'Every night'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'EMOTIONAL_PROCESSING';

-- =====================================================
-- SECTION 6: NERVOUS SYSTEM (Causes 38-40)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('HYPERVIGILANCE', 'SINGLE', 1, FALSE, '{COMPLETE}'),
    ('LIGHT_SLEEPER', 'SINGLE', 2, FALSE, '{COMPLETE}'),
    ('READORMIRE_DIFFICULTY', 'SINGLE', 3, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_NERVOUS_SYSTEM';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'HYPERVIGILANCE' THEN 'Do you feel constantly on alert or unable to relax even when safe?'
        WHEN 'LIGHT_SLEEPER' THEN 'Are you a light sleeper who wakes at the smallest noise?'
        WHEN 'READORMIRE_DIFFICULTY' THEN 'When you wake at night, how hard is it to fall back asleep?'
    END,
    CASE q.code
        WHEN 'HYPERVIGILANCE' THEN 'A chronically activated nervous system prevents deep sleep'
        WHEN 'LIGHT_SLEEPER' THEN 'Light sleep may indicate the brain doesn''t feel safe'
        WHEN 'READORMIRE_DIFFICULTY' THEN 'Difficulty returning to sleep often involves the analytical mind'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_NERVOUS_SYSTEM';

-- HYPERVIGILANCE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('CONSTANTLY', 4)) AS a(code, order_index)
WHERE q.code = 'HYPERVIGILANCE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No, I can relax easily' WHEN 'SOMETIMES' THEN 'Sometimes'
    WHEN 'OFTEN' THEN 'Often feel on edge' WHEN 'CONSTANTLY' THEN 'Constantly on alert'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'HYPERVIGILANCE';

-- LIGHT_SLEEPER answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('DEEP', 1), ('MODERATE', 2), ('LIGHT', 3), ('VERY_LIGHT', 4)) AS a(code, order_index)
WHERE q.code = 'LIGHT_SLEEPER';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'DEEP' THEN 'Deep sleeper - hard to wake' WHEN 'MODERATE' THEN 'Moderate'
    WHEN 'LIGHT' THEN 'Light sleeper' WHEN 'VERY_LIGHT' THEN 'Very light - wake at any sound'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'LIGHT_SLEEPER';

-- READORMIRE_DIFFICULTY answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NOT_APPLICABLE', 1), ('EASY', 2), ('MODERATE', 3), ('VERY_DIFFICULT', 4)) AS a(code, order_index)
WHERE q.code = 'READORMIRE_DIFFICULTY';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NOT_APPLICABLE' THEN 'I don''t wake at night' WHEN 'EASY' THEN 'Easy - fall back asleep quickly'
    WHEN 'MODERATE' THEN 'Takes some time' WHEN 'VERY_DIFFICULT' THEN 'Very difficult - often stay awake'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'READORMIRE_DIFFICULTY';

-- =====================================================
-- SECTION 7: MICROBIOME & GUT-BRAIN (Causes 41-42)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('DIGESTIVE_ISSUES', 'SINGLE', 1, FALSE, '{COMPLETE}'),
    ('FOOD_SENSITIVITIES', 'SINGLE', 2, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_MICROBIOME';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'DIGESTIVE_ISSUES' THEN 'Do you experience bloating, gas, or digestive discomfort, especially at night?'
        WHEN 'FOOD_SENSITIVITIES' THEN 'Do you have food sensitivities or notice certain foods affect your sleep?'
    END,
    CASE q.code
        WHEN 'DIGESTIVE_ISSUES' THEN 'Gut fermentation and discomfort can disrupt sleep'
        WHEN 'FOOD_SENSITIVITIES' THEN 'Food intolerances can cause inflammation affecting sleep'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_MICROBIOME';

-- DIGESTIVE_ISSUES answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('OCCASIONALLY', 2), ('FREQUENTLY', 3), ('NIGHTLY', 4)) AS a(code, order_index)
WHERE q.code = 'DIGESTIVE_ISSUES';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never or rarely' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'FREQUENTLY' THEN 'Frequently' WHEN 'NIGHTLY' THEN 'Almost every night'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'DIGESTIVE_ISSUES';

-- FOOD_SENSITIVITIES answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('POSSIBLY', 2), ('YES_SOME', 3), ('YES_MANY', 4)) AS a(code, order_index)
WHERE q.code = 'FOOD_SENSITIVITIES';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No known sensitivities' WHEN 'POSSIBLY' THEN 'Possibly, not sure'
    WHEN 'YES_SOME' THEN 'Yes, a few foods' WHEN 'YES_MANY' THEN 'Yes, multiple sensitivities'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'FOOD_SENSITIVITIES';

-- =====================================================
-- SECTION 8: CIRCADIAN RHYTHM (Causes 43-45)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('SLEEP_SCHEDULE', 'SINGLE', 1, FALSE, '{RAPID,COMPLETE}'),
    ('SHIFT_WORK', 'SINGLE', 2, FALSE, '{RAPID,COMPLETE}'),
    ('WEEKEND_DIFFERENCE', 'SINGLE', 3, FALSE, '{RAPID,COMPLETE}'),
    ('MORNING_LIGHT', 'SINGLE', 4, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_CIRCADIAN';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'SLEEP_SCHEDULE' THEN 'How consistent is your sleep/wake schedule?'
        WHEN 'SHIFT_WORK' THEN 'Do you work night shifts or rotating shifts?'
        WHEN 'WEEKEND_DIFFERENCE' THEN 'How different is your weekend sleep from weekdays?'
        WHEN 'MORNING_LIGHT' THEN 'Do you get natural light exposure within 1 hour of waking?'
    END,
    CASE q.code
        WHEN 'SLEEP_SCHEDULE' THEN 'Consistent timing helps regulate your body clock'
        WHEN 'SHIFT_WORK' THEN 'Shift work significantly disrupts circadian rhythm'
        WHEN 'WEEKEND_DIFFERENCE' THEN 'Large differences cause "social jet lag"'
        WHEN 'MORNING_LIGHT' THEN 'Morning light helps set your circadian rhythm'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_CIRCADIAN';

-- SLEEP_SCHEDULE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('VERY_CONSISTENT', 1), ('MOSTLY', 2), ('VARIABLE', 3), ('VERY_IRREGULAR', 4)) AS a(code, order_index)
WHERE q.code = 'SLEEP_SCHEDULE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'VERY_CONSISTENT' THEN 'Very consistent (same time daily)' WHEN 'MOSTLY' THEN 'Mostly consistent'
    WHEN 'VARIABLE' THEN 'Variable (1-2 hour differences)' WHEN 'VERY_IRREGULAR' THEN 'Very irregular'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'SLEEP_SCHEDULE';

-- SHIFT_WORK answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('OCCASIONAL', 2), ('NIGHT_SHIFT', 3), ('ROTATING', 4)) AS a(code, order_index)
WHERE q.code = 'SHIFT_WORK';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No, regular daytime hours' WHEN 'OCCASIONAL' THEN 'Occasional irregular hours'
    WHEN 'NIGHT_SHIFT' THEN 'Regular night shifts' WHEN 'ROTATING' THEN 'Rotating shifts'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'SHIFT_WORK';

-- WEEKEND_DIFFERENCE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('SAME', 1), ('1_HOUR', 2), ('2_HOURS', 3), ('3_PLUS', 4)) AS a(code, order_index)
WHERE q.code = 'WEEKEND_DIFFERENCE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'SAME' THEN 'About the same' WHEN '1_HOUR' THEN 'About 1 hour difference'
    WHEN '2_HOURS' THEN 'About 2 hours difference' WHEN '3_PLUS' THEN '3+ hours difference'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'WEEKEND_DIFFERENCE';

-- MORNING_LIGHT answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('YES_DAILY', 1), ('SOMETIMES', 2), ('RARELY', 3), ('NEVER', 4)) AS a(code, order_index)
WHERE q.code = 'MORNING_LIGHT';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'YES_DAILY' THEN 'Yes, daily' WHEN 'SOMETIMES' THEN 'Sometimes'
    WHEN 'RARELY' THEN 'Rarely' WHEN 'NEVER' THEN 'Never or work indoors all day'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'MORNING_LIGHT';

-- =====================================================
-- SECTION 9: ENVIRONMENT (Causes 46-52)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('ROOM_TEMPERATURE', 'SINGLE', 1, FALSE, '{RAPID,COMPLETE}'),
    ('ROOM_HUMIDITY', 'SINGLE', 2, FALSE, '{COMPLETE}'),
    ('ROOM_DARKNESS', 'SINGLE', 3, FALSE, '{RAPID,COMPLETE}'),
    ('NOISE_LEVEL', 'SINGLE', 4, FALSE, '{RAPID,COMPLETE}'),
    ('AIR_QUALITY', 'SINGLE', 5, FALSE, '{COMPLETE}'),
    ('ALLERGENS', 'SINGLE', 6, FALSE, '{COMPLETE}'),
    ('EMF_EXPOSURE', 'SINGLE', 7, FALSE, '{COMPLETE}'),
    ('ALTITUDE', 'SINGLE', 8, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_ENVIRONMENT';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'ROOM_TEMPERATURE' THEN 'How would you describe your bedroom temperature?'
        WHEN 'ROOM_HUMIDITY' THEN 'How is the humidity in your bedroom?'
        WHEN 'ROOM_DARKNESS' THEN 'How dark is your bedroom when you sleep?'
        WHEN 'NOISE_LEVEL' THEN 'How noisy is your sleeping environment?'
        WHEN 'AIR_QUALITY' THEN 'How is the air quality in your bedroom?'
        WHEN 'ALLERGENS' THEN 'Do you have allergens in your bedroom (dust, mold, pet dander)?'
        WHEN 'EMF_EXPOSURE' THEN 'Do you sleep near electronic devices (phone, router, smart meter)?'
        WHEN 'ALTITUDE' THEN 'Do you live at high altitude (above 2500m/8000ft)?'
    END,
    CASE q.code
        WHEN 'ROOM_TEMPERATURE' THEN 'Cool temperatures (16-19°C/60-67°F) are ideal for sleep'
        WHEN 'ROOM_HUMIDITY' THEN 'Too dry or humid air can disrupt sleep'
        WHEN 'ROOM_DARKNESS' THEN 'Darkness helps melatonin production'
        WHEN 'NOISE_LEVEL' THEN 'Noise can disrupt sleep even without full awakening'
        WHEN 'AIR_QUALITY' THEN 'Poor air quality affects breathing and sleep quality'
        WHEN 'ALLERGENS' THEN 'Allergens cause congestion and disrupt sleep'
        WHEN 'EMF_EXPOSURE' THEN 'Some people are sensitive to electromagnetic fields'
        WHEN 'ALTITUDE' THEN 'High altitude reduces oxygen and affects sleep'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_ENVIRONMENT';

-- ROOM_TEMPERATURE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('TOO_COLD', 1), ('COOL', 2), ('COMFORTABLE', 3), ('WARM', 4), ('TOO_HOT', 5)) AS a(code, order_index)
WHERE q.code = 'ROOM_TEMPERATURE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'TOO_COLD' THEN 'Too cold' WHEN 'COOL' THEN 'Cool (ideal)'
    WHEN 'COMFORTABLE' THEN 'Comfortable/neutral' WHEN 'WARM' THEN 'Warm' WHEN 'TOO_HOT' THEN 'Too hot'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ROOM_TEMPERATURE';

-- ROOM_HUMIDITY answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('TOO_DRY', 1), ('GOOD', 2), ('TOO_HUMID', 3), ('UNKNOWN', 4)) AS a(code, order_index)
WHERE q.code = 'ROOM_HUMIDITY';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'TOO_DRY' THEN 'Too dry (dry nose/throat)' WHEN 'GOOD' THEN 'Good/comfortable'
    WHEN 'TOO_HUMID' THEN 'Too humid (damp feeling)' WHEN 'UNKNOWN' THEN 'Not sure'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ROOM_HUMIDITY';

-- ROOM_DARKNESS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('VERY_DARK', 1), ('SOMEWHAT_DARK', 2), ('SOME_LIGHT', 3), ('BRIGHT', 4)) AS a(code, order_index)
WHERE q.code = 'ROOM_DARKNESS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'VERY_DARK' THEN 'Very dark (blackout)' WHEN 'SOMEWHAT_DARK' THEN 'Somewhat dark'
    WHEN 'SOME_LIGHT' THEN 'Some light comes in' WHEN 'BRIGHT' THEN 'Quite bright'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ROOM_DARKNESS';

-- NOISE_LEVEL answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('SILENT', 1), ('QUIET', 2), ('SOME_NOISE', 3), ('NOISY', 4)) AS a(code, order_index)
WHERE q.code = 'NOISE_LEVEL';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'SILENT' THEN 'Very quiet/silent' WHEN 'QUIET' THEN 'Generally quiet'
    WHEN 'SOME_NOISE' THEN 'Some noise (traffic, neighbors)' WHEN 'NOISY' THEN 'Noisy environment'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'NOISE_LEVEL';

-- AIR_QUALITY answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('GOOD', 1), ('OKAY', 2), ('STUFFY', 3), ('POOR', 4)) AS a(code, order_index)
WHERE q.code = 'AIR_QUALITY';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'GOOD' THEN 'Good, fresh air' WHEN 'OKAY' THEN 'Okay'
    WHEN 'STUFFY' THEN 'Stuffy, not well ventilated' WHEN 'POOR' THEN 'Poor quality (pollution, smells)'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'AIR_QUALITY';

-- ALLERGENS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('POSSIBLY', 2), ('YES_SOME', 3), ('YES_MANY', 4)) AS a(code, order_index)
WHERE q.code = 'ALLERGENS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN 'POSSIBLY' THEN 'Possibly'
    WHEN 'YES_SOME' THEN 'Yes, some' WHEN 'YES_MANY' THEN 'Yes, significant allergens'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ALLERGENS';

-- EMF_EXPOSURE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('PHONE_NEARBY', 2), ('MULTIPLE', 3), ('ROUTER_NEARBY', 4)) AS a(code, order_index)
WHERE q.code = 'EMF_EXPOSURE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No devices near bed' WHEN 'PHONE_NEARBY' THEN 'Phone on nightstand'
    WHEN 'MULTIPLE' THEN 'Multiple devices nearby' WHEN 'ROUTER_NEARBY' THEN 'WiFi router in bedroom'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'EMF_EXPOSURE';

-- ALTITUDE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('MODERATE', 2), ('HIGH', 3), ('VERY_HIGH', 4)) AS a(code, order_index)
WHERE q.code = 'ALTITUDE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No (sea level to 1500m)' WHEN 'MODERATE' THEN 'Moderate (1500-2500m)'
    WHEN 'HIGH' THEN 'High (2500-3500m)' WHEN 'VERY_HIGH' THEN 'Very high (3500m+)'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ALTITUDE';

-- =====================================================
-- SECTION 10: BED & BEDDING (Causes 53-58)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('MATTRESS_COMFORT', 'SINGLE', 1, FALSE, '{RAPID,COMPLETE}'),
    ('PILLOW_COMFORT', 'SINGLE', 2, FALSE, '{RAPID,COMPLETE}'),
    ('BEDDING_MATERIAL', 'SINGLE', 3, FALSE, '{COMPLETE}'),
    ('BLANKET_TEMP', 'SINGLE', 4, FALSE, '{RAPID,COMPLETE}'),
    ('SLEEPWEAR', 'SINGLE', 5, FALSE, '{COMPLETE}'),
    ('BED_HYGIENE', 'SINGLE', 6, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_BED_SETUP';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'MATTRESS_COMFORT' THEN 'How comfortable is your mattress?'
        WHEN 'PILLOW_COMFORT' THEN 'How comfortable is your pillow?'
        WHEN 'BEDDING_MATERIAL' THEN 'What material are your sheets and bedding?'
        WHEN 'BLANKET_TEMP' THEN 'Do you get too hot or too cold under your blankets?'
        WHEN 'SLEEPWEAR' THEN 'Is your sleepwear comfortable and breathable?'
        WHEN 'BED_HYGIENE' THEN 'Have you noticed any issues with your bed (bugs, old mattress, dust)?'
    END,
    CASE q.code
        WHEN 'MATTRESS_COMFORT' THEN 'An uncomfortable mattress causes pain and poor sleep'
        WHEN 'PILLOW_COMFORT' THEN 'Proper neck support is important for quality sleep'
        WHEN 'BEDDING_MATERIAL' THEN 'Natural materials breathe better than synthetics'
        WHEN 'BLANKET_TEMP' THEN 'Temperature regulation is crucial for sleep'
        WHEN 'SLEEPWEAR' THEN 'Restrictive or synthetic sleepwear can disrupt sleep'
        WHEN 'BED_HYGIENE' THEN 'Old mattresses harbor allergens and lose support'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_BED_SETUP';

-- MATTRESS_COMFORT answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('VERY_COMFORTABLE', 1), ('COMFORTABLE', 2), ('SOMEWHAT_UNCOMFORTABLE', 3), ('UNCOMFORTABLE', 4)) AS a(code, order_index)
WHERE q.code = 'MATTRESS_COMFORT';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'VERY_COMFORTABLE' THEN 'Very comfortable' WHEN 'COMFORTABLE' THEN 'Comfortable enough'
    WHEN 'SOMEWHAT_UNCOMFORTABLE' THEN 'Somewhat uncomfortable' WHEN 'UNCOMFORTABLE' THEN 'Uncomfortable - needs replacing'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'MATTRESS_COMFORT';

-- PILLOW_COMFORT answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('VERY_COMFORTABLE', 1), ('COMFORTABLE', 2), ('SOMEWHAT_UNCOMFORTABLE', 3), ('UNCOMFORTABLE', 4)) AS a(code, order_index)
WHERE q.code = 'PILLOW_COMFORT';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'VERY_COMFORTABLE' THEN 'Very comfortable' WHEN 'COMFORTABLE' THEN 'Comfortable enough'
    WHEN 'SOMEWHAT_UNCOMFORTABLE' THEN 'Somewhat uncomfortable' WHEN 'UNCOMFORTABLE' THEN 'Uncomfortable'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'PILLOW_COMFORT';

-- BEDDING_MATERIAL answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NATURAL', 1), ('MIXED', 2), ('SYNTHETIC', 3), ('UNKNOWN', 4)) AS a(code, order_index)
WHERE q.code = 'BEDDING_MATERIAL';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NATURAL' THEN 'Natural (cotton, linen, silk)' WHEN 'MIXED' THEN 'Mixed materials'
    WHEN 'SYNTHETIC' THEN 'Synthetic (polyester, microfiber)' WHEN 'UNKNOWN' THEN 'Not sure'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'BEDDING_MATERIAL';

-- BLANKET_TEMP answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('JUST_RIGHT', 1), ('TOO_HOT', 2), ('TOO_COLD', 3), ('VARIES', 4)) AS a(code, order_index)
WHERE q.code = 'BLANKET_TEMP';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'JUST_RIGHT' THEN 'Just right' WHEN 'TOO_HOT' THEN 'Often too hot'
    WHEN 'TOO_COLD' THEN 'Often too cold' WHEN 'VARIES' THEN 'Varies night to night'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'BLANKET_TEMP';

-- SLEEPWEAR answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('COMFORTABLE', 1), ('OKAY', 2), ('TOO_HOT', 3), ('RESTRICTIVE', 4)) AS a(code, order_index)
WHERE q.code = 'SLEEPWEAR';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'COMFORTABLE' THEN 'Comfortable and breathable' WHEN 'OKAY' THEN 'Okay'
    WHEN 'TOO_HOT' THEN 'Often too hot' WHEN 'RESTRICTIVE' THEN 'Restrictive or uncomfortable'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'SLEEPWEAR';

-- BED_HYGIENE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO_ISSUES', 1), ('OLD_MATTRESS', 2), ('DUST_ALLERGENS', 3), ('OTHER_ISSUES', 4)) AS a(code, order_index)
WHERE q.code = 'BED_HYGIENE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO_ISSUES' THEN 'No issues' WHEN 'OLD_MATTRESS' THEN 'Mattress is old (8+ years)'
    WHEN 'DUST_ALLERGENS' THEN 'Dust/allergen concerns' WHEN 'OTHER_ISSUES' THEN 'Other hygiene issues'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'BED_HYGIENE';

-- =====================================================
-- SECTION 11: DENTAL & JAW (Causes 59-61)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('TEETH_GRINDING', 'SINGLE', 1, FALSE, '{COMPLETE}'),
    ('JAW_PAIN', 'SINGLE', 2, FALSE, '{COMPLETE}'),
    ('TINNITUS', 'SINGLE', 3, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_DENTAL';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'TEETH_GRINDING' THEN 'Do you grind your teeth at night (bruxism)?'
        WHEN 'JAW_PAIN' THEN 'Do you experience jaw pain, clicking, or TMJ issues?'
        WHEN 'TINNITUS' THEN 'Do you experience ringing in your ears (tinnitus)?'
    END,
    CASE q.code
        WHEN 'TEETH_GRINDING' THEN 'Bruxism causes micro-awakenings and morning jaw pain'
        WHEN 'JAW_PAIN' THEN 'TMJ dysfunction can affect sleep quality'
        WHEN 'TINNITUS' THEN 'Tinnitus can make it difficult to fall and stay asleep'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_DENTAL';

-- TEETH_GRINDING answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('SOMETIMES', 2), ('OFTEN', 3), ('SEVERE', 4)) AS a(code, order_index)
WHERE q.code = 'TEETH_GRINDING';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN 'SOMETIMES' THEN 'Sometimes (occasional jaw soreness)'
    WHEN 'OFTEN' THEN 'Often (regular jaw pain)' WHEN 'SEVERE' THEN 'Severe (use a night guard)'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'TEETH_GRINDING';

-- JAW_PAIN answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('OCCASIONALLY', 2), ('OFTEN', 3), ('CHRONIC', 4)) AS a(code, order_index)
WHERE q.code = 'JAW_PAIN';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'OFTEN' THEN 'Often' WHEN 'CHRONIC' THEN 'Chronic TMJ issues'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'JAW_PAIN';

-- TINNITUS answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('OCCASIONALLY', 2), ('OFTEN', 3), ('CONSTANT', 4)) AS a(code, order_index)
WHERE q.code = 'TINNITUS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'OFTEN' THEN 'Often' WHEN 'CONSTANT' THEN 'Constant/chronic'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'TINNITUS';

-- =====================================================
-- SECTION 12: SOCIAL & RELATIONAL (Causes 62-64)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('PARTNER_SNORING', 'SINGLE', 1, FALSE, '{RAPID,COMPLETE}'),
    ('PARTNER_MOVEMENT', 'SINGLE', 2, FALSE, '{COMPLETE}'),
    ('PARTNER_SCHEDULE', 'SINGLE', 3, FALSE, '{COMPLETE}'),
    ('PET_DISTURBANCE', 'SINGLE', 4, FALSE, '{RAPID,COMPLETE}'),
    ('CHILDCARE_DISRUPTION', 'SINGLE', 5, FALSE, '{RAPID,COMPLETE}'),
    ('CAREGIVER_DUTIES', 'SINGLE', 6, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_SOCIAL';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'PARTNER_SNORING' THEN 'Does your partner''s snoring disturb your sleep?'
        WHEN 'PARTNER_MOVEMENT' THEN 'Does your partner''s movement or restlessness affect your sleep?'
        WHEN 'PARTNER_SCHEDULE' THEN 'Do you and your partner have different sleep schedules?'
        WHEN 'PET_DISTURBANCE' THEN 'Do your pets disturb your sleep?'
        WHEN 'CHILDCARE_DISRUPTION' THEN 'Do you wake up to care for young children?'
        WHEN 'CAREGIVER_DUTIES' THEN 'Do you have nighttime caregiving responsibilities for elderly/ill family?'
    END,
    CASE q.code
        WHEN 'PARTNER_SNORING' THEN 'Partner snoring is a top cause of sleep disruption'
        WHEN 'PARTNER_MOVEMENT' THEN 'Restless partners can cause frequent awakenings'
        WHEN 'PARTNER_SCHEDULE' THEN 'Different schedules can disrupt each other''s sleep'
        WHEN 'PET_DISTURBANCE' THEN 'Pets can move, make noise, or take space'
        WHEN 'CHILDCARE_DISRUPTION' THEN 'Night feedings and child needs disrupt sleep'
        WHEN 'CAREGIVER_DUTIES' THEN 'Caregiving responsibilities affect sleep quality'
    END
FROM quiz_questions q
JOIN quiz_sections s ON q.section_id = s.id
WHERE s.code = 'SECTION_SOCIAL';

-- PARTNER_SNORING answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO_PARTNER', 1), ('NO', 2), ('SOMETIMES', 3), ('OFTEN', 4)) AS a(code, order_index)
WHERE q.code = 'PARTNER_SNORING';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO_PARTNER' THEN 'No partner / sleep alone' WHEN 'NO' THEN 'No disturbance'
    WHEN 'SOMETIMES' THEN 'Sometimes disturbed' WHEN 'OFTEN' THEN 'Often disturbed'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'PARTNER_SNORING';

-- PARTNER_MOVEMENT answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO_PARTNER', 1), ('NO', 2), ('SOMETIMES', 3), ('OFTEN', 4)) AS a(code, order_index)
WHERE q.code = 'PARTNER_MOVEMENT';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO_PARTNER' THEN 'No partner / sleep alone' WHEN 'NO' THEN 'No disturbance'
    WHEN 'SOMETIMES' THEN 'Sometimes disturbed' WHEN 'OFTEN' THEN 'Often disturbed'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'PARTNER_MOVEMENT';

-- PARTNER_SCHEDULE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO_PARTNER', 1), ('SAME', 2), ('SLIGHTLY_DIFFERENT', 3), ('VERY_DIFFERENT', 4)) AS a(code, order_index)
WHERE q.code = 'PARTNER_SCHEDULE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO_PARTNER' THEN 'No partner / sleep alone' WHEN 'SAME' THEN 'Same schedule'
    WHEN 'SLIGHTLY_DIFFERENT' THEN 'Slightly different' WHEN 'VERY_DIFFERENT' THEN 'Very different schedules'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'PARTNER_SCHEDULE';

-- PET_DISTURBANCE answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO_PETS', 1), ('NO', 2), ('SOMETIMES', 3), ('OFTEN', 4)) AS a(code, order_index)
WHERE q.code = 'PET_DISTURBANCE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO_PETS' THEN 'No pets in bedroom' WHEN 'NO' THEN 'No disturbance'
    WHEN 'SOMETIMES' THEN 'Sometimes disturbed' WHEN 'OFTEN' THEN 'Often disturbed'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'PET_DISTURBANCE';

-- CHILDCARE_DISRUPTION answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO_CHILDREN', 1), ('NO', 2), ('SOMETIMES', 3), ('FREQUENTLY', 4)) AS a(code, order_index)
WHERE q.code = 'CHILDCARE_DISRUPTION';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO_CHILDREN' THEN 'No young children' WHEN 'NO' THEN 'Rarely'
    WHEN 'SOMETIMES' THEN 'Sometimes' WHEN 'FREQUENTLY' THEN 'Frequently'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'CHILDCARE_DISRUPTION';

-- CAREGIVER_DUTIES answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('OCCASIONALLY', 2), ('REGULARLY', 3), ('NIGHTLY', 4)) AS a(code, order_index)
WHERE q.code = 'CAREGIVER_DUTIES';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No caregiving duties' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'REGULARLY' THEN 'Regularly' WHEN 'NIGHTLY' THEN 'Nightly'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'CAREGIVER_DUTIES';

-- =====================================================
-- SECTION 13: SUBSTANCES & MEDICATIONS (Causes 65-69)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('ALCOHOL_CONSUMPTION', 'SINGLE', 1, FALSE, '{RAPID,COMPLETE}'),
    ('NICOTINE_USE', 'SINGLE', 2, FALSE, '{RAPID,COMPLETE}'),
    ('CAFFEINE_AMOUNT', 'SINGLE', 3, FALSE, '{RAPID,COMPLETE}'),
    ('CAFFEINE_TIMING', 'SINGLE', 4, FALSE, '{RAPID,COMPLETE}'),
    ('MEDICATIONS_SLEEP', 'SINGLE', 5, FALSE, '{COMPLETE}'),
    ('SUPPLEMENTS_EVENING', 'SINGLE', 6, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_SUBSTANCES';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'ALCOHOL_CONSUMPTION' THEN 'How often do you drink alcohol?'
        WHEN 'NICOTINE_USE' THEN 'Do you use nicotine products?'
        WHEN 'CAFFEINE_AMOUNT' THEN 'How much caffeine do you consume daily?'
        WHEN 'CAFFEINE_TIMING' THEN 'When do you have your last caffeinated drink?'
        WHEN 'MEDICATIONS_SLEEP' THEN 'Are you taking medications that might affect sleep?'
        WHEN 'SUPPLEMENTS_EVENING' THEN 'Do you take energizing supplements in the evening?'
    END,
    CASE q.code
        WHEN 'ALCOHOL_CONSUMPTION' THEN 'Alcohol fragments sleep'
        WHEN 'NICOTINE_USE' THEN 'Nicotine is a stimulant'
        WHEN 'CAFFEINE_AMOUNT' THEN 'High caffeine affects sleep'
        WHEN 'CAFFEINE_TIMING' THEN 'Caffeine has a 6-hour half-life'
        WHEN 'MEDICATIONS_SLEEP' THEN 'Many medications affect sleep'
        WHEN 'SUPPLEMENTS_EVENING' THEN 'B vitamins, CoQ10 can be stimulating'
    END
FROM quiz_questions q JOIN quiz_sections s ON q.section_id = s.id WHERE s.code = 'SECTION_SUBSTANCES';

-- Substance answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('OCCASIONALLY', 2), ('WEEKLY', 3), ('DAILY', 4)) AS a(code, order_index)
WHERE q.code = 'ALCOHOL_CONSUMPTION';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never or rarely' WHEN 'OCCASIONALLY' THEN 'Occasionally'
    WHEN 'WEEKLY' THEN 'Weekly' WHEN 'DAILY' THEN 'Daily'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ALCOHOL_CONSUMPTION';

INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NEVER', 1), ('FORMER', 2), ('OCCASIONALLY', 3), ('DAILY', 4)) AS a(code, order_index)
WHERE q.code = 'NICOTINE_USE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NEVER' THEN 'Never' WHEN 'FORMER' THEN 'Former user'
    WHEN 'OCCASIONALLY' THEN 'Occasionally' WHEN 'DAILY' THEN 'Daily'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'NICOTINE_USE';

INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NONE', 1), ('ONE_CUP', 2), ('TWO_THREE', 3), ('FOUR_PLUS', 4)) AS a(code, order_index)
WHERE q.code = 'CAFFEINE_AMOUNT';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NONE' THEN 'None' WHEN 'ONE_CUP' THEN '1 cup'
    WHEN 'TWO_THREE' THEN '2-3 cups' WHEN 'FOUR_PLUS' THEN '4+ cups'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'CAFFEINE_AMOUNT';

INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO_CAFFEINE', 1), ('MORNING', 2), ('BEFORE_2PM', 3), ('AFTERNOON', 4), ('EVENING', 5)) AS a(code, order_index)
WHERE q.code = 'CAFFEINE_TIMING';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO_CAFFEINE' THEN 'No caffeine' WHEN 'MORNING' THEN 'Morning only'
    WHEN 'BEFORE_2PM' THEN 'Before 2 PM' WHEN 'AFTERNOON' THEN 'Afternoon' WHEN 'EVENING' THEN 'Evening'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'CAFFEINE_TIMING';

INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NONE', 1), ('UNSURE', 2), ('YES_SOME', 3), ('YES_MANY', 4)) AS a(code, order_index)
WHERE q.code = 'MEDICATIONS_SLEEP';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NONE' THEN 'No medications' WHEN 'UNSURE' THEN 'Unsure of effects'
    WHEN 'YES_SOME' THEN 'Yes, some may affect' WHEN 'YES_MANY' THEN 'Yes, multiple'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'MEDICATIONS_SLEEP';

INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('OCCASIONALLY', 2), ('REGULARLY', 3)) AS a(code, order_index)
WHERE q.code = 'SUPPLEMENTS_EVENING';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN 'OCCASIONALLY' THEN 'Occasionally' WHEN 'REGULARLY' THEN 'Regularly'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'SUPPLEMENTS_EVENING';

-- =====================================================
-- SECTION 14: LIFE STAGES (Causes 70-78)
-- =====================================================
INSERT INTO quiz_questions (section_id, code, type, order_index, is_gate, modes)
SELECT s.id, q.code, q.type::question_type, q.order_index, q.is_gate, q.modes::quiz_mode[]
FROM quiz_sections s
CROSS JOIN (VALUES
    ('AGE_RELATED_SLEEP', 'SINGLE', 1, FALSE, '{COMPLETE}'),
    ('PREGNANCY_STATUS', 'SINGLE', 2, FALSE, '{COMPLETE}'),
    ('POSTPARTUM', 'SINGLE', 3, FALSE, '{COMPLETE}'),
    ('MENSTRUAL_CYCLE', 'SINGLE', 4, FALSE, '{COMPLETE}'),
    ('MENOPAUSE_SYMPTOMS', 'SINGLE', 5, FALSE, '{COMPLETE}'),
    ('ANDROPAUSE_SYMPTOMS', 'SINGLE', 6, FALSE, '{COMPLETE}')
) AS q(code, type, order_index, is_gate, modes)
WHERE s.code = 'SECTION_LIFE_STAGES';

INSERT INTO quiz_questions_i18n (question_id, locale, text, help_text)
SELECT q.id, 'en',
    CASE q.code
        WHEN 'AGE_RELATED_SLEEP' THEN 'Has your sleep changed with age?'
        WHEN 'PREGNANCY_STATUS' THEN 'Are you currently pregnant?'
        WHEN 'POSTPARTUM' THEN 'Are you in the postpartum period?'
        WHEN 'MENSTRUAL_CYCLE' THEN 'Does your cycle affect sleep?'
        WHEN 'MENOPAUSE_SYMPTOMS' THEN 'Do you have menopausal symptoms?'
        WHEN 'ANDROPAUSE_SYMPTOMS' THEN 'Do you have low testosterone symptoms?'
    END,
    CASE q.code
        WHEN 'AGE_RELATED_SLEEP' THEN 'Sleep changes with age'
        WHEN 'PREGNANCY_STATUS' THEN 'Pregnancy affects sleep'
        WHEN 'POSTPARTUM' THEN 'Hormones and baby care affect sleep'
        WHEN 'MENSTRUAL_CYCLE' THEN 'Hormonal fluctuations disrupt sleep'
        WHEN 'MENOPAUSE_SYMPTOMS' THEN 'Hot flashes disrupt sleep'
        WHEN 'ANDROPAUSE_SYMPTOMS' THEN 'Low testosterone affects sleep'
    END
FROM quiz_questions q JOIN quiz_sections s ON q.section_id = s.id WHERE s.code = 'SECTION_LIFE_STAGES';

-- Life stage answers
INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('SLIGHTLY', 2), ('MODERATELY', 3), ('SIGNIFICANTLY', 4)) AS a(code, order_index)
WHERE q.code = 'AGE_RELATED_SLEEP';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No change' WHEN 'SLIGHTLY' THEN 'Slightly'
    WHEN 'MODERATELY' THEN 'Moderately' WHEN 'SIGNIFICANTLY' THEN 'Significantly'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'AGE_RELATED_SLEEP';

INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('FIRST_TRIMESTER', 2), ('SECOND_TRIMESTER', 3), ('THIRD_TRIMESTER', 4)) AS a(code, order_index)
WHERE q.code = 'PREGNANCY_STATUS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'Not pregnant' WHEN 'FIRST_TRIMESTER' THEN '1st trimester'
    WHEN 'SECOND_TRIMESTER' THEN '2nd trimester' WHEN 'THIRD_TRIMESTER' THEN '3rd trimester'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'PREGNANCY_STATUS';

INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('0_3_MONTHS', 2), ('3_6_MONTHS', 3), ('6_12_MONTHS', 4)) AS a(code, order_index)
WHERE q.code = 'POSTPARTUM';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No' WHEN '0_3_MONTHS' THEN '0-3 months'
    WHEN '3_6_MONTHS' THEN '3-6 months' WHEN '6_12_MONTHS' THEN '6-12 months'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'POSTPARTUM';

INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NO', 1), ('SLIGHTLY', 2), ('MODERATELY', 3), ('SIGNIFICANTLY', 4)) AS a(code, order_index)
WHERE q.code = 'MENSTRUAL_CYCLE';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NO' THEN 'No effect' WHEN 'SLIGHTLY' THEN 'Slightly'
    WHEN 'MODERATELY' THEN 'Moderately' WHEN 'SIGNIFICANTLY' THEN 'Significantly'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'MENSTRUAL_CYCLE';

INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NOT_APPLICABLE', 1), ('NO', 2), ('MILD', 3), ('MODERATE', 4), ('SEVERE', 5)) AS a(code, order_index)
WHERE q.code = 'MENOPAUSE_SYMPTOMS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NOT_APPLICABLE' THEN 'N/A' WHEN 'NO' THEN 'No'
    WHEN 'MILD' THEN 'Mild' WHEN 'MODERATE' THEN 'Moderate' WHEN 'SEVERE' THEN 'Severe'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'MENOPAUSE_SYMPTOMS';

INSERT INTO quiz_answers (question_id, code, order_index, is_exclusive)
SELECT q.id, a.code, a.order_index, FALSE FROM quiz_questions q
CROSS JOIN (VALUES ('NOT_APPLICABLE', 1), ('NO', 2), ('MILD', 3), ('MODERATE', 4), ('SEVERE', 5)) AS a(code, order_index)
WHERE q.code = 'ANDROPAUSE_SYMPTOMS';

INSERT INTO quiz_answers_i18n (answer_id, locale, text)
SELECT a.id, 'en', CASE a.code
    WHEN 'NOT_APPLICABLE' THEN 'N/A' WHEN 'NO' THEN 'No'
    WHEN 'MILD' THEN 'Mild' WHEN 'MODERATE' THEN 'Moderate' WHEN 'SEVERE' THEN 'Severe'
END FROM quiz_answers a JOIN quiz_questions q ON a.question_id = q.id WHERE q.code = 'ANDROPAUSE_SYMPTOMS';

-- =====================================================
-- MEDICAL FLAG RULES
-- =====================================================
INSERT INTO medical_flag_rules (code, severity, condition, requires_professional) VALUES
('SLEEP_APNEA_URGENT', 'URGENT', '{"type":"COMBINATION","operator":"AND","conditions":[{"type":"SINGLE","questionCode":"SNORING_SEVERITY","answerCode":"WITH_PAUSES"},{"type":"SINGLE","questionCode":"BREATHING_PAUSES","answerCode":"FREQUENTLY"}]}'::jsonb, TRUE),
('SLEEP_APNEA_LIKELY', 'IMPORTANT', '{"type":"COMBINATION","operator":"AND","conditions":[{"type":"MULTI","questionCode":"SNORING_SEVERITY","answerCodes":["LOUD","WITH_PAUSES"]},{"type":"MULTI","questionCode":"HEADACHES_MORNING","answerCodes":["FREQUENTLY","DAILY"]}]}'::jsonb, TRUE),
('DEPRESSION_URGENT', 'URGENT', '{"type":"COMBINATION","operator":"AND","conditions":[{"type":"SINGLE","questionCode":"DEPRESSION_SYMPTOMS","answerCode":"PERSISTENTLY"},{"type":"SINGLE","questionCode":"ENERGY_LEVELS","answerCode":"VERY_LOW"}]}'::jsonb, TRUE),
('PTSD_INDICATOR', 'IMPORTANT', '{"type":"COMBINATION","operator":"AND","conditions":[{"type":"SINGLE","questionCode":"TRAUMA_HISTORY","answerCode":"YES_SIGNIFICANT"},{"type":"MULTI","questionCode":"NIGHTMARES","answerCodes":["WEEKLY","FREQUENTLY"]}]}'::jsonb, TRUE),
('SEVERE_ANXIETY', 'IMPORTANT', '{"type":"COMBINATION","operator":"AND","conditions":[{"type":"SINGLE","questionCode":"ANXIETY_LEVEL","answerCode":"CONSTANTLY"},{"type":"MULTI","questionCode":"PANIC_ATTACKS","answerCodes":["SOMETIMES","FREQUENTLY"]}]}'::jsonb, TRUE),
('CHRONIC_PAIN_SEVERE', 'MODERATE', '{"type":"SINGLE","questionCode":"CHRONIC_PAIN","answerCode":"SEVERE"}'::jsonb, TRUE),
('RLS_LIKELY', 'MODERATE', '{"type":"SINGLE","questionCode":"RESTLESS_LEGS_SYNDROME","answerCode":"EVERY_NIGHT"}'::jsonb, TRUE),
('CAFFEINE_OVERUSE', 'INFO', '{"type":"COMBINATION","operator":"OR","conditions":[{"type":"SINGLE","questionCode":"CAFFEINE_AMOUNT","answerCode":"FOUR_PLUS"},{"type":"SINGLE","questionCode":"CAFFEINE_TIMING","answerCode":"EVENING"}]}'::jsonb, FALSE);

INSERT INTO medical_flag_rules_i18n (rule_id, locale, title, description, recommendation)
SELECT id, 'en',
    CASE code
        WHEN 'SLEEP_APNEA_URGENT' THEN 'Possible Sleep Apnea - Urgent'
        WHEN 'SLEEP_APNEA_LIKELY' THEN 'Possible Sleep Apnea'
        WHEN 'DEPRESSION_URGENT' THEN 'Possible Depression'
        WHEN 'PTSD_INDICATOR' THEN 'Trauma-Related Sleep Issues'
        WHEN 'SEVERE_ANXIETY' THEN 'Severe Anxiety'
        WHEN 'CHRONIC_PAIN_SEVERE' THEN 'Chronic Pain Affecting Sleep'
        WHEN 'RLS_LIKELY' THEN 'Possible Restless Legs Syndrome'
        WHEN 'CAFFEINE_OVERUSE' THEN 'Caffeine May Be Affecting Sleep'
    END,
    CASE code
        WHEN 'SLEEP_APNEA_URGENT' THEN 'Your responses strongly indicate sleep apnea with breathing stops during sleep.'
        WHEN 'SLEEP_APNEA_LIKELY' THEN 'Your responses suggest possible sleep apnea based on snoring and symptoms.'
        WHEN 'DEPRESSION_URGENT' THEN 'Your responses suggest depression, which significantly impacts sleep.'
        WHEN 'PTSD_INDICATOR' THEN 'Trauma may be affecting your sleep based on your symptoms.'
        WHEN 'SEVERE_ANXIETY' THEN 'High anxiety levels are significantly impacting your sleep.'
        WHEN 'CHRONIC_PAIN_SEVERE' THEN 'Severe chronic pain is disrupting your sleep quality.'
        WHEN 'RLS_LIKELY' THEN 'Your symptoms suggest Restless Legs Syndrome.'
        WHEN 'CAFFEINE_OVERUSE' THEN 'Your caffeine consumption may be contributing to sleep difficulties.'
    END,
    CASE code
        WHEN 'SLEEP_APNEA_URGENT' THEN 'Please consult a sleep specialist urgently for a sleep study.'
        WHEN 'SLEEP_APNEA_LIKELY' THEN 'We recommend consulting a sleep specialist for evaluation.'
        WHEN 'DEPRESSION_URGENT' THEN 'Please speak with a mental health professional. Help is available.'
        WHEN 'PTSD_INDICATOR' THEN 'Consider consulting a trauma-informed therapist.'
        WHEN 'SEVERE_ANXIETY' THEN 'We recommend consulting a mental health professional.'
        WHEN 'CHRONIC_PAIN_SEVERE' THEN 'Discuss pain management options with your healthcare provider.'
        WHEN 'RLS_LIKELY' THEN 'A healthcare provider can diagnose RLS and recommend treatments.'
        WHEN 'CAFFEINE_OVERUSE' THEN 'Try limiting caffeine to 2-3 cups before noon.'
    END
FROM medical_flag_rules;

-- =====================================================
-- EMAIL TEMPLATES
-- =====================================================
INSERT INTO email_templates (code, sequence_order, delay_days) VALUES
('WELCOME', 1, 0),
('DAY_3_TIPS', 2, 3),
('DAY_7_CHECKIN', 3, 7),
('DAY_14_PROGRESS', 4, 14);

INSERT INTO email_templates_i18n (template_id, locale, subject, body_html, body_text)
SELECT id, 'en',
    CASE code
        WHEN 'WELCOME' THEN 'Your Sleep Assessment Results'
        WHEN 'DAY_3_TIPS' THEN 'Sleep Tips Based on Your Assessment'
        WHEN 'DAY_7_CHECKIN' THEN 'How is Your Sleep This Week?'
        WHEN 'DAY_14_PROGRESS' THEN 'Your 2-Week Sleep Progress Check'
    END,
    CASE code
        WHEN 'WELCOME' THEN '<h1>Your Sleep Assessment Results</h1><p>Thank you for completing the Sleep Detective assessment!</p>'
        WHEN 'DAY_3_TIPS' THEN '<h1>Quick Sleep Tips</h1><p>Based on your assessment, here are some tips.</p>'
        WHEN 'DAY_7_CHECKIN' THEN '<h1>One Week Check-In</h1><p>How are you sleeping?</p>'
        WHEN 'DAY_14_PROGRESS' THEN '<h1>Two Week Progress</h1><p>Let us check on your sleep progress.</p>'
    END,
    CASE code
        WHEN 'WELCOME' THEN 'Your Sleep Assessment Results - Thank you!'
        WHEN 'DAY_3_TIPS' THEN 'Quick Sleep Tips based on your assessment'
        WHEN 'DAY_7_CHECKIN' THEN 'One Week Check-In - How are you sleeping?'
        WHEN 'DAY_14_PROGRESS' THEN 'Two Week Progress Check'
    END
FROM email_templates;
