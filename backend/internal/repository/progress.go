package repository

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/kyosu-1/cs-learn/backend/internal/model"
)

type ProgressRepository struct {
	db *pgxpool.Pool
}

func NewProgressRepository(db *pgxpool.Pool) *ProgressRepository {
	return &ProgressRepository{db: db}
}

func (r *ProgressRepository) GetLessonProgress(ctx context.Context, userID, lessonID uuid.UUID) (*model.UserLessonProgress, error) {
	p := &model.UserLessonProgress{}
	err := r.db.QueryRow(ctx,
		`SELECT id, user_id, lesson_id, status, last_block_index, completed_at, created_at, updated_at
		 FROM user_lesson_progress WHERE user_id = $1 AND lesson_id = $2`, userID, lessonID,
	).Scan(&p.ID, &p.UserID, &p.LessonID, &p.Status, &p.LastBlockIndex, &p.CompletedAt, &p.CreatedAt, &p.UpdatedAt)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}
	return p, nil
}

func (r *ProgressRepository) UpsertLessonProgress(ctx context.Context, p *model.UserLessonProgress) error {
	_, err := r.db.Exec(ctx,
		`INSERT INTO user_lesson_progress (id, user_id, lesson_id, status, last_block_index, completed_at)
		 VALUES ($1, $2, $3, $4, $5, $6)
		 ON CONFLICT (user_id, lesson_id) DO UPDATE SET
		   status = EXCLUDED.status,
		   last_block_index = EXCLUDED.last_block_index,
		   completed_at = EXCLUDED.completed_at,
		   updated_at = now()`,
		p.ID, p.UserID, p.LessonID, p.Status, p.LastBlockIndex, p.CompletedAt)
	return err
}

func (r *ProgressRepository) CountCompletedLessons(ctx context.Context, userID uuid.UUID) (int, error) {
	var count int
	err := r.db.QueryRow(ctx,
		`SELECT COUNT(*) FROM user_lesson_progress WHERE user_id = $1 AND status = 'completed'`, userID,
	).Scan(&count)
	return count, err
}

func (r *ProgressRepository) CountQuizAttempts(ctx context.Context, userID uuid.UUID) (int, error) {
	var count int
	err := r.db.QueryRow(ctx,
		`SELECT COUNT(*) FROM user_quiz_attempts WHERE user_id = $1`, userID,
	).Scan(&count)
	return count, err
}

func (r *ProgressRepository) GetOverallAccuracy(ctx context.Context, userID uuid.UUID) (float64, error) {
	var accuracy float64
	err := r.db.QueryRow(ctx,
		`SELECT COALESCE(
		   CAST(SUM(CASE WHEN is_correct THEN 1 ELSE 0 END) AS FLOAT) /
		   NULLIF(COUNT(*), 0), 0)
		 FROM user_question_answers a
		 JOIN user_quiz_attempts att ON a.attempt_id = att.id
		 WHERE att.user_id = $1`, userID,
	).Scan(&accuracy)
	return accuracy, err
}

func (r *ProgressRepository) GetCategoryStats(ctx context.Context, userID uuid.UUID) ([]model.UserCategoryStats, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, user_id, category_id, total_questions, correct_answers, accuracy, updated_at
		 FROM user_category_stats WHERE user_id = $1 ORDER BY accuracy ASC`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var stats []model.UserCategoryStats
	for rows.Next() {
		var s model.UserCategoryStats
		if err := rows.Scan(&s.ID, &s.UserID, &s.CategoryID, &s.TotalQuestions, &s.CorrectAnswers, &s.Accuracy, &s.UpdatedAt); err != nil {
			return nil, err
		}
		stats = append(stats, s)
	}
	return stats, nil
}

func (r *ProgressRepository) AddXPEvent(ctx context.Context, evt *model.XPEvent) error {
	_, err := r.db.Exec(ctx,
		`INSERT INTO xp_events (id, user_id, event_type, xp_amount, reference_id) VALUES ($1, $2, $3, $4, $5)`,
		evt.ID, evt.UserID, evt.EventType, evt.XPAmount, evt.ReferenceID)
	return err
}

func (r *ProgressRepository) GetRecentXPEvents(ctx context.Context, userID uuid.UUID, limit int) ([]model.XPEvent, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, user_id, event_type, xp_amount, reference_id, created_at
		 FROM xp_events WHERE user_id = $1 ORDER BY created_at DESC LIMIT $2`, userID, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var events []model.XPEvent
	for rows.Next() {
		var e model.XPEvent
		if err := rows.Scan(&e.ID, &e.UserID, &e.EventType, &e.XPAmount, &e.ReferenceID, &e.CreatedAt); err != nil {
			return nil, err
		}
		events = append(events, e)
	}
	return events, nil
}

func (r *ProgressRepository) GetLessonProgressList(ctx context.Context, userID uuid.UUID) ([]model.UserLessonProgress, error) {
	rows, err := r.db.Query(ctx,
		`SELECT id, user_id, lesson_id, status, last_block_index, completed_at, created_at, updated_at
		 FROM user_lesson_progress WHERE user_id = $1`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []model.UserLessonProgress
	for rows.Next() {
		var p model.UserLessonProgress
		if err := rows.Scan(&p.ID, &p.UserID, &p.LessonID, &p.Status, &p.LastBlockIndex, &p.CompletedAt, &p.CreatedAt, &p.UpdatedAt); err != nil {
			return nil, err
		}
		list = append(list, p)
	}
	return list, nil
}

// helper
func TimePtr(t time.Time) *time.Time { return &t }
