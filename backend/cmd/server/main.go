package main

import (
	"context"
	"log"
	"net/http"

	"github.com/kyosu-1/cs-learn/backend/internal/config"
	"github.com/kyosu-1/cs-learn/backend/internal/db"
	"github.com/kyosu-1/cs-learn/backend/internal/router"
)

func main() {
	cfg := config.Load()

	ctx := context.Background()
	pool, err := db.Connect(ctx, cfg.DatabaseURL)
	if err != nil {
		log.Printf("Warning: could not connect to database: %v", err)
	} else {
		defer pool.Close()
		log.Println("Connected to database")
	}

	r := router.New()

	log.Printf("Server starting on :%s", cfg.Port)
	if err := http.ListenAndServe(":"+cfg.Port, r); err != nil {
		log.Fatal(err)
	}
}
