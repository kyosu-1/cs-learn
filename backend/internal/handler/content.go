package handler

import (
	"errors"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/kyosu-1/cs-learn/backend/internal/repository"
	"github.com/kyosu-1/cs-learn/backend/internal/service"
)

type ContentHandler struct {
	contentSvc *service.ContentService
}

func NewContentHandler(contentSvc *service.ContentService) *ContentHandler {
	return &ContentHandler{contentSvc: contentSvc}
}

func (h *ContentHandler) ListTopics(w http.ResponseWriter, r *http.Request) {
	topics, err := h.contentSvc.ListTopics(r.Context())
	if err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to list topics")
		return
	}
	JSON(w, http.StatusOK, topics)
}

func (h *ContentHandler) GetTopic(w http.ResponseWriter, r *http.Request) {
	slug := chi.URLParam(r, "slug")
	topic, err := h.contentSvc.GetTopicBySlug(r.Context(), slug)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			JSONError(w, http.StatusNotFound, "topic not found")
			return
		}
		JSONError(w, http.StatusInternalServerError, "failed to get topic")
		return
	}
	JSON(w, http.StatusOK, topic)
}

func (h *ContentHandler) ListCategories(w http.ResponseWriter, r *http.Request) {
	slug := chi.URLParam(r, "slug")
	topic, err := h.contentSvc.GetTopicBySlug(r.Context(), slug)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			JSONError(w, http.StatusNotFound, "topic not found")
			return
		}
		JSONError(w, http.StatusInternalServerError, "failed to get topic")
		return
	}

	categories, err := h.contentSvc.ListCategories(r.Context(), topic.ID)
	if err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to list categories")
		return
	}
	JSON(w, http.StatusOK, categories)
}

func (h *ContentHandler) ListLessons(w http.ResponseWriter, r *http.Request) {
	categoryID, err := uuid.Parse(chi.URLParam(r, "categoryID"))
	if err != nil {
		JSONError(w, http.StatusBadRequest, "invalid category ID")
		return
	}

	lessons, err := h.contentSvc.ListLessons(r.Context(), categoryID)
	if err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to list lessons")
		return
	}
	JSON(w, http.StatusOK, lessons)
}

func (h *ContentHandler) GetLesson(w http.ResponseWriter, r *http.Request) {
	lessonID, err := uuid.Parse(chi.URLParam(r, "lessonID"))
	if err != nil {
		JSONError(w, http.StatusBadRequest, "invalid lesson ID")
		return
	}

	lesson, err := h.contentSvc.GetLesson(r.Context(), lessonID)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			JSONError(w, http.StatusNotFound, "lesson not found")
			return
		}
		JSONError(w, http.StatusInternalServerError, "failed to get lesson")
		return
	}
	JSON(w, http.StatusOK, lesson)
}

func (h *ContentHandler) GetLessonBlocks(w http.ResponseWriter, r *http.Request) {
	lessonID, err := uuid.Parse(chi.URLParam(r, "lessonID"))
	if err != nil {
		JSONError(w, http.StatusBadRequest, "invalid lesson ID")
		return
	}

	blocks, err := h.contentSvc.GetLessonBlocks(r.Context(), lessonID)
	if err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to get lesson blocks")
		return
	}
	JSON(w, http.StatusOK, blocks)
}
