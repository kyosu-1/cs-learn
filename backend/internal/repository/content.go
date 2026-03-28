package repository

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/kyosu-1/cs-learn/backend/internal/model"
)

type ContentRepository struct {
	db *pgxpool.Pool
}

func NewContentRepository(db *pgxpool.Pool) *ContentRepository {
	return &ContentRepository{db: db}
}

func (r *ContentRepository) ListTopics(ctx context.Context) ([]model.Topic, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, slug, title, description, icon_name, sort_order, is_published, created_at
		 FROM topics WHERE is_published = true ORDER BY sort_order`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var topics []model.Topic
	for rows.Next() {
		var t model.Topic
		if err := rows.Scan(&t.ID, &t.Slug, &t.Title, &t.Description, &t.IconName,
			&t.SortOrder, &t.IsPublished, &t.CreatedAt); err != nil {
			return nil, err
		}
		topics = append(topics, t)
	}
	return topics, nil
}

func (r *ContentRepository) GetTopicBySlug(ctx context.Context, slug string) (*model.Topic, error) {
	t := &model.Topic{}
	err := r.db.QueryRow(ctx,
		`SELECT id, slug, title, description, icon_name, sort_order, is_published, created_at
		 FROM topics WHERE slug = $1`, slug,
	).Scan(&t.ID, &t.Slug, &t.Title, &t.Description, &t.IconName,
		&t.SortOrder, &t.IsPublished, &t.CreatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}
	return t, nil
}

func (r *ContentRepository) ListCategories(ctx context.Context, topicID uuid.UUID) ([]model.Category, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, topic_id, slug, title, description, sort_order
		 FROM categories WHERE topic_id = $1 ORDER BY sort_order`, topicID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var categories []model.Category
	for rows.Next() {
		var c model.Category
		if err := rows.Scan(&c.ID, &c.TopicID, &c.Slug, &c.Title, &c.Description, &c.SortOrder); err != nil {
			return nil, err
		}
		categories = append(categories, c)
	}
	return categories, nil
}

func (r *ContentRepository) ListLessons(ctx context.Context, categoryID uuid.UUID) ([]model.Lesson, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, category_id, slug, title, summary, difficulty_level, estimated_minutes,
		        sort_order, is_published, created_at, updated_at
		 FROM lessons WHERE category_id = $1 AND is_published = true ORDER BY sort_order`, categoryID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var lessons []model.Lesson
	for rows.Next() {
		var l model.Lesson
		if err := rows.Scan(&l.ID, &l.CategoryID, &l.Slug, &l.Title, &l.Summary,
			&l.DifficultyLevel, &l.EstimatedMinutes, &l.SortOrder, &l.IsPublished,
			&l.CreatedAt, &l.UpdatedAt); err != nil {
			return nil, err
		}
		lessons = append(lessons, l)
	}
	return lessons, nil
}

func (r *ContentRepository) GetLesson(ctx context.Context, id uuid.UUID) (*model.Lesson, error) {
	l := &model.Lesson{}
	err := r.db.QueryRow(ctx,
		`SELECT id, category_id, slug, title, summary, difficulty_level, estimated_minutes,
		        sort_order, is_published, created_at, updated_at
		 FROM lessons WHERE id = $1`, id,
	).Scan(&l.ID, &l.CategoryID, &l.Slug, &l.Title, &l.Summary,
		&l.DifficultyLevel, &l.EstimatedMinutes, &l.SortOrder, &l.IsPublished,
		&l.CreatedAt, &l.UpdatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}
	return l, nil
}

func (r *ContentRepository) GetLessonBlocks(ctx context.Context, lessonID uuid.UUID) ([]model.LessonBlock, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, lesson_id, block_type, content, sort_order
		 FROM lesson_blocks WHERE lesson_id = $1 ORDER BY sort_order`, lessonID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var blocks []model.LessonBlock
	for rows.Next() {
		var b model.LessonBlock
		if err := rows.Scan(&b.ID, &b.LessonID, &b.BlockType, &b.Content, &b.SortOrder); err != nil {
			return nil, err
		}
		blocks = append(blocks, b)
	}
	return blocks, nil
}
