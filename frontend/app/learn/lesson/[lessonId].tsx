import { StyleSheet, View, ScrollView, ActivityIndicator, Text } from 'react-native';
import { useLocalSearchParams } from 'expo-router';
import { useLesson, useLessonBlocks } from '@/hooks/useContent';
import ContentRenderer from '@/components/lesson/ContentRenderer';

export default function LessonViewerScreen() {
  const { lessonId } = useLocalSearchParams<{ lessonId: string }>();
  const { data: lesson } = useLesson(lessonId);
  const { data: blocks, isLoading } = useLessonBlocks(lessonId);

  if (isLoading) {
    return (
      <View style={[styles.container, { justifyContent: 'center', alignItems: 'center' }]}>
        <ActivityIndicator size="large" color="#4361ee" />
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      <View style={styles.content}>
        {blocks && blocks.length > 0 ? (
          <ContentRenderer blocks={blocks} />
        ) : (
          <Text style={styles.emptyText}>コンテンツがありません</Text>
        )}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff' },
  content: { padding: 20, paddingBottom: 40 },
  emptyText: { fontSize: 16, color: '#999', textAlign: 'center', marginTop: 40 },
});
