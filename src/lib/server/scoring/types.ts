import type { ScoringRuleType, FlagSeverity } from '$lib/types/database';

// Response map: questionCode -> answerCodes[] or scaleValue
export type ResponseMap = Map<string, string[] | number>;

// Scoring condition types
export interface SingleCondition {
	type: 'SINGLE';
	questionCode: string;
	answerCode: string;
}

export interface MultiCondition {
	type: 'MULTI';
	questionCode: string;
	answerCodes: string[];
	matchType: 'ANY' | 'ALL';
}

export interface ThresholdCondition {
	type: 'THRESHOLD';
	questionCode: string;
	operator: 'GT' | 'LT' | 'GTE' | 'LTE' | 'EQ';
	value: number;
}

export interface CombinationCondition {
	type: 'COMBINATION';
	operator: 'AND' | 'OR';
	conditions: ScoringCondition[];
}

export type ScoringCondition =
	| SingleCondition
	| MultiCondition
	| ThresholdCondition
	| CombinationCondition;

export interface ScoringRule {
	id: string;
	categoryCode: string;
	condition: ScoringCondition;
	points: number;
	description?: string;
}

export interface RiskCategory {
	code: string;
	name: string;
	maxScore: number;
	weight: number;
}

export interface CategoryScore {
	categoryCode: string;
	categoryName: string;
	rawScore: number;
	maxPossible: number;
	normalizedScore: number;
	percentage: number;
	riskLevel: 'LOW' | 'MODERATE' | 'HIGH' | 'CRITICAL';
}

export interface ScoringResult {
	overallScore: number;
	overallRiskLevel: 'LOW' | 'MODERATE' | 'HIGH' | 'CRITICAL';
	categoryScores: CategoryScore[];
	topRisks: string[];
	triggeredRules: string[];
}

// Medical flag types
export interface FlagCondition {
	type: 'SINGLE' | 'MULTI' | 'THRESHOLD' | 'COMBINATION';
	questionCode?: string;
	answerCode?: string;
	answerCodes?: string[];
	operator?: 'GT' | 'LT' | 'GTE' | 'LTE' | 'EQ' | 'AND' | 'OR';
	value?: number;
	conditions?: FlagCondition[];
}

export interface MedicalFlagRule {
	id: string;
	code: string;
	severity: FlagSeverity;
	condition: FlagCondition;
	requiresProfessional: boolean;
}

export interface MedicalFlag {
	code: string;
	severity: FlagSeverity;
	title: string;
	description: string;
	recommendation: string;
	requiresProfessional: boolean;
	confidence: number;
}
