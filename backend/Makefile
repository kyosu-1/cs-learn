.PHONY: run build test clean migrate-up migrate-down

run:
	go run ./cmd/server

build:
	go build -o bin/server ./cmd/server

test:
	go test ./...

clean:
	rm -rf bin/

migrate-up:
	migrate -path internal/db/migrations -database "$(DATABASE_URL)" up

migrate-down:
	migrate -path internal/db/migrations -database "$(DATABASE_URL)" down 1
