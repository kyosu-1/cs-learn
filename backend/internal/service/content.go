package service

import (
	"context"

	"github.com/google/uuid"
	"github.com/kyosu-1/cs-learn/backend/internal/model"
	"github.com/kyosu-1/cs-learn/backend/internal/repository"
)

type ContentService struct {
	repo *repository.ContentRepository
}

func NewContentService(repo *repository.ContentRepository) *ContentService {
	return &ContentService{repo: repo}
}

func (s *ContentService) ListTopics(ctx context.Context) ([]model.Topic, error) {
	return s.repo.ListTopics(ctx)
}

func (s *ContentService) GetTopicBySlug(ctx context.Context, slug string) (*model.Topic, error) {
	return s.repo.GetTopicBySlug(ctx, slug)
}

func (s *ContentService) ListCategories(ctx context.Context, topicID uuid.UUID) ([]model.Category, error) {
	return s.repo.ListCategories(ctx, topicID)
}

func (s *ContentService) ListLessons(ctx context.Context, categoryID uuid.UUID) ([]model.Lesson, error) {
	return s.repo.ListLessons(ctx, categoryID)
}

func (s *ContentService) GetLesson(ctx context.Context, id uuid.UUID) (*model.Lesson, error) {
	return s.repo.GetLesson(ctx, id)
}

func (s *ContentService) GetLessonBlocks(ctx context.Context, lessonID uuid.UUID) ([]model.LessonBlock, error) {
	return s.repo.GetLessonBlocks(ctx, lessonID)
}
