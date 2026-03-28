package model

import (
	"encoding/json"

	"github.com/google/uuid"
)

type Visualization struct {
	ID              uuid.UUID       `json:"id"`
	CategoryID      uuid.UUID       `json:"category_id"`
	Slug            string          `json:"slug"`
	Title           string          `json:"title"`
	Description     *string         `json:"description"`
	VizType         string          `json:"viz_type"`
	Config          json.RawMessage `json:"config"`
	DifficultyLevel int             `json:"difficulty_level"`
	IsPublished     bool            `json:"is_published"`
}
