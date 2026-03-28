import { useState } from 'react';
import { StyleSheet, Text, View, ScrollView, TouchableOpacity } from 'react-native';
import SortingViz from '@/components/visualization/SortingViz';
import TreeTraversalViz from '@/components/visualization/TreeTraversalViz';
import GraphViz from '@/components/visualization/GraphViz';
import SchedulingViz from '@/components/visualization/SchedulingViz';
import PageReplacementViz from '@/components/visualization/PageReplacementViz';
import HandshakeViz from '@/components/visualization/HandshakeViz';
import DNSViz from '@/components/visualization/DNSViz';

type VizCategory = 'sorting' | 'tree' | 'graph' | 'os' | 'network';
type VizItem = {
  category: VizCategory;
  key: string;
  title: string;
  component: React.ReactNode;
};

const visualizations: VizItem[] = [
  { category: 'sorting', key: 'bubble', title: 'バブルソート', component: <SortingViz algorithm="bubble" /> },
  { category: 'sorting', key: 'merge', title: 'マージソート', component: <SortingViz algorithm="merge" /> },
  { category: 'sorting', key: 'quick', title: 'クイックソート', component: <SortingViz algorithm="quick" /> },
  { category: 'tree', key: 'inorder', title: '中順走査', component: <TreeTraversalViz traversalType="inorder" /> },
  { category: 'tree', key: 'preorder', title: '前順走査', component: <TreeTraversalViz traversalType="preorder" /> },
  { category: 'tree', key: 'bfs-tree', title: 'BFS (木)', component: <TreeTraversalViz traversalType="bfs" /> },
  { category: 'graph', key: 'bfs-graph', title: 'BFS (グラフ)', component: <GraphViz algorithm="bfs" /> },
  { category: 'graph', key: 'dfs-graph', title: 'DFS (グラフ)', component: <GraphViz algorithm="dfs" /> },
  { category: 'os', key: 'fcfs', title: 'FCFS スケジューリング', component: <SchedulingViz algorithm="fcfs" /> },
  { category: 'os', key: 'rr', title: 'Round Robin', component: <SchedulingViz algorithm="rr" /> },
  { category: 'os', key: 'page-fifo', title: 'FIFO ページ置換', component: <PageReplacementViz algorithm="fifo" /> },
  { category: 'os', key: 'page-lru', title: 'LRU ページ置換', component: <PageReplacementViz algorithm="lru" /> },
  { category: 'network', key: 'tcp-connect', title: 'TCP 接続確立', component: <HandshakeViz type="tcp-connect" /> },
  { category: 'network', key: 'tcp-close', title: 'TCP 切断', component: <HandshakeViz type="tcp-close" /> },
  { category: 'network', key: 'dns', title: 'DNS 名前解決', component: <DNSViz /> },
];

const categoryLabels: Record<VizCategory, string> = {
  sorting: 'ソート',
  tree: '木の走査',
  graph: 'グラフ探索',
  os: 'OS',
  network: 'ネットワーク',
};

export default function VisualizeScreen() {
  const [selected, setSelected] = useState<string | null>(null);
  const [categoryFilter, setCategoryFilter] = useState<VizCategory | null>(null);

  const selectedViz = visualizations.find((v) => v.key === selected);
  const filtered = categoryFilter
    ? visualizations.filter((v) => v.category === categoryFilter)
    : visualizations;

  if (selectedViz) {
    return (
      <View style={styles.container}>
        <TouchableOpacity style={styles.backRow} onPress={() => setSelected(null)}>
          <Text style={styles.backText}>← 一覧に戻る</Text>
        </TouchableOpacity>
        {selectedViz.component}
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>アルゴリズム可視化</Text>
        <Text style={styles.subtitle}>アルゴリズムの動作をアニメーションで理解しよう</Text>
      </View>

      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.filterRow}>
        <TouchableOpacity
          style={[styles.filterChip, !categoryFilter && styles.filterChipActive]}
          onPress={() => setCategoryFilter(null)}
        >
          <Text style={[styles.filterText, !categoryFilter && styles.filterTextActive]}>すべて</Text>
        </TouchableOpacity>
        {(Object.keys(categoryLabels) as VizCategory[]).map((cat) => (
          <TouchableOpacity
            key={cat}
            style={[styles.filterChip, categoryFilter === cat && styles.filterChipActive]}
            onPress={() => setCategoryFilter(cat)}
          >
            <Text style={[styles.filterText, categoryFilter === cat && styles.filterTextActive]}>
              {categoryLabels[cat]}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      <View style={styles.grid}>
        {filtered.map((viz) => (
          <TouchableOpacity
            key={viz.key}
            style={styles.vizCard}
            onPress={() => setSelected(viz.key)}
          >
            <Text style={styles.vizIcon}>
              {viz.category === 'sorting' ? '📊' : viz.category === 'tree' ? '🌳' : viz.category === 'graph' ? '🔗' : viz.category === 'os' ? '⚙️' : '🌐'}
            </Text>
            <Text style={styles.vizTitle}>{viz.title}</Text>
            <Text style={styles.vizCategory}>{categoryLabels[viz.category]}</Text>
          </TouchableOpacity>
        ))}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa' },
  header: { padding: 24, paddingTop: 16 },
  title: { fontSize: 28, fontWeight: 'bold', color: '#1a1a2e' },
  subtitle: { fontSize: 16, color: '#666', marginTop: 4 },
  backRow: { padding: 16, paddingBottom: 0 },
  backText: { color: '#4361ee', fontSize: 16, fontWeight: '600' },
  filterRow: { paddingHorizontal: 16, marginBottom: 8 },
  filterChip: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: '#e9ecef',
    marginRight: 8,
  },
  filterChipActive: { backgroundColor: '#4361ee' },
  filterText: { fontSize: 14, color: '#666', fontWeight: '500' },
  filterTextActive: { color: '#fff' },
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    padding: 12,
    gap: 12,
  },
  vizCard: {
    width: '47%',
    padding: 20,
    backgroundColor: '#fff',
    borderRadius: 16,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 3,
  },
  vizIcon: { fontSize: 36, marginBottom: 8 },
  vizTitle: { fontSize: 15, fontWeight: '600', color: '#1a1a2e', textAlign: 'center' },
  vizCategory: { fontSize: 12, color: '#999', marginTop: 4 },
});
