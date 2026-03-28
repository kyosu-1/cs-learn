export type User = {
  id: string;
  email: string;
  display_name: string;
  avatar_url: string | null;
  level: number;
  xp: number;
  created_at: string;
  updated_at: string;
};

export type Topic = {
  id: string;
  slug: string;
  title: string;
  description: string | null;
  icon_name: string | null;
  sort_order: number;
  is_published: boolean;
};

export type Category = {
  id: string;
  topic_id: string;
  slug: string;
  title: string;
  description: string | null;
  sort_order: number;
};

export type Lesson = {
  id: string;
  category_id: string;
  slug: string;
  title: string;
  summary: string | null;
  difficulty_level: number;
  estimated_minutes: number | null;
  sort_order: number;
  is_published: boolean;
};

export type LessonBlock = {
  id: string;
  lesson_id: string;
  block_type: 'markdown' | 'code' | 'diagram' | 'callout' | 'visualization_ref';
  content: Record<string, unknown>;
  sort_order: number;
};

export type Quiz = {
  id: string;
  category_id: string;
  lesson_id: string | null;
  title: string;
  difficulty_level: number;
  is_published: boolean;
};

export type Question = {
  id: string;
  quiz_id: string;
  question_type: 'multiple_choice' | 'fill_in_blank' | 'coding' | 'ordering' | 'true_false';
  prompt: string;
  options: Record<string, unknown>[] | null;
  explanation: string | null;
  hint: string | null;
  sort_order: number;
  points: number;
};

export type AuthTokens = {
  access_token: string;
  refresh_token: string;
};
