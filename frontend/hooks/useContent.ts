import { useQuery } from '@tanstack/react-query';
import { apiClient } from '@/lib/api';
import type { Topic, Category, Lesson, LessonBlock } from '@/lib/types';

export function useTopics() {
  return useQuery({
    queryKey: ['topics'],
    queryFn: () => apiClient<Topic[]>('/topics'),
  });
}

export function useCategories(topicSlug: string) {
  return useQuery({
    queryKey: ['categories', topicSlug],
    queryFn: () => apiClient<Category[]>(`/topics/${topicSlug}/categories`),
    enabled: !!topicSlug,
  });
}

export function useLessons(categoryId: string) {
  return useQuery({
    queryKey: ['lessons', categoryId],
    queryFn: () => apiClient<Lesson[]>(`/categories/${categoryId}/lessons`),
    enabled: !!categoryId,
  });
}

export function useLesson(lessonId: string) {
  return useQuery({
    queryKey: ['lesson', lessonId],
    queryFn: () => apiClient<Lesson>(`/lessons/${lessonId}`),
    enabled: !!lessonId,
  });
}

export function useLessonBlocks(lessonId: string) {
  return useQuery({
    queryKey: ['lessonBlocks', lessonId],
    queryFn: () => apiClient<LessonBlock[]>(`/lessons/${lessonId}/blocks`),
    enabled: !!lessonId,
  });
}
