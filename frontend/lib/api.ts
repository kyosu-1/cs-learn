import { Platform } from 'react-native';

const BASE_URL = Platform.select({
  web: 'http://localhost:8080',
  default: 'http://localhost:8080',
});

type RequestOptions = {
  method?: string;
  body?: unknown;
  token?: string | null;
};

export async function apiClient<T>(path: string, options: RequestOptions = {}): Promise<T> {
  const { method = 'GET', body, token } = options;

  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
  };

  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }

  const response = await fetch(`${BASE_URL}/api/v1${path}`, {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined,
  });

  const json = await response.json();

  if (!response.ok) {
    throw new Error(json.error || 'An error occurred');
  }

  return json.data as T;
}
