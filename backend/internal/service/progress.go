package service

import (
	"context"
	"errors"
	"math"
	"time"

	"github.com/google/uuid"
	"github.com/kyosu-1/cs-learn/backend/internal/model"
	"github.com/kyosu-1/cs-learn/backend/internal/repository"
)

type ProgressService struct {
	progressRepo *repository.ProgressRepository
	userRepo     *repository.UserRepository
}

func NewProgressService(progressRepo *repository.ProgressRepository, userRepo *repository.UserRepository) *ProgressService {
	return &ProgressService{progressRepo: progressRepo, userRepo: userRepo}
}

type DashboardData struct {
	Level           int     `json:"level"`
	XP              int     `json:"xp"`
	XPForNextLevel  int     `json:"xp_for_next_level"`
	CompletedLessons int    `json:"completed_lessons"`
	QuizAttempts    int     `json:"quiz_attempts"`
	Accuracy        float64 `json:"accuracy"`
}

func (s *ProgressService) GetDashboard(ctx context.Context, userID uuid.UUID) (*DashboardData, error) {
	user, err := s.userRepo.GetByID(ctx, userID)
	if err != nil {
		return nil, err
	}

	completedLessons, _ := s.progressRepo.CountCompletedLessons(ctx, userID)
	quizAttempts, _ := s.progressRepo.CountQuizAttempts(ctx, userID)
	accuracy, _ := s.progressRepo.GetOverallAccuracy(ctx, userID)

	return &DashboardData{
		Level:           user.Level,
		XP:              user.XP,
		XPForNextLevel:  user.Level * 100,
		CompletedLessons: completedLessons,
		QuizAttempts:    quizAttempts,
		Accuracy:        math.Round(accuracy*1000) / 10,
	}, nil
}

type UpdateLessonProgressInput struct {
	Status         string `json:"status"`
	LastBlockIndex int    `json:"last_block_index"`
}

func (s *ProgressService) UpdateLessonProgress(ctx context.Context, userID, lessonID uuid.UUID, input UpdateLessonProgressInput) error {
	existing, err := s.progressRepo.GetLessonProgress(ctx, userID, lessonID)
	if err != nil && !errors.Is(err, repository.ErrNotFound) {
		return err
	}

	var id uuid.UUID
	if existing != nil {
		id = existing.ID
	} else {
		id = uuid.New()
	}

	p := &model.UserLessonProgress{
		ID:             id,
		UserID:         userID,
		LessonID:       lessonID,
		Status:         input.Status,
		LastBlockIndex: input.LastBlockIndex,
	}

	if input.Status == "completed" {
		now := time.Now()
		p.CompletedAt = &now

		// Award XP if newly completed
		if existing == nil || existing.Status != "completed" {
			xpAmount := 25
			evt := &model.XPEvent{
				ID:          uuid.New(),
				UserID:      userID,
				EventType:   "lesson_complete",
				XPAmount:    xpAmount,
				ReferenceID: &lessonID,
			}
			_ = s.progressRepo.AddXPEvent(ctx, evt)

			user, err := s.userRepo.GetByID(ctx, userID)
			if err == nil {
				newXP := user.XP + xpAmount
				newLevel := int(math.Floor(math.Sqrt(float64(newXP)/100))) + 1
				_ = s.userRepo.UpdateXP(ctx, userID, newXP, newLevel)
			}
		}
	}

	return s.progressRepo.UpsertLessonProgress(ctx, p)
}

func (s *ProgressService) GetWeaknesses(ctx context.Context, userID uuid.UUID) ([]model.UserCategoryStats, error) {
	return s.progressRepo.GetCategoryStats(ctx, userID)
}

func (s *ProgressService) GetRecentActivity(ctx context.Context, userID uuid.UUID) ([]model.XPEvent, error) {
	return s.progressRepo.GetRecentXPEvents(ctx, userID, 20)
}
