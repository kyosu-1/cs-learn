import { StyleSheet, Text, View, ScrollView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { useLocalSearchParams, router } from 'expo-router';
import { useCategories, useLessons } from '@/hooks/useContent';
import { useState } from 'react';

const difficultyLabels: Record<number, string> = {
  1: '初級',
  2: '中級',
  3: '上級',
  4: '大学院',
};

const difficultyColors: Record<number, string> = {
  1: '#4caf50',
  2: '#2196f3',
  3: '#ff9800',
  4: '#e91e63',
};

function CategorySection({ category }: { category: { id: string; title: string; description: string | null } }) {
  const { data: lessons, isLoading } = useLessons(category.id);
  const [expanded, setExpanded] = useState(true);

  return (
    <View style={styles.categorySection}>
      <TouchableOpacity style={styles.categoryHeader} onPress={() => setExpanded(!expanded)}>
        <Text style={styles.categoryTitle}>{category.title}</Text>
        <Text style={styles.expandIcon}>{expanded ? '▼' : '▶'}</Text>
      </TouchableOpacity>
      {category.description && (
        <Text style={styles.categoryDescription}>{category.description}</Text>
      )}

      {expanded && (
        <View style={styles.lessonList}>
          {isLoading && <ActivityIndicator color="#4361ee" />}
          {lessons?.map((lesson) => (
            <TouchableOpacity
              key={lesson.id}
              style={styles.lessonCard}
              onPress={() => router.push(`/learn/lesson/${lesson.id}`)}
            >
              <View style={styles.lessonInfo}>
                <Text style={styles.lessonTitle}>{lesson.title}</Text>
                {lesson.summary && (
                  <Text style={styles.lessonSummary}>{lesson.summary}</Text>
                )}
              </View>
              <View style={styles.lessonMeta}>
                <View style={[styles.difficultyBadge, { backgroundColor: difficultyColors[lesson.difficulty_level] + '20' }]}>
                  <Text style={[styles.difficultyText, { color: difficultyColors[lesson.difficulty_level] }]}>
                    {difficultyLabels[lesson.difficulty_level]}
                  </Text>
                </View>
                {lesson.estimated_minutes && (
                  <Text style={styles.time}>{lesson.estimated_minutes}分</Text>
                )}
              </View>
            </TouchableOpacity>
          ))}
          {lessons?.length === 0 && (
            <Text style={styles.emptyText}>レッスンはまだありません</Text>
          )}
        </View>
      )}
    </View>
  );
}

export default function TopicDetailScreen() {
  const { topicSlug } = useLocalSearchParams<{ topicSlug: string }>();
  const { data: categories, isLoading } = useCategories(topicSlug);

  if (isLoading) {
    return (
      <View style={[styles.container, { justifyContent: 'center', alignItems: 'center' }]}>
        <ActivityIndicator size="large" color="#4361ee" />
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      {categories?.map((category) => (
        <CategorySection key={category.id} category={category} />
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa' },
  categorySection: { marginBottom: 8 },
  categoryHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
    paddingBottom: 4,
  },
  categoryTitle: { fontSize: 20, fontWeight: '600', color: '#1a1a2e' },
  expandIcon: { fontSize: 14, color: '#666' },
  categoryDescription: { fontSize: 14, color: '#666', paddingHorizontal: 16, marginBottom: 8 },
  lessonList: { paddingHorizontal: 16, gap: 8 },
  lessonCard: {
    backgroundColor: '#fff',
    borderRadius: 12,
    padding: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 2,
  },
  lessonInfo: { marginBottom: 8 },
  lessonTitle: { fontSize: 16, fontWeight: '600', color: '#1a1a2e' },
  lessonSummary: { fontSize: 14, color: '#666', marginTop: 4 },
  lessonMeta: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  difficultyBadge: { paddingHorizontal: 8, paddingVertical: 2, borderRadius: 4 },
  difficultyText: { fontSize: 12, fontWeight: '600' },
  time: { fontSize: 12, color: '#999' },
  emptyText: { fontSize: 14, color: '#999', textAlign: 'center', padding: 20 },
});
