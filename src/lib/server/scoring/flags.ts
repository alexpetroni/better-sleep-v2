import type { ResponseMap, MedicalFlagRule, MedicalFlag } from './types';
import type { FlagSeverity } from '$lib/types/database';
import { evaluateFlagCondition, calculateConfidence } from './evaluator';

/**
 * Medical flags generator
 */
export class MedicalFlagsGenerator {
	private rules: MedicalFlagRule[];
	private translations: Map<string, FlagTranslation>;

	constructor(rules: MedicalFlagRule[], translations: FlagTranslation[]) {
		this.rules = rules;
		this.translations = new Map(translations.map((t) => [t.code, t]));
	}

	/**
	 * Generate medical flags from responses
	 */
	generate(responses: ResponseMap, locale = 'en'): MedicalFlag[] {
		const flags: MedicalFlag[] = [];

		for (const rule of this.rules) {
			if (evaluateFlagCondition(rule.condition, responses)) {
				const confidence = calculateConfidence(rule.condition, responses);
				const translation = this.translations.get(`${rule.code}_${locale}`) ||
					this.translations.get(`${rule.code}_en`);

				if (translation) {
					flags.push({
						code: rule.code,
						severity: rule.severity,
						title: translation.title,
						description: translation.description,
						recommendation: translation.recommendation,
						requiresProfessional: rule.requiresProfessional,
						confidence
					});
				}
			}
		}

		// Sort by severity and confidence
		return flags.sort((a, b) => {
			const severityOrder: Record<FlagSeverity, number> = {
				URGENT: 0,
				IMPORTANT: 1,
				MODERATE: 2,
				INFO: 3
			};
			const severityDiff = severityOrder[a.severity] - severityOrder[b.severity];
			if (severityDiff !== 0) return severityDiff;
			return b.confidence - a.confidence;
		});
	}

	/**
	 * Check if any urgent flags are present
	 */
	hasUrgentFlags(responses: ResponseMap): boolean {
		return this.rules
			.filter((rule) => rule.severity === 'URGENT')
			.some((rule) => evaluateFlagCondition(rule.condition, responses));
	}

	/**
	 * Check if professional consultation is recommended
	 */
	requiresProfessional(responses: ResponseMap): boolean {
		return this.rules
			.filter((rule) => rule.requiresProfessional)
			.some((rule) => evaluateFlagCondition(rule.condition, responses));
	}
}

export interface FlagTranslation {
	code: string;
	locale: string;
	title: string;
	description: string;
	recommendation: string;
}

/**
 * Default medical flag rules
 * Updated to match question codes from 78 Sleep Causes Quiz
 */
