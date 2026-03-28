package router

import (
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	"github.com/kyosu-1/cs-learn/backend/internal/handler"
	"github.com/kyosu-1/cs-learn/backend/internal/service"
)

type Services struct {
	Auth    *service.AuthService
	Content *service.ContentService
	Quiz    *service.QuizService
}

func New(svc *Services) *chi.Mux {
	r := chi.NewRouter()

	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.RequestID)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	authHandler := handler.NewAuthHandler(svc.Auth)
	contentHandler := handler.NewContentHandler(svc.Content)
	quizHandler := handler.NewQuizHandler(svc.Quiz)

	r.Route("/api/v1", func(r chi.Router) {
		r.Get("/health", handler.HealthCheck)

		// Public auth routes
		r.Route("/auth", func(r chi.Router) {
			r.Post("/register", authHandler.Register)
			r.Post("/login", authHandler.Login)
			r.Post("/refresh", authHandler.Refresh)
		})

		// Public content routes
		r.Route("/topics", func(r chi.Router) {
			r.Get("/", contentHandler.ListTopics)
			r.Get("/{slug}", contentHandler.GetTopic)
			r.Get("/{slug}/categories", contentHandler.ListCategories)
		})
		r.Get("/categories/{categoryID}/lessons", contentHandler.ListLessons)
		r.Get("/categories/{categoryID}/quizzes", quizHandler.ListByCategory)
		r.Route("/quizzes/{quizID}", func(r chi.Router) {
			r.Get("/", quizHandler.GetQuiz)
		})
		r.Route("/lessons/{lessonID}", func(r chi.Router) {
			r.Get("/", contentHandler.GetLesson)
			r.Get("/blocks", contentHandler.GetLessonBlocks)
		})

		// Protected routes
		r.Group(func(r chi.Router) {
			r.Use(handler.AuthMiddleware(svc.Auth))
			r.Get("/me", authHandler.Me)
			r.Post("/quizzes/{quizID}/submit", quizHandler.Submit)
		})
	})

	return r
}
