package handler

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/kyosu-1/cs-learn/backend/internal/repository"
	"github.com/kyosu-1/cs-learn/backend/internal/service"
)

type QuizHandler struct {
	quizSvc *service.QuizService
}

func NewQuizHandler(quizSvc *service.QuizService) *QuizHandler {
	return &QuizHandler{quizSvc: quizSvc}
}

func (h *QuizHandler) ListByCategory(w http.ResponseWriter, r *http.Request) {
	categoryID, err := uuid.Parse(chi.URLParam(r, "categoryID"))
	if err != nil {
		JSONError(w, http.StatusBadRequest, "invalid category ID")
		return
	}

	quizzes, err := h.quizSvc.ListByCategory(r.Context(), categoryID)
	if err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to list quizzes")
		return
	}
	JSON(w, http.StatusOK, quizzes)
}

func (h *QuizHandler) GetQuiz(w http.ResponseWriter, r *http.Request) {
	quizID, err := uuid.Parse(chi.URLParam(r, "quizID"))
	if err != nil {
		JSONError(w, http.StatusBadRequest, "invalid quiz ID")
		return
	}

	quiz, err := h.quizSvc.GetQuiz(r.Context(), quizID)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			JSONError(w, http.StatusNotFound, "quiz not found")
			return
		}
		JSONError(w, http.StatusInternalServerError, "failed to get quiz")
		return
	}

	questions, err := h.quizSvc.GetQuestions(r.Context(), quizID)
	if err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to get questions")
		return
	}

	JSON(w, http.StatusOK, map[string]any{
		"quiz":      quiz,
		"questions": questions,
	})
}

func (h *QuizHandler) Submit(w http.ResponseWriter, r *http.Request) {
	quizID, err := uuid.Parse(chi.URLParam(r, "quizID"))
	if err != nil {
		JSONError(w, http.StatusBadRequest, "invalid quiz ID")
		return
	}

	userID := GetUserID(r.Context())
	if userID == uuid.Nil {
		JSONError(w, http.StatusUnauthorized, "login required to submit quiz")
		return
	}

	var req service.SubmitRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		JSONError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	result, err := h.quizSvc.Submit(r.Context(), userID, quizID, req)
	if err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to submit quiz")
		return
	}

	JSON(w, http.StatusOK, result)
}
