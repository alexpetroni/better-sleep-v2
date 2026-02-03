import type { QuizMode, QuestionType, FlagSeverity, ConditionOperator, ScoringRuleType } from './database';

// Core quiz types
export interface QuizSection {
	id: string;
	code: string;
	title: string;
	description?: string;
	orderIndex: number;
	modes: QuizMode[];
	questions: QuizQuestion[];
}

export interface QuizQuestion {
	id: string;
	sectionId: string;
	code: string;
	text: string;
	helpText?: string;
	type: QuestionType;
	orderIndex: number;
	isGate: boolean;
	modes: QuizMode[];
	answers: QuizAnswer[];
	scaleConfig?: ScaleConfig;
}

export interface QuizAnswer {
	id: string;
	questionId: string;
	code: string;
	text: string;
	orderIndex: number;
	isExclusive: boolean;
}

export interface ScaleConfig {
	min: number;
	max: number;
	step: number;
	minLabel?: string;
	maxLabel?: string;
}

// Gate rules for conditional logic
export interface GateCondition {
	questionCode: string;
	operator: ConditionOperator;
	value: string | string[] | number;
}

export interface CompositeCondition {
	operator: 'AND' | 'OR';
	conditions: (GateCondition | CompositeCondition)[];
}

export interface GateRule {
	id: string;
	questionId: string;
	condition: GateCondition | CompositeCondition;
	skipsSections: string[];
	skipsQuestions: string[];
}

// Scoring types
export interface RiskCategory {
	id: string;
	code: string;
	name: string;
	description?: string;
	orderIndex: number;
	maxScore: number;
}

export interface ScoringCondition {
	type: ScoringRuleType;
	questionCode?: string;
	answerCode?: string;
	answerCodes?: string[];
	scaleThreshold?: number;
	scaleOperator?: 'GREATER_THAN' | 'LESS_THAN' | 'EQUALS';
	conditions?: ScoringCondition[];
}

export interface ScoringRule {
	id: string;
	categoryId: string;
	ruleType: ScoringRuleType;
	condition: ScoringCondition;
	points: number;
}

export interface CategoryScore {
	categoryCode: string;
	rawScore: number;
	normalizedScore: number;
	maxPossible: number;
	percentage: number;
}

export interface QuizScores {
	overallScore: number;
	categoryScores: CategoryScore[];
	topRisks: string[];
}

// Medical flags
export interface MedicalFlagRule {
	id: string;
	code: string;
	severity: FlagSeverity;
	condition: GateCondition | CompositeCondition;
	requiresProfessional: boolean;
	title: string;
	description: string;
	recommendation: string;
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

// Session types
export interface QuizSession {
	id: string;
	userId?: string;
	mode: QuizMode;
	locale: string;
	startedAt: Date;
	completedAt?: Date;
	currentSectionIndex: number;
	currentQuestionIndex: number;
	skippedSections: string[];
	skippedQuestions: string[];
}

export interface QuizResponse {
	id: string;
	sessionId: string;
	questionId: string;
	questionCode: string;
	answerCodes: string[];
	scaleValue?: number;
	textValue?: string;
	respondedAt: Date;
}

export interface QuizResult {
	id: string;
	sessionId: string;
	overallScore: number;
	categoryScores: CategoryScore[];
	topRisks: string[];
	medicalFlags: MedicalFlag[];
	recommendations: Recommendation[];
	createdAt: Date;
}

export interface Recommendation {
	categoryCode: string;
	priority: number;
	title: string;
	description: string;
	actionItems: string[];
}

// State management types
export interface QuizState {
	session: QuizSession | null;
	sections: QuizSection[];
	currentSection: QuizSection | null;
	currentQuestion: QuizQuestion | null;
	responses: Map<string, QuizResponse>;
	gateRules: GateRule[];
	progress: QuizProgress;
	isLoading: boolean;
	error: string | null;
}

export interface QuizProgress {
	totalQuestions: number;
	answeredQuestions: number;
	skippedQuestions: number;
	percentage: number;
	currentSectionName: string;
	sectionsCompleted: number;
	totalSections: number;
}

// API types
export interface CreateSessionRequest {
	mode: QuizMode;
	locale?: string;
	userId?: string;
}

export interface CreateSessionResponse {
	session: QuizSession;
	firstQuestion: QuizQuestion;
	section: QuizSection;
}

export interface SubmitResponseRequest {
	questionCode: string;
	answerCodes?: string[];
	scaleValue?: number;
	textValue?: string;
}

export interface SubmitResponseResponse {
	nextQuestion: QuizQuestion | null;
	nextSection: QuizSection | null;
	progress: QuizProgress;
	isComplete: boolean;
	skippedSections?: string[];
	skippedQuestions?: string[];
}

export interface GetResultsResponse {
	result: QuizResult;
	session: QuizSession;
}
