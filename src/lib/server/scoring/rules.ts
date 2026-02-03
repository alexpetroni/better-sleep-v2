import type { ScoringRule, RiskCategory } from './types';

/**
 * Risk categories with weights
 * Aligned with the 14 risk categories in the database
 */
export const riskCategories: RiskCategory[] = [
	{ code: 'R1_STRESS_PSYCH', name: 'Stress & Psychological', maxScore: 30, weight: 1.2 },
	{ code: 'R2_SLEEP_DISORDERS', name: 'Sleep Disorders', maxScore: 25, weight: 1.3 },
	{ code: 'R3_LIFESTYLE', name: 'Lifestyle Factors', maxScore: 25, weight: 1.0 },
	{ code: 'R4_ENVIRONMENT', name: 'Sleep Environment', maxScore: 20, weight: 0.9 },
	{ code: 'R5_HEALTH', name: 'Health Conditions', maxScore: 25, weight: 1.2 },
	{ code: 'R6_SUBSTANCES', name: 'Substances & Medications', maxScore: 20, weight: 1.1 },
	{ code: 'R7_CIRCADIAN', name: 'Circadian Rhythm', maxScore: 20, weight: 1.0 },
	{ code: 'R8_HORMONAL', name: 'Hormonal Factors', maxScore: 15, weight: 1.0 },
	{ code: 'R9_DIGESTIVE', name: 'Digestive Issues', maxScore: 15, weight: 0.8 },
	{ code: 'R10_RESPIRATORY', name: 'Respiratory Issues', maxScore: 20, weight: 1.1 },
	{ code: 'R11_PAIN', name: 'Pain & Discomfort', maxScore: 20, weight: 1.0 },
	{ code: 'R12_NEUROLOGICAL', name: 'Neurological', maxScore: 15, weight: 1.1 },
	{ code: 'R13_EXTERNAL', name: 'External Factors', maxScore: 15, weight: 0.7 },
	{ code: 'R14_SLEEP_HABITS', name: 'Sleep Habits', maxScore: 20, weight: 0.9 }
];

/**
 * Scoring rules mapped to risk categories
 * Based on the 78 sleep causes quiz structure
 */
