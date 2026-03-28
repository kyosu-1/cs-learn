package handler

import (
	"encoding/json"
	"errors"
	"net/http"

	"github.com/kyosu-1/cs-learn/backend/internal/service"
)

type AuthHandler struct {
	authSvc *service.AuthService
}

func NewAuthHandler(authSvc *service.AuthService) *AuthHandler {
	return &AuthHandler{authSvc: authSvc}
}

func (h *AuthHandler) Register(w http.ResponseWriter, r *http.Request) {
	var input service.RegisterInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		JSONError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	if input.Email == "" || input.Password == "" || input.DisplayName == "" {
		JSONError(w, http.StatusBadRequest, "email, password, and display_name are required")
		return
	}

	if len(input.Password) < 8 {
		JSONError(w, http.StatusBadRequest, "password must be at least 8 characters")
		return
	}

	user, tokens, err := h.authSvc.Register(r.Context(), input)
	if err != nil {
		if errors.Is(err, service.ErrEmailAlreadyExists) {
			JSONError(w, http.StatusConflict, "email already exists")
			return
		}
		JSONError(w, http.StatusInternalServerError, "failed to register")
		return
	}

	JSON(w, http.StatusCreated, map[string]any{
		"user":   user,
		"tokens": tokens,
	})
}

func (h *AuthHandler) Login(w http.ResponseWriter, r *http.Request) {
	var input service.LoginInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		JSONError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	if input.Email == "" || input.Password == "" {
		JSONError(w, http.StatusBadRequest, "email and password are required")
		return
	}

	user, tokens, err := h.authSvc.Login(r.Context(), input)
	if err != nil {
		if errors.Is(err, service.ErrInvalidCredentials) {
			JSONError(w, http.StatusUnauthorized, "invalid email or password")
			return
		}
		JSONError(w, http.StatusInternalServerError, "failed to login")
		return
	}

	JSON(w, http.StatusOK, map[string]any{
		"user":   user,
		"tokens": tokens,
	})
}

func (h *AuthHandler) Refresh(w http.ResponseWriter, r *http.Request) {
	var body struct {
		RefreshToken string `json:"refresh_token"`
	}
	if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
		JSONError(w, http.StatusBadRequest, "invalid request body")
		return
	}

	tokens, err := h.authSvc.RefreshToken(r.Context(), body.RefreshToken)
	if err != nil {
		JSONError(w, http.StatusUnauthorized, "invalid refresh token")
		return
	}

	JSON(w, http.StatusOK, tokens)
}

func (h *AuthHandler) Me(w http.ResponseWriter, r *http.Request) {
	userID := GetUserID(r.Context())
	user, err := h.authSvc.GetUser(r.Context(), userID)
	if err != nil {
		JSONError(w, http.StatusNotFound, "user not found")
		return
	}
	JSON(w, http.StatusOK, user)
}
