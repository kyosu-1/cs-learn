import { StyleSheet, Text, View, ScrollView } from 'react-native';

export default function PracticeScreen() {
  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>演習問題</Text>
        <Text style={styles.subtitle}>クイズや問題で知識を確認しましょう</Text>
      </View>

      <View style={styles.emptyState}>
        <Text style={styles.emptyIcon}>🧠</Text>
        <Text style={styles.emptyTitle}>まだ演習問題がありません</Text>
        <Text style={styles.emptyDescription}>
          まずは「学習」タブからレッスンを完了して、関連する演習問題を解放しましょう
        </Text>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa' },
  header: { padding: 24, paddingTop: 16 },
  title: { fontSize: 28, fontWeight: 'bold', color: '#1a1a2e' },
  subtitle: { fontSize: 16, color: '#666', marginTop: 4 },
  emptyState: { alignItems: 'center', padding: 40, marginTop: 40 },
  emptyIcon: { fontSize: 64 },
  emptyTitle: { fontSize: 18, fontWeight: '600', color: '#1a1a2e', marginTop: 16 },
  emptyDescription: { fontSize: 14, color: '#666', textAlign: 'center', marginTop: 8, lineHeight: 22 },
});
