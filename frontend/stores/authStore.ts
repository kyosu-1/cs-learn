import { create } from 'zustand';
import type { User } from '@/lib/types';
import { saveTokens, clearTokens, getAccessToken } from '@/lib/auth';
import { apiClient } from '@/lib/api';

type AuthState = {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  setAuth: (user: User, token: string, refreshToken: string) => Promise<void>;
  logout: () => Promise<void>;
  restore: () => Promise<void>;
};

export const useAuthStore = create<AuthState>((set, get) => ({
  user: null,
  token: null,
  isAuthenticated: false,
  isLoading: true,

  setAuth: async (user, token, refreshToken) => {
    await saveTokens(token, refreshToken);
    set({ user, token, isAuthenticated: true });
  },

  logout: async () => {
    await clearTokens();
    set({ user: null, token: null, isAuthenticated: false });
  },

  restore: async () => {
    try {
      const token = await getAccessToken();
      if (!token) {
        set({ isLoading: false });
        return;
      }
      const user = await apiClient<User>('/me', { token });
      set({ user, token, isAuthenticated: true, isLoading: false });
    } catch {
      await clearTokens();
      set({ isLoading: false });
    }
  },
}));
