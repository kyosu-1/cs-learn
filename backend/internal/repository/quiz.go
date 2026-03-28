package repository

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/kyosu-1/cs-learn/backend/internal/model"
)

type QuizRepository struct {
	db *pgxpool.Pool
}

func NewQuizRepository(db *pgxpool.Pool) *QuizRepository {
	return &QuizRepository{db: db}
}

func (r *QuizRepository) ListByCategory(ctx context.Context, categoryID uuid.UUID) ([]model.Quiz, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, category_id, lesson_id, title, difficulty_level, is_published, created_at
		 FROM quizzes WHERE category_id = $1 AND is_published = true ORDER BY created_at`, categoryID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var quizzes []model.Quiz
	for rows.Next() {
		var q model.Quiz
		if err := rows.Scan(&q.ID, &q.CategoryID, &q.LessonID, &q.Title,
			&q.DifficultyLevel, &q.IsPublished, &q.CreatedAt); err != nil {
			return nil, err
		}
		quizzes = append(quizzes, q)
	}
	return quizzes, nil
}

func (r *QuizRepository) GetByID(ctx context.Context, id uuid.UUID) (*model.Quiz, error) {
	q := &model.Quiz{}
	err := r.db.QueryRow(ctx,
		`SELECT id, category_id, lesson_id, title, difficulty_level, is_published, created_at
		 FROM quizzes WHERE id = $1`, id,
	).Scan(&q.ID, &q.CategoryID, &q.LessonID, &q.Title,
		&q.DifficultyLevel, &q.IsPublished, &q.CreatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}
	return q, nil
}

func (r *QuizRepository) GetQuestions(ctx context.Context, quizID uuid.UUID) ([]model.Question, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, quiz_id, question_type, prompt, options, correct_answer, explanation, hint, sort_order, points
		 FROM questions WHERE quiz_id = $1 ORDER BY sort_order`, quizID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var questions []model.Question
	for rows.Next() {
		var q model.Question
		if err := rows.Scan(&q.ID, &q.QuizID, &q.QuestionType, &q.Prompt, &q.Options,
			&q.CorrectAnswer, &q.Explanation, &q.Hint, &q.SortOrder, &q.Points); err != nil {
			return nil, err
		}
		questions = append(questions, q)
	}
	return questions, nil
}

func (r *QuizRepository) GetQuestionByID(ctx context.Context, id uuid.UUID) (*model.Question, error) {
	q := &model.Question{}
	err := r.db.QueryRow(ctx,
		`SELECT id, quiz_id, question_type, prompt, options, correct_answer, explanation, hint, sort_order, points
		 FROM questions WHERE id = $1`, id,
	).Scan(&q.ID, &q.QuizID, &q.QuestionType, &q.Prompt, &q.Options,
		&q.CorrectAnswer, &q.Explanation, &q.Hint, &q.SortOrder, &q.Points)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}
	return q, nil
}

func (r *QuizRepository) CreateAttempt(ctx context.Context, attempt *model.UserQuizAttempt) error {
	_, err := r.db.Exec(ctx,
		`INSERT INTO user_quiz_attempts (id, user_id, quiz_id, score, max_score, time_spent_sec)
		 VALUES ($1, $2, $3, $4, $5, $6)`,
		attempt.ID, attempt.UserID, attempt.QuizID, attempt.Score, attempt.MaxScore, attempt.TimeSpentSec)
	return err
}

func (r *QuizRepository) CreateAnswer(ctx context.Context, answer *model.UserQuestionAnswer) error {
	_, err := r.db.Exec(ctx,
		`INSERT INTO user_question_answers (id, attempt_id, question_id, user_answer, is_correct, time_spent_sec)
		 VALUES ($1, $2, $3, $4, $5, $6)`,
		answer.ID, answer.AttemptID, answer.QuestionID, answer.UserAnswer, answer.IsCorrect, answer.TimeSpentSec)
	return err
}
