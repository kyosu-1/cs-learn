import { StyleSheet, Text, View, ScrollView, TouchableOpacity, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useTopics } from '@/hooks/useContent';

const comingSoonTopics = [
  { title: 'オペレーティングシステム', description: 'プロセス管理、メモリ、ファイルシステム', icon: '⚙️' },
  { title: 'コンピュータネットワーク', description: 'TCP/IP、HTTP、DNS、ルーティング', icon: '🌐' },
  { title: 'コンピュータアーキテクチャ', description: 'CPU、メモリ階層、パイプライン', icon: '🖥️' },
];

export default function LearnScreen() {
  const { data: topics, isLoading } = useTopics();

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>学習トピック</Text>
        <Text style={styles.subtitle}>興味のある分野を選んで学習を始めましょう</Text>
      </View>

      {isLoading && (
        <ActivityIndicator size="large" color="#4361ee" style={{ marginTop: 40 }} />
      )}

      {topics?.map((topic) => (
        <TouchableOpacity
          key={topic.id}
          style={styles.topicCard}
          onPress={() => router.push(`/learn/${topic.slug}`)}
        >
          <View style={styles.topicHeader}>
            <Text style={styles.topicIcon}>🔢</Text>
            <View style={styles.topicInfo}>
              <Text style={styles.topicTitle}>{topic.title}</Text>
              <Text style={styles.topicDescription}>{topic.description}</Text>
            </View>
          </View>
        </TouchableOpacity>
      ))}

      {comingSoonTopics.map((topic, index) => (
        <TouchableOpacity key={index} style={[styles.topicCard, styles.comingSoon]} disabled>
          <View style={styles.topicHeader}>
            <Text style={styles.topicIcon}>{topic.icon}</Text>
            <View style={styles.topicInfo}>
              <Text style={styles.topicTitle}>{topic.title}</Text>
              <Text style={styles.topicDescription}>{topic.description}</Text>
            </View>
          </View>
          <View style={styles.comingSoonBadge}>
            <Text style={styles.comingSoonText}>Coming Soon</Text>
          </View>
        </TouchableOpacity>
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa' },
  header: { padding: 24, paddingTop: 16 },
  title: { fontSize: 28, fontWeight: 'bold', color: '#1a1a2e' },
  subtitle: { fontSize: 16, color: '#666', marginTop: 4 },
  topicCard: {
    margin: 16,
    marginTop: 0,
    padding: 20,
    backgroundColor: '#fff',
    borderRadius: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 4,
  },
  comingSoon: { opacity: 0.6 },
  topicHeader: { flexDirection: 'row', alignItems: 'center' },
  topicIcon: { fontSize: 40, marginRight: 16 },
  topicInfo: { flex: 1 },
  topicTitle: { fontSize: 18, fontWeight: '600', color: '#1a1a2e' },
  topicDescription: { fontSize: 14, color: '#666', marginTop: 4 },
  comingSoonBadge: {
    marginTop: 12,
    backgroundColor: '#e9ecef',
    paddingHorizontal: 12,
    paddingVertical: 4,
    borderRadius: 8,
    alignSelf: 'flex-start',
  },
  comingSoonText: { fontSize: 12, color: '#666', fontWeight: '600' },
});
