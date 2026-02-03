import type {
	ResponseMap,
	ScoringRule,
	RiskCategory,
	CategoryScore,
	ScoringResult
} from './types';
import { evaluateCondition } from './evaluator';

/**
 * Main scoring calculator
 */
export class ScoreCalculator {
	private rules: ScoringRule[];
	private categories: RiskCategory[];

	constructor(rules: ScoringRule[], categories: RiskCategory[]) {
		this.rules = rules;
		this.categories = categories;
	}

	/**
	 * Calculate all scores from user responses
	 */
	calculate(responses: ResponseMap): ScoringResult {
		const categoryScores = this.calculateCategoryScores(responses);
		const triggeredRules = this.getTriggeredRules(responses);
		const overallScore = this.calculateOverallScore(categoryScores);
		const overallRiskLevel = this.determineRiskLevel(overallScore);
		const topRisks = this.getTopRisks(categoryScores, 5);

		return {
			overallScore,
			overallRiskLevel,
			categoryScores,
			topRisks,
			triggeredRules
		};
	}

	private calculateCategoryScores(responses: ResponseMap): CategoryScore[] {
		const rawScores = new Map<string, number>();
		const effectiveMaxScores = new Map<string, number>();

		// Initialize all categories with 0
		for (const category of this.categories) {
			rawScores.set(category.code, 0);
			effectiveMaxScores.set(category.code, 0);
		}

		// Get the set of answered question codes
		const answeredQuestions = new Set(responses.keys());

		// For each rule, check if its question was answered
		// If answered, add its points to the effective max for that category
		// If the rule condition is met, also add to raw score
		for (const rule of this.rules) {
			const questionCode = this.getQuestionCodeFromCondition(rule.condition);

			// Only count rules for questions that were actually answered
			if (questionCode && answeredQuestions.has(questionCode)) {
				// Add to effective max (this question was asked, so its points are possible)
				const currentMax = effectiveMaxScores.get(rule.categoryCode) || 0;
				effectiveMaxScores.set(rule.categoryCode, currentMax + rule.points);

				// Check if rule triggered
				if (evaluateCondition(rule.condition, responses)) {
					const current = rawScores.get(rule.categoryCode) || 0;
					rawScores.set(rule.categoryCode, current + rule.points);
				}
			}
		}

		// Debug logging (development only)
		if (import.meta.env.DEV) {
			console.log('=== SCORING DEBUG ===');
			console.log('Answered questions:', [...answeredQuestions]);
			console.log('Raw scores:', Object.fromEntries(rawScores));
			console.log('Effective max scores:', Object.fromEntries(effectiveMaxScores));
		}

		// Build category scores
		return this.categories.map((category) => {
			const rawScore = rawScores.get(category.code) || 0;
			const effectiveMax = effectiveMaxScores.get(category.code) || 0;
			// Use effective max if available, otherwise fall back to category max
			const maxToUse = effectiveMax > 0 ? effectiveMax : category.maxScore;
			const normalizedScore = this.normalizeScore(rawScore, maxToUse);
			const percentage = Math.round(normalizedScore * 100);
			const riskLevel = this.determineRiskLevel(percentage);

			if (import.meta.env.DEV) {
				console.log(
					`  ${category.code}: raw=${rawScore}, effectiveMax=${effectiveMax}, maxUsed=${maxToUse}, pct=${percentage}%`
				);
			}

			return {
				categoryCode: category.code,
				categoryName: category.name,
				rawScore,
				maxPossible: maxToUse,
				normalizedScore,
				percentage,
				riskLevel
			};
		});
	}

	/**
	 * Extract the primary question code from a condition
	 * For COMBINATION conditions, returns the first question code found
	 */
	private getQuestionCodeFromCondition(condition: ScoringRule['condition']): string | null {
		if ('questionCode' in condition && condition.questionCode) {
			return condition.questionCode;
		}
		if ('conditions' in condition && condition.conditions) {
			for (const subCondition of condition.conditions) {
				const code = this.getQuestionCodeFromCondition(subCondition as ScoringRule['condition']);
				if (code) return code;
			}
		}
		return null;
	}

	private normalizeScore(rawScore: number, maxScore: number): number {
		if (maxScore <= 0) return 0;
		return Math.min(rawScore / maxScore, 1);
	}

	private calculateOverallScore(categoryScores: CategoryScore[]): number {
		let totalWeight = 0;
		let weightedSum = 0;

		// Only include categories that have points (were tested)
		// This prevents untested categories from dragging down the score in RAPID mode
		const testedScores = categoryScores.filter((s) => s.rawScore > 0);

		// If no categories have points, use all categories to avoid division by zero
		const scoresToUse = testedScores.length > 0 ? testedScores : categoryScores;

		for (const score of scoresToUse) {
			const category = this.categories.find((c) => c.code === score.categoryCode);
			const weight = category?.weight || 1;
			totalWeight += weight;
			weightedSum += score.normalizedScore * weight;
		}

		if (totalWeight === 0) return 0;
		return Math.round((weightedSum / totalWeight) * 100);
	}

	private determineRiskLevel(score: number): 'LOW' | 'MODERATE' | 'HIGH' | 'CRITICAL' {
		if (score >= 75) return 'CRITICAL';
		if (score >= 50) return 'HIGH';
		if (score >= 25) return 'MODERATE';
		return 'LOW';
	}

	private getTopRisks(categoryScores: CategoryScore[], limit: number): string[] {
		return categoryScores
			.filter((s) => s.percentage > 0)
			.sort((a, b) => b.percentage - a.percentage)
			.slice(0, limit)
			.map((s) => s.categoryCode);
	}

	private getTriggeredRules(responses: ResponseMap): string[] {
		return this.rules
			.filter((rule) => evaluateCondition(rule.condition, responses))
			.map((rule) => rule.id);
	}
}

/**
 * Create a response map from quiz responses
 */
export function createResponseMap(
	responses: Array<{ questionCode: string; answerCodes?: string[]; scaleValue?: number }>
): ResponseMap {
	const map: ResponseMap = new Map();

	for (const response of responses) {
		if (response.scaleValue !== undefined) {
			map.set(response.questionCode, response.scaleValue);
		} else if (response.answerCodes && response.answerCodes.length > 0) {
			map.set(response.questionCode, response.answerCodes);
		}
	}

	return map;
}
