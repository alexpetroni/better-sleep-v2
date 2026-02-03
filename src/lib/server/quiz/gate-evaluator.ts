import type { GateRule, QuizResponse, GateCondition, CompositeCondition } from '$lib/types/quiz';

/**
 * Evaluates gate rules to determine which sections/questions to skip
 */
export class GateEvaluator {
	private rules: GateRule[];

	constructor(rules: GateRule[]) {
		this.rules = rules;
	}

	/**
	 * Evaluate all gate rules and return sections/questions to skip
	 */
	evaluate(responses: QuizResponse[]): {
		skipSections: Set<string>;
		skipQuestions: Set<string>;
	} {
		const skipSections = new Set<string>();
		const skipQuestions = new Set<string>();

		// Build response map: questionCode -> answerCodes
		const responseMap = new Map<string, string[]>();
		for (const response of responses) {
			responseMap.set(response.questionCode, response.answerCodes);
		}

		// Evaluate each gate rule
		for (const rule of this.rules) {
			if (this.evaluateCondition(rule.condition, responseMap)) {
				for (const section of rule.skipsSections) {
					skipSections.add(section);
				}
				for (const question of rule.skipsQuestions) {
					skipQuestions.add(question);
				}
			}
		}

		return { skipSections, skipQuestions };
	}

	/**
	 * Check if a specific response triggers any gate
	 */
	checkResponseTriggers(
		questionCode: string,
		answerCodes: string[],
		existingResponses: QuizResponse[]
	): {
		skipSections: string[];
		skipQuestions: string[];
	} {
		// Build response map with new response
		const responseMap = new Map<string, string[]>();
		for (const response of existingResponses) {
			responseMap.set(response.questionCode, response.answerCodes);
		}
		responseMap.set(questionCode, answerCodes);

		const skipSections: string[] = [];
		const skipQuestions: string[] = [];

		// Find rules triggered by this question
		for (const rule of this.rules) {
			// Check if this rule's condition involves the current question
			if (this.conditionInvolvesQuestion(rule.condition, questionCode)) {
				if (this.evaluateCondition(rule.condition, responseMap)) {
					skipSections.push(...rule.skipsSections);
					skipQuestions.push(...rule.skipsQuestions);
				}
			}
		}

		return { skipSections, skipQuestions };
	}

	private evaluateCondition(
		condition: GateCondition | CompositeCondition,
		responses: Map<string, string[]>
	): boolean {
		if ('operator' in condition && condition.operator === 'AND') {
			return (condition as CompositeCondition).conditions.every((c) =>
				this.evaluateCondition(c, responses)
			);
		}

		if ('operator' in condition && condition.operator === 'OR') {
			return (condition as CompositeCondition).conditions.some((c) =>
				this.evaluateCondition(c, responses)
			);
		}

		// Simple condition
		const gateCondition = condition as GateCondition;
		const responseAnswers = responses.get(gateCondition.questionCode);

		if (!responseAnswers) return false;

		switch (gateCondition.operator) {
			case 'EQUALS':
				return responseAnswers.includes(gateCondition.value as string);

			case 'NOT_EQUALS':
				return !responseAnswers.includes(gateCondition.value as string);

			case 'IN':
				return (gateCondition.value as string[]).some((v) => responseAnswers.includes(v));

			case 'NOT_IN':
				return !(gateCondition.value as string[]).some((v) => responseAnswers.includes(v));

			case 'CONTAINS':
				return responseAnswers.some((a) => a.includes(gateCondition.value as string));

			case 'GREATER_THAN': {
				const numValue = parseFloat(responseAnswers[0] || '0');
				return numValue > (gateCondition.value as number);
			}

			case 'LESS_THAN': {
				const numValue = parseFloat(responseAnswers[0] || '0');
				return numValue < (gateCondition.value as number);
			}

			default:
				return false;
		}
	}

	private conditionInvolvesQuestion(
		condition: GateCondition | CompositeCondition,
		questionCode: string
	): boolean {
		if ('conditions' in condition) {
			return condition.conditions.some((c) => this.conditionInvolvesQuestion(c, questionCode));
		}
		return (condition as GateCondition).questionCode === questionCode;
	}
}

/**
 * Default gate rules for the sleep quiz
 * These must match the question codes in the database (002_seed_data.sql)
 */
export const defaultGateRules: GateRule[] = [
	// Gender-based gates
	{
		id: 'gate_male',
		questionId: 'q_gender',
		condition: {
			questionCode: 'GENDER',
			operator: 'EQUALS',
			value: 'MALE'
		},
		skipsSections: [],
		skipsQuestions: [
			'MENOPAUSE_SYMPTOMS',
			'PREGNANCY_STATUS',
			'POSTPARTUM',
			'MENSTRUAL_CYCLE'
		]
	},

	// Female-specific gates
	{
		id: 'gate_female',
		questionId: 'q_gender',
		condition: {
			questionCode: 'GENDER',
			operator: 'EQUALS',
			value: 'FEMALE'
		},
		skipsSections: [],
		skipsQuestions: ['ANDROPAUSE_SYMPTOMS', 'PROSTATE_ISSUES']
	},

	// Age-based gates (young people skip age-related questions)
	{
		id: 'gate_young',
		questionId: 'q_age',
		condition: {
			questionCode: 'AGE_GROUP',
			operator: 'IN',
			value: ['18_25', '26_35', '36_45']
		},
		skipsSections: [],
		skipsQuestions: ['AGE_RELATED_SLEEP', 'MENOPAUSE_SYMPTOMS', 'ANDROPAUSE_SYMPTOMS']
	},

	// No children gate
	{
		id: 'gate_no_children',
		questionId: 'q_children',
		condition: {
			questionCode: 'HAS_YOUNG_CHILDREN',
			operator: 'EQUALS',
			value: 'NO'
		},
		skipsSections: [],
		skipsQuestions: ['CHILDCARE_DISRUPTION']
	},

	// No pets gate
	{
		id: 'gate_no_pets',
		questionId: 'q_pets',
		condition: {
			questionCode: 'HAS_PETS_BEDROOM',
			operator: 'EQUALS',
			value: 'NO'
		},
		skipsSections: [],
		skipsQuestions: ['PET_DISTURBANCE']
	},

	// Lives alone gate
	{
		id: 'gate_lives_alone',
		questionId: 'q_living_situation',
		condition: {
			questionCode: 'LIVING_SITUATION',
			operator: 'EQUALS',
			value: 'ALONE'
		},
		skipsSections: [],
		skipsQuestions: ['PARTNER_SNORING', 'PARTNER_MOVEMENT', 'PARTNER_SCHEDULE']
	},

	// No caffeine gate - skip timing question if no caffeine
	{
		id: 'gate_no_caffeine',
		questionId: 'q_caffeine',
		condition: {
			questionCode: 'CAFFEINE_AMOUNT',
			operator: 'EQUALS',
			value: 'NONE'
		},
		skipsSections: [],
		skipsQuestions: ['CAFFEINE_TIMING']
	}
];
