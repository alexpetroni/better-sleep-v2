import type {
	ResponseMap,
	ScoringCondition,
	SingleCondition,
	MultiCondition,
	ThresholdCondition,
	CombinationCondition,
	FlagCondition
} from './types';

/**
 * Evaluates if a scoring condition is met based on user responses
 */
export function evaluateCondition(
	condition: ScoringCondition,
	responses: ResponseMap
): boolean {
	switch (condition.type) {
		case 'SINGLE':
			return evaluateSingle(condition, responses);
		case 'MULTI':
			return evaluateMulti(condition, responses);
		case 'THRESHOLD':
			return evaluateThreshold(condition, responses);
		case 'COMBINATION':
			return evaluateCombination(condition, responses);
		default:
			return false;
	}
}

function evaluateSingle(condition: SingleCondition, responses: ResponseMap): boolean {
	const response = responses.get(condition.questionCode);
	if (!response || typeof response === 'number') return false;
	return response.includes(condition.answerCode);
}

function evaluateMulti(condition: MultiCondition, responses: ResponseMap): boolean {
	const response = responses.get(condition.questionCode);
	if (!response || typeof response === 'number') return false;

	if (condition.matchType === 'ANY') {
		return condition.answerCodes.some((code) => response.includes(code));
	} else {
		return condition.answerCodes.every((code) => response.includes(code));
	}
}

function evaluateThreshold(condition: ThresholdCondition, responses: ResponseMap): boolean {
	const response = responses.get(condition.questionCode);
	if (response === undefined) return false;

	const value = typeof response === 'number' ? response : parseFloat(response[0] || '0');
	if (isNaN(value)) return false;

	switch (condition.operator) {
		case 'GT':
			return value > condition.value;
		case 'LT':
			return value < condition.value;
		case 'GTE':
			return value >= condition.value;
		case 'LTE':
			return value <= condition.value;
		case 'EQ':
			return value === condition.value;
		default:
			return false;
	}
}

function evaluateCombination(
	condition: CombinationCondition,
	responses: ResponseMap
): boolean {
	const results = condition.conditions.map((c) => evaluateCondition(c, responses));

	if (condition.operator === 'AND') {
		return results.every(Boolean);
	} else {
		return results.some(Boolean);
	}
}

/**
 * Evaluates medical flag conditions (similar structure but separate for clarity)
 */
export function evaluateFlagCondition(
	condition: FlagCondition,
	responses: ResponseMap
): boolean {
	switch (condition.type) {
		case 'SINGLE':
			return evaluateFlagSingle(condition, responses);
		case 'MULTI':
			return evaluateFlagMulti(condition, responses);
		case 'THRESHOLD':
			return evaluateFlagThreshold(condition, responses);
		case 'COMBINATION':
			return evaluateFlagCombination(condition, responses);
		default:
			return false;
	}
}

function evaluateFlagSingle(condition: FlagCondition, responses: ResponseMap): boolean {
	if (!condition.questionCode || !condition.answerCode) return false;
	const response = responses.get(condition.questionCode);
	if (!response || typeof response === 'number') return false;
	return response.includes(condition.answerCode);
}

function evaluateFlagMulti(condition: FlagCondition, responses: ResponseMap): boolean {
	if (!condition.questionCode || !condition.answerCodes) return false;
	const response = responses.get(condition.questionCode);
	if (!response || typeof response === 'number') return false;
	return condition.answerCodes.some((code) => response.includes(code));
}

function evaluateFlagThreshold(condition: FlagCondition, responses: ResponseMap): boolean {
	if (!condition.questionCode || condition.value === undefined || !condition.operator) return false;
	const response = responses.get(condition.questionCode);
	if (response === undefined) return false;

	const value = typeof response === 'number' ? response : parseFloat(response[0] || '0');
	if (isNaN(value)) return false;

	switch (condition.operator) {
		case 'GT':
			return value > condition.value;
		case 'LT':
			return value < condition.value;
		case 'GTE':
			return value >= condition.value;
		case 'LTE':
			return value <= condition.value;
		case 'EQ':
			return value === condition.value;
		default:
			return false;
	}
}

function evaluateFlagCombination(condition: FlagCondition, responses: ResponseMap): boolean {
	if (!condition.conditions || !condition.operator) return false;
	const results = condition.conditions.map((c) => evaluateFlagCondition(c, responses));

	if (condition.operator === 'AND') {
		return results.every(Boolean);
	} else if (condition.operator === 'OR') {
		return results.some(Boolean);
	}
	return false;
}

/**
 * Calculate confidence score for a medical flag based on supporting evidence
 */
export function calculateConfidence(
	condition: FlagCondition,
	responses: ResponseMap
): number {
	if (condition.type !== 'COMBINATION' || !condition.conditions) {
		// Simple conditions have full confidence if triggered
		return evaluateFlagCondition(condition, responses) ? 1.0 : 0;
	}

	// For combination conditions, confidence is based on how many sub-conditions are met
	const results = condition.conditions.map((c) => evaluateFlagCondition(c, responses));
	const metCount = results.filter(Boolean).length;
	const total = results.length;

	if (condition.operator === 'AND') {
		// All must be true for the flag to trigger, confidence is all-or-nothing
		return metCount === total ? 1.0 : 0;
	} else {
		// OR: confidence scales with number of conditions met
		return metCount / total;
	}
}
