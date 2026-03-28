import { StyleSheet, Text, View, ScrollView } from 'react-native';

export default function VisualizeScreen() {
  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>アルゴリズム可視化</Text>
        <Text style={styles.subtitle}>アルゴリズムの動作をアニメーションで理解しよう</Text>
      </View>

      <View style={styles.emptyState}>
        <Text style={styles.emptyIcon}>▶️</Text>
        <Text style={styles.emptyTitle}>準備中</Text>
        <Text style={styles.emptyDescription}>
          ソートアルゴリズム、木の走査、グラフ探索などのインタラクティブな可視化を近日公開予定
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