export const defaultFlagRules: MedicalFlagRule[] = [
	// Sleep Apnea - Urgent (snoring with breathing pauses)
	{
		id: 'flag_apnea_urgent',
		code: 'SLEEP_APNEA_URGENT',
		severity: 'URGENT',
		requiresProfessional: true,
		condition: {
			type: 'COMBINATION',
			operator: 'AND',
			conditions: [
				{ type: 'SINGLE', questionCode: 'SNORING_SEVERITY', answerCode: 'WITH_PAUSES' },
				{ type: 'SINGLE', questionCode: 'BREATHING_PAUSES', answerCode: 'FREQUENTLY' }
			]
		}
	},

	// Sleep Apnea - Likely (loud snoring + morning headaches)
	{
		id: 'flag_apnea_likely',
		code: 'SLEEP_APNEA_LIKELY',
		severity: 'IMPORTANT',
		requiresProfessional: true,
		condition: {
			type: 'COMBINATION',
			operator: 'AND',
			conditions: [
				{
					type: 'MULTI',
					questionCode: 'SNORING_SEVERITY',
					answerCodes: ['LOUD', 'WITH_PAUSES']
				},
				{
					type: 'MULTI',
					questionCode: 'HEADACHES_MORNING',
					answerCodes: ['FREQUENTLY', 'DAILY']
				}
			]
		}
	},

	// Depression - Urgent
	{
		id: 'flag_depression_urgent',
		code: 'DEPRESSION_URGENT',
		severity: 'URGENT',
		requiresProfessional: true,
		condition: {
			type: 'COMBINATION',
			operator: 'AND',
			conditions: [
				{ type: 'SINGLE', questionCode: 'DEPRESSION_SYMPTOMS', answerCode: 'PERSISTENTLY' },
				{ type: 'SINGLE', questionCode: 'ENERGY_LEVELS', answerCode: 'VERY_LOW' }
			]
		}
	},

	// PTSD / Trauma indicator
	{
		id: 'flag_ptsd',
		code: 'PTSD_INDICATOR',
		severity: 'IMPORTANT',
		requiresProfessional: true,
		condition: {
			type: 'COMBINATION',
			operator: 'AND',
			conditions: [
				{ type: 'SINGLE', questionCode: 'TRAUMA_HISTORY', answerCode: 'YES_SIGNIFICANT' },
				{
					type: 'MULTI',
					questionCode: 'NIGHTMARES',
					answerCodes: ['WEEKLY', 'FREQUENTLY']
				}
			]
		}
	},

	// Severe Anxiety
	{
		id: 'flag_anxiety_severe',
		code: 'SEVERE_ANXIETY',
		severity: 'IMPORTANT',
		requiresProfessional: true,
		condition: {
			type: 'COMBINATION',
			operator: 'AND',
			conditions: [
				{ type: 'SINGLE', questionCode: 'ANXIETY_LEVEL', answerCode: 'CONSTANTLY' },
				{
					type: 'MULTI',
					questionCode: 'PANIC_ATTACKS',
					answerCodes: ['SOMETIMES', 'FREQUENTLY']
				}
			]
		}
	},

	// Chronic Pain - Severe
	{
		id: 'flag_chronic_pain',
		code: 'CHRONIC_PAIN_SEVERE',
		severity: 'MODERATE',
		requiresProfessional: true,
		condition: {
			type: 'SINGLE',
			questionCode: 'CHRONIC_PAIN',
			answerCode: 'SEVERE'
		}
	},

	// Restless Legs Syndrome
	{
		id: 'flag_rls',
		code: 'RLS_LIKELY',
		severity: 'MODERATE',
		requiresProfessional: true,
		condition: {
			type: 'SINGLE',
			questionCode: 'RESTLESS_LEGS_SYNDROME',
			answerCode: 'EVERY_NIGHT'
		}
	},

	// Caffeine overuse
	{
		id: 'flag_caffeine',
		code: 'CAFFEINE_OVERUSE',
		severity: 'INFO',
		requiresProfessional: false,
		condition: {
			type: 'COMBINATION',
			operator: 'OR',
			conditions: [
				{ type: 'SINGLE', questionCode: 'CAFFEINE_AMOUNT', answerCode: 'FOUR_PLUS' },
				{ type: 'SINGLE', questionCode: 'CAFFEINE_TIMING', answerCode: 'EVENING' }
			]
		}
	},

	// Circadian rhythm disorder - shift work
	{
		id: 'flag_circadian',
		code: 'CIRCADIAN_DISORDER',
		severity: 'MODERATE',
		requiresProfessional: true,
		condition: {
			type: 'COMBINATION',
			operator: 'AND',
			conditions: [
				{
					type: 'MULTI',
					questionCode: 'WORK_SCHEDULE',
					answerCodes: ['NIGHT_SHIFT', 'ROTATING']
				},
				{ type: 'SINGLE', questionCode: 'SCHEDULE_CONSISTENCY', answerCode: 'VERY_INCONSISTENT' }
			]
		}
	},

	// Medication dependency
	{
		id: 'flag_medication_dependency',
		code: 'MEDICATION_DEPENDENCY',
		severity: 'MODERATE',
		requiresProfessional: true,
		condition: {
			type: 'COMBINATION',
			operator: 'AND',
			conditions: [
				{
					type: 'MULTI',
					questionCode: 'SLEEP_MEDICATIONS',
					answerCodes: ['PRESCRIPTION', 'BENZODIAZEPINES']
				},
				{ type: 'SINGLE', questionCode: 'MEDICATION_DURATION', answerCode: 'MONTHS_PLUS' }
			]
		}
	}
];

/**
 * Default flag translations
 * Updated to match new flag codes from 78 Sleep Causes Quiz
 */
