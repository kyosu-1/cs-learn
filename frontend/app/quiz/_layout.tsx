import { Stack } from 'expo-router';

export default function QuizLayout() {
  return (
    <Stack>
      <Stack.Screen name="[quizId]" options={{ headerTitle: 'クイズ' }} />
    </Stack>
  );
}