export const scoringRules: ScoringRule[] = [
	// =====================================================
	// R1: STRESS & PSYCHOLOGICAL (Causes 30-37)
	// =====================================================
	{
		id: 'r1_anxiety_high',
		categoryCode: 'R1_STRESS_PSYCH',
		points: 5,
		condition: {
			type: 'SINGLE',
			questionCode: 'ANXIETY_LEVEL',
			answerCode: 'CONSTANTLY'
		}
	},
	{
		id: 'r1_anxiety_moderate',
		categoryCode: 'R1_STRESS_PSYCH',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'ANXIETY_LEVEL',
			answerCode: 'OFTEN'
		}
	},
	{
		id: 'r1_panic_attacks',
		categoryCode: 'R1_STRESS_PSYCH',
		points: 5,
		condition: {
			type: 'SINGLE',
			questionCode: 'PANIC_ATTACKS',
			answerCode: 'FREQUENTLY'
		}
	},
	{
		id: 'r1_trauma',
		categoryCode: 'R1_STRESS_PSYCH',
		points: 5,
		condition: {
			type: 'SINGLE',
			questionCode: 'TRAUMA_HISTORY',
			answerCode: 'YES_SIGNIFICANT'
		}
	},
	{
		id: 'r1_depression',
		categoryCode: 'R1_STRESS_PSYCH',
		points: 5,
		condition: {
			type: 'SINGLE',
			questionCode: 'DEPRESSION_SYMPTOMS',
			answerCode: 'PERSISTENTLY'
		}
	},
	{
		id: 'r1_racing_thoughts',
		categoryCode: 'R1_STRESS_PSYCH',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'RACING_THOUGHTS',
			answerCode: 'EVERY_NIGHT'
		}
	},
	{
		id: 'r1_sleep_anxiety',
		categoryCode: 'R1_STRESS_PSYCH',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'SLEEP_ANXIETY',
			answerCode: 'ALWAYS'
		}
	},
	{
		id: 'r1_evening_stress',
		categoryCode: 'R1_STRESS_PSYCH',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'EVENING_STRESS',
			answerCode: 'EVERY_NIGHT'
		}
	},

	// =====================================================
	// R2: SLEEP DISORDERS (Causes 6, 15-16, 22-29)
	// =====================================================
	{
		id: 'r2_snoring_with_pauses',
		categoryCode: 'R2_SLEEP_DISORDERS',
		points: 5,
		condition: {
			type: 'SINGLE',
			questionCode: 'SNORING_SEVERITY',
			answerCode: 'WITH_PAUSES'
		}
	},
	{
		id: 'r2_snoring_loud',
		categoryCode: 'R2_SLEEP_DISORDERS',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'SNORING_SEVERITY',
			answerCode: 'LOUD'
		}
	},
	{
		id: 'r2_breathing_pauses',
		categoryCode: 'R2_SLEEP_DISORDERS',
		points: 5,
		condition: {
			type: 'SINGLE',
			questionCode: 'BREATHING_PAUSES',
			answerCode: 'FREQUENTLY'
		}
	},
	{
		id: 'r2_restless_legs',
		categoryCode: 'R2_SLEEP_DISORDERS',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'RESTLESS_LEGS_SYNDROME',
			answerCode: 'EVERY_NIGHT'
		}
	},
	{
		id: 'r2_sleepwalking',
		categoryCode: 'R2_SLEEP_DISORDERS',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'SLEEPWALKING',
			answerCode: 'REGULARLY'
		}
	},
	{
		id: 'r2_night_terrors',
		categoryCode: 'R2_SLEEP_DISORDERS',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'NIGHT_TERRORS',
			answerCode: 'OFTEN'
		}
	},
	{
		id: 'r2_sleep_paralysis',
		categoryCode: 'R2_SLEEP_DISORDERS',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'SLEEP_PARALYSIS',
			answerCode: 'OFTEN'
		}
	},

	// =====================================================
	// R3: LIFESTYLE FACTORS
	// =====================================================
	{
		id: 'r3_blue_light_high',
		categoryCode: 'R3_LIFESTYLE',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'BLUE_LIGHT_EXPOSURE',
			answerCode: 'MORE_THAN_60'
		}
	},
	{
		id: 'r3_bed_association',
		categoryCode: 'R3_LIFESTYLE',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'BED_ASSOCIATION',
			answerCode: 'YES'
		}
	},
	{
		id: 'r3_clock_watching',
		categoryCode: 'R3_LIFESTYLE',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'CLOCK_WATCHING',
			answerCode: 'ALWAYS'
		}
	},

	// =====================================================
	// R4: SLEEP ENVIRONMENT (Causes 46-52)
	// =====================================================
	{
		id: 'r4_room_too_hot',
		categoryCode: 'R4_ENVIRONMENT',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'ROOM_TEMPERATURE',
			answerCode: 'TOO_HOT'
		}
	},
	{
		id: 'r4_room_too_cold',
		categoryCode: 'R4_ENVIRONMENT',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'ROOM_TEMPERATURE',
			answerCode: 'TOO_COLD'
		}
	},
	{
		id: 'r4_light_exposure',
		categoryCode: 'R4_ENVIRONMENT',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'ROOM_DARKNESS',
			answerCode: 'BRIGHT'
		}
	},
	{
		id: 'r4_noise',
		categoryCode: 'R4_ENVIRONMENT',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'NOISE_LEVEL',
			answerCode: 'NOISY'
		}
	},
	{
		id: 'r4_air_quality',
		categoryCode: 'R4_ENVIRONMENT',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'AIR_QUALITY',
			answerCode: 'POOR'
		}
	},
	{
		id: 'r4_allergens',
		categoryCode: 'R4_ENVIRONMENT',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'ALLERGENS',
			answerCode: 'YES_MANY'
		}
	},
	{
		id: 'r4_mattress',
		categoryCode: 'R4_ENVIRONMENT',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'MATTRESS_COMFORT',
			answerCode: 'UNCOMFORTABLE'
		}
	},
	{
		id: 'r4_pillow',
		categoryCode: 'R4_ENVIRONMENT',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'PILLOW_COMFORT',
			answerCode: 'UNCOMFORTABLE'
		}
	},
	{
		id: 'r4_blanket_hot',
		categoryCode: 'R4_ENVIRONMENT',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'BLANKET_TEMP',
			answerCode: 'TOO_HOT'
		}
	},
	{
		id: 'r4_blanket_cold',
		categoryCode: 'R4_ENVIRONMENT',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'BLANKET_TEMP',
			answerCode: 'TOO_COLD'
		}
	},
	{
		id: 'r4_blanket_varies',
		categoryCode: 'R4_ENVIRONMENT',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'BLANKET_TEMP',
			answerCode: 'VARIES'
		}
	},

	// =====================================================
	// R5: HEALTH CONDITIONS (Causes 6-21)
	// =====================================================
	{
		id: 'r5_chronic_pain',
		categoryCode: 'R5_HEALTH',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'CHRONIC_PAIN',
			answerCode: 'SEVERE'
		}
	},
	{
		id: 'r5_chronic_pain_moderate',
		categoryCode: 'R5_HEALTH',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'CHRONIC_PAIN',
			answerCode: 'MODERATE'
		}
	},
	{
		id: 'r5_thyroid_hyper',
		categoryCode: 'R5_HEALTH',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'THYROID_ISSUES',
			answerCode: 'HYPER'
		}
	},
	{
		id: 'r5_thyroid_hypo',
		categoryCode: 'R5_HEALTH',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'THYROID_ISSUES',
			answerCode: 'HYPO'
		}
	},
	{
		id: 'r5_blood_pressure',
		categoryCode: 'R5_HEALTH',
		points: 3,
		condition: {
			type: 'MULTI',
			questionCode: 'BLOOD_PRESSURE',
			answerCodes: ['HIGH', 'LOW'],
			matchType: 'ANY'
		}
	},
	{
		id: 'r5_nocturia_high',
		categoryCode: 'R5_HEALTH',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'NOCTURIA',
			answerCode: 'THREE_PLUS'
		}
	},
	{
		id: 'r5_nocturia_moderate',
		categoryCode: 'R5_HEALTH',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'NOCTURIA',
			answerCode: 'TWICE'
		}
	},
	{
		id: 'r5_leg_cramps',
		categoryCode: 'R5_HEALTH',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'LEG_CRAMPS',
			answerCode: 'NIGHTLY'
		}
	},

	// =====================================================
	// R6: SUBSTANCES & MEDICATIONS (Causes 65-69)
	// =====================================================
	{
		id: 'r6_caffeine_high',
		categoryCode: 'R6_SUBSTANCES',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'CAFFEINE_AMOUNT',
			answerCode: 'FOUR_PLUS'
		}
	},
	{
		id: 'r6_caffeine_late',
		categoryCode: 'R6_SUBSTANCES',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'CAFFEINE_TIMING',
			answerCode: 'EVENING'
		}
	},
	{
		id: 'r6_caffeine_afternoon',
		categoryCode: 'R6_SUBSTANCES',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'CAFFEINE_TIMING',
			answerCode: 'AFTERNOON'
		}
	},
	{
		id: 'r6_alcohol_daily',
		categoryCode: 'R6_SUBSTANCES',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'ALCOHOL_CONSUMPTION',
			answerCode: 'DAILY'
		}
	},
	{
		id: 'r6_alcohol_weekly',
		categoryCode: 'R6_SUBSTANCES',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'ALCOHOL_CONSUMPTION',
			answerCode: 'WEEKLY'
		}
	},
	{
		id: 'r6_nicotine',
		categoryCode: 'R6_SUBSTANCES',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'NICOTINE_USE',
			answerCode: 'DAILY'
		}
	},
	{
		id: 'r6_medications',
		categoryCode: 'R6_SUBSTANCES',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'MEDICATIONS_SLEEP',
			answerCode: 'YES_MANY'
		}
	},
	{
		id: 'r6_supplements',
		categoryCode: 'R6_SUBSTANCES',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'SUPPLEMENTS_EVENING',
			answerCode: 'REGULARLY'
		}
	},

	// =====================================================
	// R7: CIRCADIAN RHYTHM (Causes 43-45)
	// =====================================================
	{
		id: 'r7_shift_work_rotating',
		categoryCode: 'R7_CIRCADIAN',
		points: 5,
		condition: {
			type: 'SINGLE',
			questionCode: 'SHIFT_WORK',
			answerCode: 'ROTATING'
		}
	},
	{
		id: 'r7_shift_work_night',
		categoryCode: 'R7_CIRCADIAN',
		points: 5,
		condition: {
			type: 'SINGLE',
			questionCode: 'SHIFT_WORK',
			answerCode: 'NIGHT_SHIFT'
		}
	},
	{
		id: 'r7_irregular_schedule',
		categoryCode: 'R7_CIRCADIAN',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'SLEEP_SCHEDULE',
			answerCode: 'VERY_IRREGULAR'
		}
	},
	{
		id: 'r7_weekend_difference',
		categoryCode: 'R7_CIRCADIAN',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'WEEKEND_DIFFERENCE',
			answerCode: '3_PLUS'
		}
	},
	{
		id: 'r7_no_morning_light',
		categoryCode: 'R7_CIRCADIAN',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'MORNING_LIGHT',
			answerCode: 'NEVER'
		}
	},

	// =====================================================
	// R8: HORMONAL FACTORS (Causes 1, 70-78)
	// =====================================================
	{
		id: 'r8_menopause_severe',
		categoryCode: 'R8_HORMONAL',
		points: 5,
		condition: {
			type: 'SINGLE',
			questionCode: 'MENOPAUSE_SYMPTOMS',
			answerCode: 'SEVERE'
		}
	},
	{
		id: 'r8_menopause_moderate',
		categoryCode: 'R8_HORMONAL',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'MENOPAUSE_SYMPTOMS',
			answerCode: 'MODERATE'
		}
	},
	{
		id: 'r8_andropause',
		categoryCode: 'R8_HORMONAL',
		points: 4,
		condition: {
			type: 'MULTI',
			questionCode: 'ANDROPAUSE_SYMPTOMS',
			answerCodes: ['MODERATE', 'SEVERE'],
			matchType: 'ANY'
		}
	},
	{
		id: 'r8_pregnancy',
		categoryCode: 'R8_HORMONAL',
		points: 3,
		condition: {
			type: 'MULTI',
			questionCode: 'PREGNANCY_STATUS',
			answerCodes: ['FIRST_TRIMESTER', 'SECOND_TRIMESTER', 'THIRD_TRIMESTER'],
			matchType: 'ANY'
		}
	},
	{
		id: 'r8_postpartum',
		categoryCode: 'R8_HORMONAL',
		points: 4,
		condition: {
			type: 'MULTI',
			questionCode: 'POSTPARTUM',
			answerCodes: ['0_3_MONTHS', '3_6_MONTHS'],
			matchType: 'ANY'
		}
	},
	{
		id: 'r8_menstrual',
		categoryCode: 'R8_HORMONAL',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'MENSTRUAL_CYCLE',
			answerCode: 'SIGNIFICANTLY'
		}
	},

	// =====================================================
	// R9: DIGESTIVE ISSUES (Causes 5, 41-42)
	// =====================================================
	{
		id: 'r9_acid_reflux_nightly',
		categoryCode: 'R9_DIGESTIVE',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'ACID_REFLUX',
			answerCode: 'NIGHTLY'
		}
	},
	{
		id: 'r9_acid_reflux_frequent',
		categoryCode: 'R9_DIGESTIVE',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'ACID_REFLUX',
			answerCode: 'FREQUENTLY'
		}
	},
	{
		id: 'r9_digestive_issues',
		categoryCode: 'R9_DIGESTIVE',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'DIGESTIVE_ISSUES',
			answerCode: 'NIGHTLY'
		}
	},
	{
		id: 'r9_food_sensitivities',
		categoryCode: 'R9_DIGESTIVE',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'FOOD_SENSITIVITIES',
			answerCode: 'YES_MANY'
		}
	},
	{
		id: 'r9_blood_sugar',
		categoryCode: 'R9_DIGESTIVE',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'BLOOD_SUGAR_SYMPTOMS',
			answerCode: 'MOST_NIGHTS'
		}
	},

	// =====================================================
	// R10: RESPIRATORY ISSUES (Causes 6, 13-14)
	// =====================================================
	{
		id: 'r10_nasal_chronic',
		categoryCode: 'R10_RESPIRATORY',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'NASAL_CONGESTION',
			answerCode: 'CHRONIC'
		}
	},
	{
		id: 'r10_nasal_often',
		categoryCode: 'R10_RESPIRATORY',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'NASAL_CONGESTION',
			answerCode: 'OFTEN'
		}
	},
	{
		id: 'r10_circulation',
		categoryCode: 'R10_RESPIRATORY',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'CIRCULATION_ISSUES',
			answerCode: 'EVERY_NIGHT'
		}
	},
	{
		id: 'r10_altitude',
		categoryCode: 'R10_RESPIRATORY',
		points: 3,
		condition: {
			type: 'MULTI',
			questionCode: 'ALTITUDE',
			answerCodes: ['HIGH', 'VERY_HIGH'],
			matchType: 'ANY'
		}
	},

	// =====================================================
	// R11: PAIN & DISCOMFORT (Causes 9, 17)
	// =====================================================
	{
		id: 'r11_morning_headaches',
		categoryCode: 'R11_PAIN',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'HEADACHES_MORNING',
			answerCode: 'DAILY'
		}
	},
	{
		id: 'r11_morning_headaches_freq',
		categoryCode: 'R11_PAIN',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'HEADACHES_MORNING',
			answerCode: 'FREQUENTLY'
		}
	},

	// =====================================================
	// R12: NEUROLOGICAL FACTORS (Causes 22-29)
	// =====================================================
	{
		id: 'r12_nightmares',
		categoryCode: 'R12_NEUROLOGICAL',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'NIGHTMARES',
			answerCode: 'FREQUENTLY'
		}
	},
	{
		id: 'r12_vivid_dreams',
		categoryCode: 'R12_NEUROLOGICAL',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'VIVID_DREAMS',
			answerCode: 'EVERY_NIGHT'
		}
	},
	{
		id: 'r12_hypnic_jerks',
		categoryCode: 'R12_NEUROLOGICAL',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'HYPNIC_JERKS',
			answerCode: 'NIGHTLY'
		}
	},
	{
		id: 'r12_tinnitus',
		categoryCode: 'R12_NEUROLOGICAL',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'TINNITUS',
			answerCode: 'CONSTANT'
		}
	},

	// =====================================================
	// R13: EXTERNAL FACTORS (Causes 62-64)
	// =====================================================
	{
		id: 'r13_partner_snoring',
		categoryCode: 'R13_EXTERNAL',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'PARTNER_SNORING',
			answerCode: 'OFTEN'
		}
	},
	{
		id: 'r13_partner_movement',
		categoryCode: 'R13_EXTERNAL',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'PARTNER_MOVEMENT',
			answerCode: 'OFTEN'
		}
	},
	{
		id: 'r13_pet',
		categoryCode: 'R13_EXTERNAL',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'PET_DISTURBANCE',
			answerCode: 'OFTEN'
		}
	},
	{
		id: 'r13_childcare',
		categoryCode: 'R13_EXTERNAL',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'CHILDCARE_DISRUPTION',
			answerCode: 'FREQUENTLY'
		}
	},
	{
		id: 'r13_caregiver',
		categoryCode: 'R13_EXTERNAL',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'CAREGIVER_DUTIES',
			answerCode: 'NIGHTLY'
		}
	},

	// =====================================================
	// R14: SLEEP HABITS (Causes 36, 38-40)
	// =====================================================
	{
		id: 'r14_hypervigilance',
		categoryCode: 'R14_SLEEP_HABITS',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'HYPERVIGILANCE',
			answerCode: 'CONSTANTLY'
		}
	},
	{
		id: 'r14_light_sleeper',
		categoryCode: 'R14_SLEEP_HABITS',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'LIGHT_SLEEPER',
			answerCode: 'VERY_LIGHT'
		}
	},
	{
		id: 'r14_readormire',
		categoryCode: 'R14_SLEEP_HABITS',
		points: 4,
		condition: {
			type: 'SINGLE',
			questionCode: 'READORMIRE_DIFFICULTY',
			answerCode: 'VERY_DIFFICULT'
		}
	},
	{
		id: 'r14_anticipatory',
		categoryCode: 'R14_SLEEP_HABITS',
		points: 3,
		condition: {
			type: 'SINGLE',
			questionCode: 'ANTICIPATORY_WAKING',
			answerCode: 'REGULARLY'
		}
	},
	{
		id: 'r14_emotional_processing',
		categoryCode: 'R14_SLEEP_HABITS',
		points: 2,
		condition: {
			type: 'SINGLE',
			questionCode: 'EMOTIONAL_PROCESSING',
			answerCode: 'EVERY_NIGHT'
		}
	}
];

export { ScoreCalculator } from './calculator';
