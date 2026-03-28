package service

import (
	"context"
	"encoding/json"

	"github.com/google/uuid"
	"github.com/kyosu-1/cs-learn/backend/internal/model"
	"github.com/kyosu-1/cs-learn/backend/internal/repository"
)

type QuizService struct {
	quizRepo *repository.QuizRepository
}

func NewQuizService(quizRepo *repository.QuizRepository) *QuizService {
	return &QuizService{quizRepo: quizRepo}
}

func (s *QuizService) ListByCategory(ctx context.Context, categoryID uuid.UUID) ([]model.Quiz, error) {
	return s.quizRepo.ListByCategory(ctx, categoryID)
}

func (s *QuizService) GetQuiz(ctx context.Context, id uuid.UUID) (*model.Quiz, error) {
	return s.quizRepo.GetByID(ctx, id)
}

func (s *QuizService) GetQuestions(ctx context.Context, quizID uuid.UUID) ([]model.Question, error) {
	return s.quizRepo.GetQuestions(ctx, quizID)
}

type SubmitAnswer struct {
	QuestionID string          `json:"question_id"`
	Answer     json.RawMessage `json:"answer"`
}

type SubmitRequest struct {
	Answers      []SubmitAnswer `json:"answers"`
	TimeSpentSec *int           `json:"time_spent_sec"`
}

type QuestionResult struct {
	QuestionID  string  `json:"question_id"`
	IsCorrect   bool    `json:"is_correct"`
	Explanation *string `json:"explanation"`
	Points      int     `json:"points"`
}

type SubmitResponse struct {
	AttemptID string           `json:"attempt_id"`
	Score     int              `json:"score"`
	MaxScore  int              `json:"max_score"`
	Results   []QuestionResult `json:"results"`
}

func (s *QuizService) Submit(ctx context.Context, userID uuid.UUID, quizID uuid.UUID, req SubmitRequest) (*SubmitResponse, error) {
	questions, err := s.quizRepo.GetQuestions(ctx, quizID)
	if err != nil {
		return nil, err
	}

	questionMap := make(map[string]model.Question)
	for _, q := range questions {
		questionMap[q.ID.String()] = q
	}

	attemptID := uuid.New()
	var score, maxScore int
	var results []QuestionResult

	for _, ans := range req.Answers {
		q, ok := questionMap[ans.QuestionID]
		if !ok {
			continue
		}

		isCorrect := checkAnswer(q, ans.Answer)
		points := 0
		if isCorrect {
			points = q.Points
		}
		score += points
		maxScore += q.Points

		qID, _ := uuid.Parse(ans.QuestionID)
		answerRecord := &model.UserQuestionAnswer{
			ID:         uuid.New(),
			AttemptID:  attemptID,
			QuestionID: qID,
			UserAnswer: ans.Answer,
			IsCorrect:  isCorrect,
		}

		results = append(results, QuestionResult{
			QuestionID:  ans.QuestionID,
			IsCorrect:   isCorrect,
			Explanation: q.Explanation,
			Points:      points,
		})

		// Save answer (best effort for now)
		_ = s.quizRepo.CreateAnswer(ctx, answerRecord)
	}

	// Add points for unanswered questions to maxScore
	for _, q := range questions {
		found := false
		for _, ans := range req.Answers {
			if ans.QuestionID == q.ID.String() {
				found = true
				break
			}
		}
		if !found {
			maxScore += q.Points
		}
	}

	attempt := &model.UserQuizAttempt{
		ID:           attemptID,
		UserID:       userID,
		QuizID:       quizID,
		Score:        score,
		MaxScore:     maxScore,
		TimeSpentSec: req.TimeSpentSec,
	}
	_ = s.quizRepo.CreateAttempt(ctx, attempt)

	return &SubmitResponse{
		AttemptID: attemptID.String(),
		Score:     score,
		MaxScore:  maxScore,
		Results:   results,
	}, nil
}

func checkAnswer(q model.Question, userAnswer json.RawMessage) bool {
	switch q.QuestionType {
	case "multiple_choice":
		var correct struct {
			Answer string `json:"answer"`
		}
		var user struct {
			Answer string `json:"answer"`
		}
		json.Unmarshal(q.CorrectAnswer, &correct)
		json.Unmarshal(userAnswer, &user)
		return correct.Answer == user.Answer

	case "true_false":
		var correct struct {
			Answer bool `json:"answer"`
		}
		var user struct {
			Answer bool `json:"answer"`
		}
		json.Unmarshal(q.CorrectAnswer, &correct)
		json.Unmarshal(userAnswer, &user)
		return correct.Answer == user.Answer

	case "fill_in_blank":
		var correct struct {
			Answers []string `json:"answers"`
		}
		var user struct {
			Answer string `json:"answer"`
		}
		json.Unmarshal(q.CorrectAnswer, &correct)
		json.Unmarshal(userAnswer, &user)
		for _, a := range correct.Answers {
			if a == user.Answer {
				return true
			}
		}
		return false
	}
	return false
}
