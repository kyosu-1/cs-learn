import { Stack } from 'expo-router';

export default function LearnStackLayout() {
  return (
    <Stack>
      <Stack.Screen name="[topicSlug]" options={{ headerTitle: 'トピック' }} />
      <Stack.Screen name="lesson/[lessonId]" options={{ headerTitle: 'レッスン' }} />
    </Stack>
  );
}
