CREATE TABLE quizzes (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id      UUID NOT NULL REFERENCES categories(id),
    lesson_id        UUID REFERENCES lessons(id),
    title            TEXT NOT NULL,
    difficulty_level INTEGER NOT NULL DEFAULT 1 CHECK (difficulty_level BETWEEN 1 AND 4),
    is_published     BOOLEAN NOT NULL DEFAULT false,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE questions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id         UUID NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    question_type   TEXT NOT NULL,
    prompt          TEXT NOT NULL,
    options         JSONB,
    correct_answer  JSONB NOT NULL,
    explanation     TEXT,
    hint            TEXT,
    sort_order      INTEGER NOT NULL DEFAULT 0,
    points          INTEGER NOT NULL DEFAULT 10
);

CREATE INDEX idx_questions_quiz ON questions(quiz_id, sort_order);
