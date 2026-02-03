export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export type QuizMode = 'RAPID' | 'COMPLETE';
export type QuestionType = 'SINGLE' | 'MULTIPLE' | 'SCALE' | 'TEXT';
export type FlagSeverity = 'URGENT' | 'IMPORTANT' | 'MODERATE' | 'INFO';
export type ConditionOperator = 'EQUALS' | 'NOT_EQUALS' | 'IN' | 'NOT_IN' | 'GREATER_THAN' | 'LESS_THAN' | 'CONTAINS' | 'AND' | 'OR';
export type ScoringRuleType = 'SINGLE' | 'MULTI' | 'COMBINATION' | 'THRESHOLD';
export type EmailStatus = 'PENDING' | 'SENT' | 'FAILED' | 'CANCELLED';

export interface Database {
	public: {
		Tables: {
			quiz_sections: {
				Row: {
					id: string;
					code: string;
					order_index: number;
					modes: QuizMode[];
					created_at: string;
				};
				Insert: {
					id?: string;
					code: string;
					order_index: number;
					modes: QuizMode[];
					created_at?: string;
				};
				Update: {
					id?: string;
					code?: string;
					order_index?: number;
					modes?: QuizMode[];
					created_at?: string;
				};
			};
			quiz_sections_i18n: {
				Row: {
					id: string;
					section_id: string;
					locale: string;
					title: string;
					description: string | null;
				};
				Insert: {
					id?: string;
					section_id: string;
					locale: string;
					title: string;
					description?: string | null;
				};
				Update: {
					id?: string;
					section_id?: string;
					locale?: string;
					title?: string;
					description?: string | null;
				};
			};
			quiz_questions: {
				Row: {
					id: string;
					section_id: string;
					code: string;
					type: QuestionType;
					order_index: number;
					is_gate: boolean;
					modes: QuizMode[];
					created_at: string;
				};
				Insert: {
					id?: string;
					section_id: string;
					code: string;
					type: QuestionType;
					order_index: number;
					is_gate?: boolean;
					modes: QuizMode[];
					created_at?: string;
				};
				Update: {
					id?: string;
					section_id?: string;
					code?: string;
					type?: QuestionType;
					order_index?: number;
					is_gate?: boolean;
					modes?: QuizMode[];
					created_at?: string;
				};
			};
			quiz_questions_i18n: {
				Row: {
					id: string;
					question_id: string;
					locale: string;
					text: string;
					help_text: string | null;
				};
				Insert: {
					id?: string;
					question_id: string;
					locale: string;
					text: string;
					help_text?: string | null;
				};
				Update: {
					id?: string;
					question_id?: string;
					locale?: string;
					text?: string;
					help_text?: string | null;
				};
			};
			quiz_answers: {
				Row: {
					id: string;
					question_id: string;
					code: string;
					order_index: number;
					is_exclusive: boolean;
					created_at: string;
				};
				Insert: {
					id?: string;
					question_id: string;
					code: string;
					order_index: number;
					is_exclusive?: boolean;
					created_at?: string;
				};
				Update: {
					id?: string;
					question_id?: string;
					code?: string;
					order_index?: number;
					is_exclusive?: boolean;
					created_at?: string;
				};
			};
			quiz_answers_i18n: {
				Row: {
					id: string;
					answer_id: string;
					locale: string;
					text: string;
				};
				Insert: {
					id?: string;
					answer_id: string;
					locale: string;
					text: string;
				};
				Update: {
					id?: string;
					answer_id?: string;
					locale?: string;
					text?: string;
				};
			};
			gate_rules: {
				Row: {
					id: string;
					question_id: string;
					condition: Json;
					skips_sections: string[];
					skips_questions: string[];
					created_at: string;
				};
				Insert: {
					id?: string;
					question_id: string;
					condition: Json;
					skips_sections?: string[];
					skips_questions?: string[];
					created_at?: string;
				};
				Update: {
					id?: string;
					question_id?: string;
					condition?: Json;
					skips_sections?: string[];
					skips_questions?: string[];
					created_at?: string;
				};
			};
			risk_categories: {
				Row: {
					id: string;
					code: string;
					order_index: number;
					max_score: number;
					created_at: string;
				};
				Insert: {
					id?: string;
					code: string;
					order_index: number;
					max_score?: number;
					created_at?: string;
				};
				Update: {
					id?: string;
					code?: string;
					order_index?: number;
					max_score?: number;
					created_at?: string;
				};
			};
			risk_categories_i18n: {
				Row: {
					id: string;
					category_id: string;
					locale: string;
					name: string;
					description: string | null;
				};
				Insert: {
					id?: string;
					category_id: string;
					locale: string;
					name: string;
					description?: string | null;
				};
				Update: {
					id?: string;
					category_id?: string;
					locale?: string;
					name?: string;
					description?: string | null;
				};
			};
			scoring_rules: {
				Row: {
					id: string;
					category_id: string;
					rule_type: ScoringRuleType;
					condition: Json;
					points: number;
					created_at: string;
				};
				Insert: {
					id?: string;
					category_id: string;
					rule_type: ScoringRuleType;
					condition: Json;
					points: number;
					created_at?: string;
				};
				Update: {
					id?: string;
					category_id?: string;
					rule_type?: ScoringRuleType;
					condition?: Json;
					points?: number;
					created_at?: string;
				};
			};
			medical_flag_rules: {
				Row: {
					id: string;
					code: string;
					severity: FlagSeverity;
					condition: Json;
					requires_professional: boolean;
					created_at: string;
				};
				Insert: {
					id?: string;
					code: string;
					severity: FlagSeverity;
					condition: Json;
					requires_professional?: boolean;
					created_at?: string;
				};
				Update: {
					id?: string;
					code?: string;
					severity?: FlagSeverity;
					condition?: Json;
					requires_professional?: boolean;
					created_at?: string;
				};
			};
			medical_flag_rules_i18n: {
				Row: {
					id: string;
					rule_id: string;
					locale: string;
					title: string;
					description: string;
					recommendation: string;
				};
				Insert: {
					id?: string;
					rule_id: string;
					locale: string;
					title: string;
					description: string;
					recommendation: string;
				};
				Update: {
					id?: string;
					rule_id?: string;
					locale?: string;
					title?: string;
					description?: string;
					recommendation?: string;
				};
			};
			quiz_sessions: {
				Row: {
					id: string;
					user_id: string | null;
					mode: QuizMode;
					locale: string;
					started_at: string;
					completed_at: string | null;
					current_section_index: number;
					current_question_index: number;
					skipped_sections: string[];
					skipped_questions: string[];
				};
				Insert: {
					id?: string;
					user_id?: string | null;
					mode: QuizMode;
					locale?: string;
					started_at?: string;
					completed_at?: string | null;
					current_section_index?: number;
					current_question_index?: number;
					skipped_sections?: string[];
					skipped_questions?: string[];
				};
				Update: {
					id?: string;
					user_id?: string | null;
					mode?: QuizMode;
					locale?: string;
					started_at?: string;
					completed_at?: string | null;
					current_section_index?: number;
					current_question_index?: number;
					skipped_sections?: string[];
					skipped_questions?: string[];
				};
			};
			quiz_responses: {
				Row: {
					id: string;
					session_id: string;
					question_id: string;
					answer_codes: string[];
					scale_value: number | null;
					text_value: string | null;
					responded_at: string;
				};
				Insert: {
					id?: string;
					session_id: string;
					question_id: string;
					answer_codes: string[];
					scale_value?: number | null;
					text_value?: string | null;
					responded_at?: string;
				};
				Update: {
					id?: string;
					session_id?: string;
					question_id?: string;
					answer_codes?: string[];
					scale_value?: number | null;
					text_value?: string | null;
					responded_at?: string;
				};
			};
			quiz_results: {
				Row: {
					id: string;
					session_id: string;
					overall_score: number;
					category_scores: Json;
					top_risks: string[];
					medical_flags: Json;
					recommendations: Json;
					created_at: string;
				};
				Insert: {
					id?: string;
					session_id: string;
					overall_score: number;
					category_scores: Json;
					top_risks: string[];
					medical_flags?: Json;
					recommendations?: Json;
					created_at?: string;
				};
				Update: {
					id?: string;
					session_id?: string;
					overall_score?: number;
					category_scores?: Json;
					top_risks?: string[];
					medical_flags?: Json;
					recommendations?: Json;
					created_at?: string;
				};
			};
			email_templates: {
				Row: {
					id: string;
					code: string;
					sequence_order: number;
					delay_days: number;
					created_at: string;
				};
				Insert: {
					id?: string;
					code: string;
					sequence_order: number;
					delay_days: number;
					created_at?: string;
				};
				Update: {
					id?: string;
					code?: string;
					sequence_order?: number;
					delay_days?: number;
					created_at?: string;
				};
			};
			email_templates_i18n: {
				Row: {
					id: string;
					template_id: string;
					locale: string;
					subject: string;
					body_html: string;
					body_text: string;
				};
				Insert: {
					id?: string;
					template_id: string;
					locale: string;
					subject: string;
					body_html: string;
					body_text: string;
				};
				Update: {
					id?: string;
					template_id?: string;
					locale?: string;
					subject?: string;
					body_html?: string;
					body_text?: string;
				};
			};
			email_queue: {
				Row: {
					id: string;
					session_id: string;
					template_id: string;
					to_email: string;
					status: EmailStatus;
					scheduled_for: string;
					sent_at: string | null;
					error: string | null;
					created_at: string;
				};
				Insert: {
					id?: string;
					session_id: string;
					template_id: string;
					to_email: string;
					status?: EmailStatus;
					scheduled_for: string;
					sent_at?: string | null;
					error?: string | null;
					created_at?: string;
				};
				Update: {
					id?: string;
					session_id?: string;
					template_id?: string;
					to_email?: string;
					status?: EmailStatus;
					scheduled_for?: string;
					sent_at?: string | null;
					error?: string | null;
					created_at?: string;
				};
			};
			users: {
				Row: {
					id: string;
					email: string;
					role: 'user' | 'admin';
					locale: string;
					created_at: string;
					updated_at: string;
				};
				Insert: {
					id: string;
					email: string;
					role?: 'user' | 'admin';
					locale?: string;
					created_at?: string;
					updated_at?: string;
				};
				Update: {
					id?: string;
					email?: string;
					role?: 'user' | 'admin';
					locale?: string;
					created_at?: string;
					updated_at?: string;
				};
			};
		};
		Views: {};
		Functions: {};
		Enums: {
			quiz_mode: QuizMode;
			question_type: QuestionType;
			flag_severity: FlagSeverity;
			condition_operator: ConditionOperator;
			scoring_rule_type: ScoringRuleType;
			email_status: EmailStatus;
		};
	};
}
