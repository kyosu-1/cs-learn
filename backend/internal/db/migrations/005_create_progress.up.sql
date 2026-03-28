CREATE TABLE user_lesson_progress (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          UUID NOT NULL REFERENCES users(id),
    lesson_id        UUID NOT NULL REFERENCES lessons(id),
    status           TEXT NOT NULL DEFAULT 'not_started',
    last_block_index INTEGER NOT NULL DEFAULT 0,
    completed_at     TIMESTAMPTZ,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, lesson_id)
);

CREATE TABLE user_quiz_attempts (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id        UUID NOT NULL REFERENCES users(id),
    quiz_id        UUID NOT NULL REFERENCES quizzes(id),
    score          INTEGER NOT NULL,
    max_score      INTEGER NOT NULL,
    time_spent_sec INTEGER,
    completed_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE user_question_answers (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attempt_id     UUID NOT NULL REFERENCES user_quiz_attempts(id) ON DELETE CASCADE,
    question_id    UUID NOT NULL REFERENCES questions(id),
    user_answer    JSONB NOT NULL,
    is_correct     BOOLEAN NOT NULL,
    time_spent_sec INTEGER
);

CREATE TABLE user_category_stats (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id),
    category_id     UUID NOT NULL REFERENCES categories(id),
    total_questions INTEGER NOT NULL DEFAULT 0,
    correct_answers INTEGER NOT NULL DEFAULT 0,
    accuracy        REAL GENERATED ALWAYS AS (
                        CASE WHEN total_questions > 0
                        THEN correct_answers::REAL / total_questions
                        ELSE 0 END
                    ) STORED,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, category_id)
);

CREATE TABLE xp_events (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID NOT NULL REFERENCES users(id),
    event_type   TEXT NOT NULL,
    xp_amount    INTEGER NOT NULL,
    reference_id UUID,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_user_lesson_progress ON user_lesson_progress(user_id);
CREATE INDEX idx_user_quiz_attempts ON user_quiz_attempts(user_id, quiz_id);
CREATE INDEX idx_user_category_stats ON user_category_stats(user_id);
CREATE INDEX idx_xp_events_user ON xp_events(user_id, created_at DESC);
