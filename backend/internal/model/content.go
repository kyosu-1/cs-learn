package model

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

type Topic struct {
	ID          uuid.UUID `json:"id"`
	Slug        string    `json:"slug"`
	Title       string    `json:"title"`
	Description *string   `json:"description"`
	IconName    *string   `json:"icon_name"`
	SortOrder   int       `json:"sort_order"`
	IsPublished bool      `json:"is_published"`
	CreatedAt   time.Time `json:"created_at"`
}

type Category struct {
	ID          uuid.UUID `json:"id"`
	TopicID     uuid.UUID `json:"topic_id"`
	Slug        string    `json:"slug"`
	Title       string    `json:"title"`
	Description *string   `json:"description"`
	SortOrder   int       `json:"sort_order"`
}

type Lesson struct {
	ID               uuid.UUID `json:"id"`
	CategoryID       uuid.UUID `json:"category_id"`
	Slug             string    `json:"slug"`
	Title            string    `json:"title"`
	Summary          *string   `json:"summary"`
	DifficultyLevel  int       `json:"difficulty_level"`
	EstimatedMinutes *int      `json:"estimated_minutes"`
	SortOrder        int       `json:"sort_order"`
	IsPublished      bool      `json:"is_published"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
}

type LessonBlock struct {
	ID        uuid.UUID       `json:"id"`
	LessonID  uuid.UUID       `json:"lesson_id"`
	BlockType string          `json:"block_type"`
	Content   json.RawMessage `json:"content"`
	SortOrder int             `json:"sort_order"`
}