export const defaultFlagTranslations: FlagTranslation[] = [
	// Sleep Apnea - Urgent
	{
		code: 'SLEEP_APNEA_URGENT_en',
		locale: 'en',
		title: 'Possible Sleep Apnea - Urgent',
		description:
			'Your responses strongly indicate sleep apnea with breathing stops during sleep.',
		recommendation:
			'Please consult a sleep specialist urgently for a sleep study.'
	},
	{
		code: 'SLEEP_APNEA_URGENT_ro',
		locale: 'ro',
		title: 'Posibilă Apnee de Somn - Urgent',
		description:
			'Răspunsurile dumneavoastră indică puternic apnee de somn cu opriri ale respirației în timpul somnului.',
		recommendation:
			'Vă rugăm să consultați urgent un specialist în tulburări de somn pentru o polisomnografie.'
	},

	// Sleep Apnea - Likely
	{
		code: 'SLEEP_APNEA_LIKELY_en',
		locale: 'en',
		title: 'Possible Sleep Apnea',
		description:
			'Your responses suggest possible sleep apnea based on snoring and symptoms.',
		recommendation:
			'We recommend consulting a sleep specialist for evaluation.'
	},
	{
		code: 'SLEEP_APNEA_LIKELY_ro',
		locale: 'ro',
		title: 'Posibilă Apnee de Somn',
		description:
			'Răspunsurile dumneavoastră sugerează posibilă apnee de somn pe baza sforăitului și simptomelor.',
		recommendation:
			'Vă recomandăm să consultați un specialist în tulburări de somn pentru evaluare.'
	},

	// Depression - Urgent
	{
		code: 'DEPRESSION_URGENT_en',
		locale: 'en',
		title: 'Possible Depression',
		description:
			'Your responses suggest depression, which significantly impacts sleep.',
		recommendation:
			'Please speak with a mental health professional. Help is available.'
	},
	{
		code: 'DEPRESSION_URGENT_ro',
		locale: 'ro',
		title: 'Posibilă Depresie',
		description:
			'Răspunsurile dumneavoastră sugerează depresie, care afectează semnificativ somnul.',
		recommendation:
			'Vă rugăm să discutați cu un specialist în sănătate mintală. Ajutorul este disponibil.'
	},

	// PTSD / Trauma
	{
		code: 'PTSD_INDICATOR_en',
		locale: 'en',
		title: 'Trauma-Related Sleep Issues',
		description:
			'Trauma may be affecting your sleep based on your symptoms.',
		recommendation:
			'Consider consulting a trauma-informed therapist.'
	},
	{
		code: 'PTSD_INDICATOR_ro',
		locale: 'ro',
		title: 'Probleme de Somn Legate de Traumă',
		description:
			'Trauma poate afecta somnul dumneavoastră pe baza simptomelor.',
		recommendation:
			'Luați în considerare consultarea unui terapeut specializat în traumă.'
	},

	// Severe Anxiety
	{
		code: 'SEVERE_ANXIETY_en',
		locale: 'en',
		title: 'Severe Anxiety',
		description:
			'High anxiety levels are significantly impacting your sleep.',
		recommendation:
			'We recommend consulting a mental health professional.'
	},
	{
		code: 'SEVERE_ANXIETY_ro',
		locale: 'ro',
		title: 'Anxietate Severă',
		description:
			'Nivelurile ridicate de anxietate vă afectează semnificativ somnul.',
		recommendation:
			'Vă recomandăm să consultați un specialist în sănătate mintală.'
	},

	// Chronic Pain
	{
		code: 'CHRONIC_PAIN_SEVERE_en',
		locale: 'en',
		title: 'Chronic Pain Affecting Sleep',
		description:
			'Severe chronic pain is disrupting your sleep quality.',
		recommendation:
			'Discuss pain management options with your healthcare provider.'
	},
	{
		code: 'CHRONIC_PAIN_SEVERE_ro',
		locale: 'ro',
		title: 'Durere Cronică ce Afectează Somnul',
		description:
			'Durerea cronică severă vă perturbă calitatea somnului.',
		recommendation:
			'Discutați opțiunile de management al durerii cu medicul dumneavoastră.'
	},

	// Restless Legs Syndrome
	{
		code: 'RLS_LIKELY_en',
		locale: 'en',
		title: 'Possible Restless Legs Syndrome',
		description:
			'Your symptoms suggest Restless Legs Syndrome.',
		recommendation:
			'A healthcare provider can diagnose RLS and recommend treatments.'
	},
	{
		code: 'RLS_LIKELY_ro',
		locale: 'ro',
		title: 'Posibil Sindrom al Picioarelor Neliniștite',
		description:
			'Simptomele dumneavoastră sugerează Sindromul Picioarelor Neliniștite.',
		recommendation:
			'Un medic poate diagnostica RLS și recomanda tratamente.'
	},

	// Caffeine Overuse
	{
		code: 'CAFFEINE_OVERUSE_en',
		locale: 'en',
		title: 'Caffeine May Be Affecting Sleep',
		description:
			'Your caffeine consumption may be contributing to sleep difficulties.',
		recommendation:
			'Try limiting caffeine to 2-3 cups before noon.'
	},
	{
		code: 'CAFFEINE_OVERUSE_ro',
		locale: 'ro',
		title: 'Cafeina Poate Afecta Somnul',
		description:
			'Consumul dumneavoastră de cofeină poate contribui la dificultățile de somn.',
		recommendation:
			'Încercați să limitați cafeina la 2-3 căni înainte de prânz.'
	},

	// Circadian Disorder
	{
		code: 'CIRCADIAN_DISORDER_en',
		locale: 'en',
		title: 'Circadian Rhythm Disruption',
		description:
			'Shift work and irregular sleep schedules are disrupting your natural circadian rhythm.',
		recommendation:
			'Consider strategies like light therapy and maintaining consistent sleep times when possible.'
	},
	{
		code: 'CIRCADIAN_DISORDER_ro',
		locale: 'ro',
		title: 'Perturbarea Ritmului Circadian',
		description:
			'Munca în schimburi și programul de somn neregulat vă perturbă ritmul circadian natural.',
		recommendation:
			'Luați în considerare strategii precum terapia cu lumină și menținerea unor ore de somn constante.'
	},

	// Medication Dependency
	{
		code: 'MEDICATION_DEPENDENCY_en',
		locale: 'en',
		title: 'Sleep Medication Concern',
		description:
			'Long-term use of sleep medications can lead to dependency.',
		recommendation:
			'Discuss with your healthcare provider about gradually reducing sleep medication use.'
	},
	{
		code: 'MEDICATION_DEPENDENCY_ro',
		locale: 'ro',
		title: 'Îngrijorare privind Medicamentele pentru Somn',
		description:
			'Utilizarea pe termen lung a medicamentelor pentru somn poate duce la dependență.',
		recommendation:
			'Discutați cu medicul dumneavoastră despre reducerea treptată a utilizării medicamentelor pentru somn.'
	}
];
