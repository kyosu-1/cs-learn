package model

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

type Quiz struct {
	ID              uuid.UUID  `json:"id"`
	CategoryID      uuid.UUID  `json:"category_id"`
	LessonID        *uuid.UUID `json:"lesson_id"`
	Title           string     `json:"title"`
	DifficultyLevel int        `json:"difficulty_level"`
	IsPublished     bool       `json:"is_published"`
	CreatedAt       time.Time  `json:"created_at"`
}

type Question struct {
	ID            uuid.UUID       `json:"id"`
	QuizID        uuid.UUID       `json:"quiz_id"`
	QuestionType  string          `json:"question_type"`
	Prompt        string          `json:"prompt"`
	Options       json.RawMessage `json:"options,omitempty"`
	CorrectAnswer json.RawMessage `json:"-"`
	Explanation   *string         `json:"explanation,omitempty"`
	Hint          *string         `json:"hint,omitempty"`
	SortOrder     int             `json:"sort_order"`
	Points        int             `json:"points"`
}
