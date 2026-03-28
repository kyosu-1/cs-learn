import { StyleSheet, Text, View, ScrollView, TouchableOpacity } from 'react-native';
import { Link } from 'expo-router';
import { useAuthStore } from '@/stores/authStore';

export default function HomeScreen() {
  const { user, isAuthenticated } = useAuthStore();

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.greeting}>
          {isAuthenticated ? `${user?.display_name} さん、おかえり` : 'CS Learn へようこそ'}
        </Text>
        <Text style={styles.subtitle}>コンピューターサイエンスを体系的に学ぼう</Text>
      </View>

      {!isAuthenticated && (
        <View style={styles.authPrompt}>
          <Text style={styles.authPromptText}>ログインして学習進捗を記録しましょう</Text>
          <Link href="/(auth)/login" asChild>
            <TouchableOpacity style={styles.authButton}>
              <Text style={styles.authButtonText}>ログイン / 登録</Text>
            </TouchableOpacity>
          </Link>
        </View>
      )}

      <View style={styles.statsCard}>
        <Text style={styles.statsTitle}>学習状況</Text>
        <View style={styles.statsRow}>
          <View style={styles.statItem}>
            <Text style={styles.statNumber}>{user?.level ?? 1}</Text>
            <Text style={styles.statLabel}>レベル</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={styles.statNumber}>{user?.xp ?? 0}</Text>
            <Text style={styles.statLabel}>XP</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={styles.statNumber}>0</Text>
            <Text style={styles.statLabel}>完了レッスン</Text>
          </View>
        </View>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>おすすめ</Text>
        <View style={styles.card}>
          <Text style={styles.cardTitle}>アルゴリズム & データ構造</Text>
          <Text style={styles.cardDescription}>
            ソート、探索、木構造、グラフなど基本的なアルゴリズムとデータ構造を学びます
          </Text>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa' },
  header: { padding: 24, paddingTop: 16 },
  greeting: { fontSize: 28, fontWeight: 'bold', color: '#1a1a2e' },
  subtitle: { fontSize: 16, color: '#666', marginTop: 4 },
  authPrompt: {
    margin: 16,
    marginTop: 0,
    padding: 20,
    backgroundColor: '#fff3cd',
    borderRadius: 12,
    alignItems: 'center',
  },
  authPromptText: { fontSize: 14, color: '#856404', marginBottom: 12 },
  authButton: {
    backgroundColor: '#4361ee',
    paddingHorizontal: 24,
    paddingVertical: 10,
    borderRadius: 8,
  },
  authButtonText: { color: '#fff', fontWeight: '600' },
  statsCard: {
    margin: 16,
    padding: 20,
    backgroundColor: '#fff',
    borderRadius: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 4,
  },
  statsTitle: { fontSize: 18, fontWeight: '600', marginBottom: 16 },
  statsRow: { flexDirection: 'row', justifyContent: 'space-around' },
  statItem: { alignItems: 'center' },
  statNumber: { fontSize: 32, fontWeight: 'bold', color: '#4361ee' },
  statLabel: { fontSize: 12, color: '#666', marginTop: 4 },
  section: { padding: 16 },
  sectionTitle: { fontSize: 20, fontWeight: '600', marginBottom: 12 },
  card: {
    padding: 20,
    backgroundColor: '#4361ee',
    borderRadius: 16,
  },
  cardTitle: { fontSize: 18, fontWeight: '600', color: '#fff' },
  cardDescription: { fontSize: 14, color: '#e0e0ff', marginTop: 8 },
});
