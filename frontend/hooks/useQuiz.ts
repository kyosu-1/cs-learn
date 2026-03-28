import { useQuery } from '@tanstack/react-query';
import { apiClient } from '@/lib/api';
import type { Quiz, Question } from '@/lib/types';

export function useQuizzesByCategory(categoryId: string) {
  return useQuery({
    queryKey: ['quizzes', categoryId],
    queryFn: () => apiClient<Quiz[]>(`/categories/${categoryId}/quizzes`),
    enabled: !!categoryId,
  });
}

export function useQuiz(quizId: string) {
  return useQuery({
    queryKey: ['quiz', quizId],
    queryFn: () => apiClient<{ quiz: Quiz; questions: Question[] }>(`/quizzes/${quizId}`),
    enabled: !!quizId,
  });
}
