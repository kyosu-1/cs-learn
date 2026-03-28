import { StyleSheet, Text, View, ScrollView } from 'react-native';

export default function ProfileScreen() {
  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>👤</Text>
        </View>
        <Text style={styles.name}>ゲスト</Text>
        <Text style={styles.level}>レベル 1</Text>
      </View>

      <View style={styles.xpCard}>
        <Text style={styles.xpLabel}>経験値</Text>
        <View style={styles.xpBar}>
          <View style={[styles.xpFill, { width: '0%' }]} />
        </View>
        <Text style={styles.xpText}>0 / 100 XP</Text>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>学習統計</Text>
        <View style={styles.statsGrid}>
          <View style={styles.statCard}>
            <Text style={styles.statNumber}>0</Text>
            <Text style={styles.statLabel}>完了レッスン</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statNumber}>0</Text>
            <Text style={styles.statLabel}>クイズ回答数</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statNumber}>0%</Text>
            <Text style={styles.statLabel}>正答率</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statNumber}>0</Text>
            <Text style={styles.statLabel}>連続学習日数</Text>
          </View>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa' },
  header: { alignItems: 'center', padding: 24, paddingTop: 16 },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: '#e8edff',
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarText: { fontSize: 40 },
  name: { fontSize: 24, fontWeight: 'bold', color: '#1a1a2e', marginTop: 12 },
  level: { fontSize: 16, color: '#4361ee', fontWeight: '600', marginTop: 4 },
  xpCard: {
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
  xpLabel: { fontSize: 14, color: '#666', marginBottom: 8 },
  xpBar: {
    height: 8,
    backgroundColor: '#e9ecef',
    borderRadius: 4,
    overflow: 'hidden',
  },
  xpFill: { height: '100%', backgroundColor: '#4361ee', borderRadius: 4 },
  xpText: { fontSize: 12, color: '#666', marginTop: 8, textAlign: 'right' },
  section: { padding: 16 },
  sectionTitle: { fontSize: 20, fontWeight: '600', marginBottom: 12 },
  statsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  statCard: {
    width: '47%',
    padding: 16,
    backgroundColor: '#fff',
    borderRadius: 12,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 2,
  },
  statNumber: { fontSize: 28, fontWeight: 'bold', color: '#4361ee' },
  statLabel: { fontSize: 12, color: '#666', marginTop: 4 },
});
