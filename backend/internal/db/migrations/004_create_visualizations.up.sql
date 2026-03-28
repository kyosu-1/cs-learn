CREATE TABLE visualizations (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id      UUID NOT NULL REFERENCES categories(id),
    slug             TEXT UNIQUE NOT NULL,
    title            TEXT NOT NULL,
    description      TEXT,
    viz_type         TEXT NOT NULL,
    config           JSONB NOT NULL DEFAULT '{}',
    difficulty_level INTEGER NOT NULL DEFAULT 1,
    is_published     BOOLEAN NOT NULL DEFAULT false
);
