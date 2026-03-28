CREATE TABLE topics (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug            TEXT UNIQUE NOT NULL,
    title           TEXT NOT NULL,
    description     TEXT,
    icon_name       TEXT,
    sort_order      INTEGER NOT NULL DEFAULT 0,
    is_published    BOOLEAN NOT NULL DEFAULT false,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE categories (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    topic_id        UUID NOT NULL REFERENCES topics(id),
    slug            TEXT NOT NULL,
    title           TEXT NOT NULL,
    description     TEXT,
    sort_order      INTEGER NOT NULL DEFAULT 0,
    UNIQUE (topic_id, slug)
);

CREATE TABLE lessons (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id       UUID NOT NULL REFERENCES categories(id),
    slug              TEXT NOT NULL,
    title             TEXT NOT NULL,
    summary           TEXT,
    difficulty_level  INTEGER NOT NULL DEFAULT 1 CHECK (difficulty_level BETWEEN 1 AND 4),
    estimated_minutes INTEGER,
    sort_order        INTEGER NOT NULL DEFAULT 0,
    is_published      BOOLEAN NOT NULL DEFAULT false,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (category_id, slug)
);

CREATE TABLE lesson_blocks (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lesson_id   UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    block_type  TEXT NOT NULL,
    content     JSONB NOT NULL,
    sort_order  INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_lesson_blocks_lesson ON lesson_blocks(lesson_id, sort_order);
