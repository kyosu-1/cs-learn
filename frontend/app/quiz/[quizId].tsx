import { useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { useLocalSearchParams, router } from 'expo-router';
import { useQuiz } from '@/hooks/useQuiz';
import { apiClient } from '@/lib/api';
import { useAuthStore } from '@/stores/authStore';
import MultipleChoice from '@/components/quiz/MultipleChoice';
import FillInBlank from '@/components/quiz/FillInBlank';
import type { Question } from '@/lib/types';

type QuestionResult = {
  question_id: string;
  is_correct: boolean;
  explanation: string | null;
  points: number;
};

type SubmitResponse = {
  attempt_id: string;
  score: number;
  max_score: number;
  results: QuestionResult[];
};

export default function QuizSessionScreen() {
  const { quizId } = useLocalSearchParams<{ quizId: string }>();
  const { data, isLoading } = useQuiz(quizId);
  const token = useAuthStore((s) => s.token);

  const [currentIndex, setCurrentIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, any>>({});
  const [submitted, setSubmitted] = useState(false);
  const [result, setResult] = useState<SubmitResponse | null>(null);
  const [submitting, setSubmitting] = useState(false);

  if (isLoading || !data) {
    return (
      <View style={[styles.container, { justifyContent: 'center', alignItems: 'center' }]}>
        <ActivityIndicator size="large" color="#4361ee" />
      </View>
    );
  }

  const { quiz, questions } = data;
  const question = questions[currentIndex];
  const isLast = currentIndex === questions.length - 1;
  const questionResult = result?.results.find((r) => r.question_id === question?.id);

  const setAnswer = (questionId: string, answer: any) => {
    setAnswers((prev) => ({ ...prev, [questionId]: answer }));
  };

  const handleSubmit = async () => {
    setSubmitting(true);
    try {
      const submitAnswers = questions.map((q) => ({
        question_id: q.id,
        answer: answers[q.id] || {},
      }));

      const res = await apiClient<SubmitResponse>(`/quizzes/${quizId}/submit`, {
        method: 'POST',
        body: { answers: submitAnswers },
        token,
      });
      setResult(res);
      setSubmitted(true);
      setCurrentIndex(0);
    } catch {
      // If not logged in, show local results
      setSubmitted(true);
    } finally {
      setSubmitting(false);
    }
  };

  if (submitted && result) {
    return (
      <ScrollView style={styles.container}>
        <View style={styles.resultCard}>
          <Text style={styles.resultTitle}>結果</Text>
          <Text style={styles.resultScore}>
            {result.score} / {result.max_score}
          </Text>
          <Text style={styles.resultPercent}>
            正答率: {Math.round((result.score / result.max_score) * 100)}%
          </Text>
        </View>

        {questions.map((q, i) => {
          const qr = result.results.find((r) => r.question_id === q.id);
          return (
            <View key={q.id} style={styles.resultQuestion}>
              <View style={styles.resultHeader}>
                <Text style={[styles.resultIcon, { color: qr?.is_correct ? '#4caf50' : '#e74c3c' }]}>
                  {qr?.is_correct ? '○' : '×'}
                </Text>
                <Text style={styles.resultPrompt}>Q{i + 1}. {q.prompt}</Text>
              </View>
              {qr?.explanation && (
                <Text style={styles.explanation}>{qr.explanation}</Text>
              )}
            </View>
          );
        })}

        <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
          <Text style={styles.backButtonText}>戻る</Text>
        </TouchableOpacity>
      </ScrollView>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.progressBar}>
        <View style={[styles.progressFill, { width: `${((currentIndex + 1) / questions.length) * 100}%` }]} />
      </View>

      <ScrollView style={styles.questionContainer}>
        <Text style={styles.questionNumber}>
          Q{currentIndex + 1} / {questions.length}
        </Text>
        <Text style={styles.prompt}>{question.prompt}</Text>

        <View style={styles.answerArea}>
          {(question.question_type === 'multiple_choice' || question.question_type === 'true_false') && (
            <MultipleChoice
              options={(question.options as any) || []}
              selected={answers[question.id]?.answer || null}
              onSelect={(id) => setAnswer(question.id, { answer: id })}
            />
          )}
          {question.question_type === 'fill_in_blank' && (
            <FillInBlank
              value={answers[question.id]?.answer || ''}
              onChange={(text) => setAnswer(question.id, { answer: text })}
            />
          )}
        </View>
      </ScrollView>

      <View style={styles.navigation}>
        {currentIndex > 0 && (
          <TouchableOpacity
            style={styles.navButton}
            onPress={() => setCurrentIndex(currentIndex - 1)}
          >
            <Text style={styles.navButtonText}>前へ</Text>
          </TouchableOpacity>
        )}
        <View style={{ flex: 1 }} />
        {isLast ? (
          <TouchableOpacity
            style={[styles.navButton, styles.submitButton]}
            onPress={handleSubmit}
            disabled={submitting}
          >
            {submitting ? (
              <ActivityIndicator color="#fff" />
            ) : (
              <Text style={styles.submitButtonText}>提出する</Text>
            )}
          </TouchableOpacity>
        ) : (
          <TouchableOpacity
            style={[styles.navButton, styles.nextButton]}
            onPress={() => setCurrentIndex(currentIndex + 1)}
          >
            <Text style={styles.nextButtonText}>次へ</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa' },
  progressBar: { height: 4, backgroundColor: '#e0e0e0' },
  progressFill: { height: '100%', backgroundColor: '#4361ee' },
  questionContainer: { flex: 1, padding: 20 },
  questionNumber: { fontSize: 14, color: '#999', fontWeight: '600', marginBottom: 8 },
  prompt: { fontSize: 20, fontWeight: '600', color: '#1a1a2e', lineHeight: 30, marginBottom: 24 },
  answerArea: { marginTop: 8 },
  navigation: {
    flexDirection: 'row',
    padding: 16,
    borderTopWidth: 1,
    borderTopColor: '#e0e0e0',
    backgroundColor: '#fff',
  },
  navButton: { paddingHorizontal: 24, paddingVertical: 12, borderRadius: 8 },
  navButtonText: { color: '#4361ee', fontSize: 16, fontWeight: '600' },
  nextButton: { backgroundColor: '#4361ee' },
  nextButtonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
  submitButton: { backgroundColor: '#4caf50' },
  submitButtonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
  // Result styles
  resultCard: {
    margin: 16,
    padding: 24,
    backgroundColor: '#fff',
    borderRadius: 16,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 4,
  },
  resultTitle: { fontSize: 16, color: '#666' },
  resultScore: { fontSize: 48, fontWeight: 'bold', color: '#4361ee', marginVertical: 8 },
  resultPercent: { fontSize: 18, color: '#333' },
  resultQuestion: {
    margin: 16,
    marginTop: 0,
    padding: 16,
    backgroundColor: '#fff',
    borderRadius: 12,
  },
  resultHeader: { flexDirection: 'row', alignItems: 'flex-start' },
  resultIcon: { fontSize: 20, fontWeight: 'bold', marginRight: 8, marginTop: 2 },
  resultPrompt: { fontSize: 15, color: '#333', flex: 1, lineHeight: 22 },
  explanation: { fontSize: 14, color: '#666', marginTop: 8, lineHeight: 22, paddingLeft: 28 },
  backButton: {
    margin: 16,
    padding: 16,
    backgroundColor: '#4361ee',
    borderRadius: 12,
    alignItems: 'center',
  },
  backButtonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
});
