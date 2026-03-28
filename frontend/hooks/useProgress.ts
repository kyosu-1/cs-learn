import { useQuery } from '@tanstack/react-query';
import { apiClient } from '@/lib/api';
import { useAuthStore } from '@/stores/authStore';

export type DashboardData = {
  level: number;
  xp: number;
  xp_for_next_level: number;
  completed_lessons: number;
  quiz_attempts: number;
  accuracy: number;
};

export function useDashboard() {
  const { token, isAuthenticated } = useAuthStore();

  return useQuery({
    queryKey: ['dashboard'],
    queryFn: () => apiClient<DashboardData>('/me/progress', { token }),
    enabled: isAuthenticated,
  });
}
