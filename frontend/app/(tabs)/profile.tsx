import { StyleSheet, Text, View, ScrollView, TouchableOpacity } from 'react-native';
import { Link, router } from 'expo-router';
import { useAuthStore } from '@/stores/authStore';
import { useDashboard } from '@/hooks/useProgress';

export default function ProfileScreen() {
  const { user, isAuthenticated, logout } = useAuthStore();
  const { data: dashboard } = useDashboard();

  const xpForNextLevel = dashboard?.xp_for_next_level ?? (user?.level ?? 1) * 100;
  const currentXP = dashboard?.xp ?? user?.xp ?? 0;
  const xpProgress = xpForNextLevel > 0 ? ((currentXP % 100) / xpForNextLevel) * 100 : 0;

  const handleLogout = async () => {
    await logout();
    router.replace('/(auth)/login');
  };

  if (!isAuthenticated) {
    return (
      <View style={[styles.container, { justifyContent: 'center', alignItems: 'center', padding: 24 }]}>
        <Text style={{ fontSize: 48, marginBottom: 16 }}>👤</Text>
        <Text style={{ fontSize: 20, fontWeight: '600', color: '#1a1a2e', marginBottom: 8 }}>
          ログインが必要です
        </Text>
        <Text style={{ fontSize: 14, color: '#666', textAlign: 'center', marginBottom: 24 }}>
          学習進捗を記録するにはアカウントが必要です
        </Text>
        <Link href="/(auth)/login" asChild>
          <TouchableOpacity style={styles.loginButton}>
            <Text style={styles.loginButtonText}>ログイン / 登録</Text>
          </TouchableOpacity>
        </Link>
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>
            {user?.display_name?.charAt(0)?.toUpperCase() ?? '?'}
          </Text>
        </View>
        <Text style={styles.name}>{user?.display_name}</Text>
        <Text style={styles.level}>レベル {dashboard?.level ?? user?.level}</Text>
      </View>

      <View style={styles.xpCard}>
        <Text style={styles.xpLabel}>経験値</Text>
        <View style={styles.xpBar}>
          <View style={[styles.xpFill, { width: `${xpProgress}%` }]} />
        </View>
        <Text style={styles.xpText}>{currentXP} / {xpForNextLevel} XP</Text>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>学習統計</Text>
        <View style={styles.statsGrid}>
          <View style={styles.statCard}>
            <Text style={styles.statNumber}>{dashboard?.completed_lessons ?? 0}</Text>
            <Text style={styles.statLabel}>完了レッスン</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statNumber}>{dashboard?.quiz_attempts ?? 0}</Text>
            <Text style={styles.statLabel}>クイズ回答数</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statNumber}>{dashboard?.accuracy ?? 0}%</Text>
            <Text style={styles.statLabel}>正答率</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statNumber}>{currentXP}</Text>
            <Text style={styles.statLabel}>総XP</Text>
          </View>
        </View>
      </View>

      <TouchableOpacity style={styles.logoutButton} onPress={handleLogout}>
        <Text style={styles.logoutText}>ログアウト</Text>
      </TouchableOpacity>
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
    backgroundColor: '#4361ee',
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarText: { fontSize: 32, color: '#fff', fontWeight: 'bold' },
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
  logoutButton: {
    margin: 16,
    padding: 16,
    backgroundColor: '#fff',
    borderRadius: 12,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#e74c3c',
  },
  logoutText: { color: '#e74c3c', fontSize: 16, fontWeight: '600' },
  loginButton: {
    backgroundColor: '#4361ee',
    paddingHorizontal: 32,
    paddingVertical: 14,
    borderRadius: 12,
  },
  loginButtonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
});
