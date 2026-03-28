import { StyleSheet, Text, View, ScrollView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useTopics, useCategories } from '@/hooks/useContent';
import { useQuizzesByCategory } from '@/hooks/useQuiz';
import type { Category, Topic } from '@/lib/types';

const difficultyLabels: Record<number, string> = { 1: '初級', 2: '中級', 3: '上級', 4: '大学院' };
const difficultyColors: Record<number, string> = { 1: '#4caf50', 2: '#2196f3', 3: '#ff9800', 4: '#e91e63' };

function CategoryQuizzes({ category }: { category: Category }) {
  const { data: quizzes, isLoading } = useQuizzesByCategory(category.id);

  if (isLoading) return <ActivityIndicator color="#4361ee" style={{ padding: 16 }} />;
  if (!quizzes || quizzes.length === 0) return null;

  return (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>{category.title}</Text>
      {quizzes.map((quiz) => (
        <TouchableOpacity
          key={quiz.id}
          style={styles.quizCard}
          onPress={() => router.push(`/quiz/${quiz.id}`)}
        >
          <Text style={styles.quizTitle}>{quiz.title}</Text>
          <View style={[styles.badge, { backgroundColor: difficultyColors[quiz.difficulty_level] + '20' }]}>
            <Text style={[styles.badgeText, { color: difficultyColors[quiz.difficulty_level] }]}>
              {difficultyLabels[quiz.difficulty_level]}
            </Text>
          </View>
        </TouchableOpacity>
      ))}
    </View>
  );
}

function TopicQuizzes({ topic }: { topic: Topic }) {
  const { data: categories } = useCategories(topic.slug);

  if (!categories || categories.length === 0) return null;

  return (
    <View>
      <Text style={styles.topicTitle}>{topic.title}</Text>
      {categories.map((category) => (
        <CategoryQuizzes key={category.id} category={category} />
      ))}
    </View>
  );
}

export default function PracticeScreen() {
  const { data: topics, isLoading } = useTopics();

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>演習問題</Text>
        <Text style={styles.subtitle}>クイズで知識を確認しましょう</Text>
      </View>

      {isLoading && <ActivityIndicator size="large" color="#4361ee" style={{ marginTop: 40 }} />}

      {topics?.map((topic) => (
        <TopicQuizzes key={topic.id} topic={topic} />
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa' },
  header: { padding: 24, paddingTop: 16 },
  title: { fontSize: 28, fontWeight: 'bold', color: '#1a1a2e' },
  subtitle: { fontSize: 16, color: '#666', marginTop: 4 },
  section: { marginBottom: 16 },
  sectionTitle: { fontSize: 18, fontWeight: '600', color: '#1a1a2e', paddingHorizontal: 16, marginBottom: 8 },
  quizCard: {
    marginHorizontal: 16,
    marginBottom: 8,
    padding: 16,
    backgroundColor: '#fff',
    borderRadius: 12,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 2,
  },
  quizTitle: { fontSize: 16, fontWeight: '500', color: '#1a1a2e', flex: 1 },
  badge: { paddingHorizontal: 10, paddingVertical: 4, borderRadius: 6, marginLeft: 8 },
  badgeText: { fontSize: 12, fontWeight: '600' },
  topicTitle: { fontSize: 22, fontWeight: 'bold', color: '#1a1a2e', paddingHorizontal: 16, paddingTop: 16, paddingBottom: 8 },
});
