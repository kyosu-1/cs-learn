package main

import (
	"context"
	"log"
	"net/http"

	"github.com/kyosu-1/cs-learn/backend/internal/config"
	"github.com/kyosu-1/cs-learn/backend/internal/db"
	"github.com/kyosu-1/cs-learn/backend/internal/repository"
	"github.com/kyosu-1/cs-learn/backend/internal/router"
	"github.com/kyosu-1/cs-learn/backend/internal/service"
)

func main() {
	cfg := config.Load()

	ctx := context.Background()
	pool, err := db.Connect(ctx, cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer pool.Close()
	log.Println("Connected to database")

	// Repositories
	userRepo := repository.NewUserRepository(pool)
	contentRepo := repository.NewContentRepository(pool)
	quizRepo := repository.NewQuizRepository(pool)

	// Services
	authSvc := service.NewAuthService(userRepo, cfg.JWTSecret)
	contentSvc := service.NewContentService(contentRepo)
	quizSvc := service.NewQuizService(quizRepo)

	// Router
	r := router.New(&router.Services{
		Auth:    authSvc,
		Content: contentSvc,
		Quiz:    quizSvc,
	})

	log.Printf("Server starting on :%s", cfg.Port)
	if err := http.ListenAndServe(":"+cfg.Port, r); err != nil {
		log.Fatal(err)
	}
}
