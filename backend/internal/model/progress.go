package model

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

type UserLessonProgress struct {
	ID             uuid.UUID  `json:"id"`
	UserID         uuid.UUID  `json:"user_id"`
	LessonID       uuid.UUID  `json:"lesson_id"`
	Status         string     `json:"status"`
	LastBlockIndex int        `json:"last_block_index"`
	CompletedAt    *time.Time `json:"completed_at"`
	CreatedAt      time.Time  `json:"created_at"`
	UpdatedAt      time.Time  `json:"updated_at"`
}

type UserQuizAttempt struct {
	ID           uuid.UUID `json:"id"`
	UserID       uuid.UUID `json:"user_id"`
	QuizID       uuid.UUID `json:"quiz_id"`
	Score        int       `json:"score"`
	MaxScore     int       `json:"max_score"`
	TimeSpentSec *int      `json:"time_spent_sec"`
	CompletedAt  time.Time `json:"completed_at"`
}

type UserQuestionAnswer struct {
	ID           uuid.UUID       `json:"id"`
	AttemptID    uuid.UUID       `json:"attempt_id"`
	QuestionID   uuid.UUID       `json:"question_id"`
	UserAnswer   json.RawMessage `json:"user_answer"`
	IsCorrect    bool            `json:"is_correct"`
	TimeSpentSec *int            `json:"time_spent_sec"`
}

type UserCategoryStats struct {
	ID             uuid.UUID `json:"id"`
	UserID         uuid.UUID `json:"user_id"`
	CategoryID     uuid.UUID `json:"category_id"`
	TotalQuestions int       `json:"total_questions"`
	CorrectAnswers int       `json:"correct_answers"`
	Accuracy       float32   `json:"accuracy"`
	UpdatedAt      time.Time `json:"updated_at"`
}

type XPEvent struct {
	ID          uuid.UUID  `json:"id"`
	UserID      uuid.UUID  `json:"user_id"`
	EventType   string     `json:"event_type"`
	XPAmount    int        `json:"xp_amount"`
	ReferenceID *uuid.UUID `json:"reference_id"`
	CreatedAt   time.Time  `json:"created_at"`
}
