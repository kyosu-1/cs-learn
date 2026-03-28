package handler

import (
	"encoding/json"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
	"github.com/kyosu-1/cs-learn/backend/internal/service"
)

type ProgressHandler struct {
	progressSvc *service.ProgressService
}

func NewProgressHandler(progressSvc *service.ProgressService) *ProgressHandler {
	return &ProgressHandler{progressSvc: progressSvc}
}

func (h *ProgressHandler) GetDashboard(w http.ResponseWriter, r *http.Request) {
	userID := GetUserID(r.Context())
	data, err := h.progressSvc.GetDashboard(r.Context(), userID)
	if err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to get dashboard")
		return
	}
	JSON(w, http.StatusOK, data)
}

func (h *ProgressHandler) UpdateLessonProgress(w http.ResponseWriter, r *http.Request) {
	userID := GetUserID(r.Context())
	lessonID, err := uuid.Parse(chi.URLParam(r, "lessonID"))
	if err != nil {
		JSONError(w, http.StatusBadRequest, "invalid lesson ID")
		return
	}

	var input service.UpdateLessonProgressInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		JSONError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	if err := h.progressSvc.UpdateLessonProgress(r.Context(), userID, lessonID, input); err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to update progress")
		return
	}

	JSON(w, http.StatusOK, map[string]string{"status": "ok"})
}

func (h *ProgressHandler) GetWeaknesses(w http.ResponseWriter, r *http.Request) {
	userID := GetUserID(r.Context())
	stats, err := h.progressSvc.GetWeaknesses(r.Context(), userID)
	if err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to get weaknesses")
		return
	}
	JSON(w, http.StatusOK, stats)
}

func (h *ProgressHandler) GetRecentActivity(w http.ResponseWriter, r *http.Request) {
	userID := GetUserID(r.Context())
	events, err := h.progressSvc.GetRecentActivity(r.Context(), userID)
	if err != nil {
		JSONError(w, http.StatusInternalServerError, "failed to get activity")
		return
	}
	JSON(w, http.StatusOK, events)
}
