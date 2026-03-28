import { useState, useEffect, useRef, useCallback } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import VizControls from './VizControls';

type DNSStep = {
  activeNode: string | null;
  activeEdge: [string, string] | null;
  direction: 'query' | 'response' | null;
  cache: string[];
  description: string;
};

const nodes = ['Browser', 'Resolver', 'Root', 'TLD (.com)', 'Auth (example.com)'];
const nodePositions: Record<string, { x: number; y: number }> = {
  'Browser': { x: 20, y: 90 },
  'Resolver': { x: 130, y: 90 },
  'Root': { x: 260, y: 10 },
  'TLD (.com)': { x: 260, y: 90 },
  'Auth (example.com)': { x: 260, y: 170 },
};

function generateDNSSteps(): DNSStep[] {
  return [
    { activeNode: 'Browser', activeEdge: null, direction: null, cache: [], description: 'ブラウザが www.example.com を解決したい' },
    { activeNode: 'Browser', activeEdge: ['Browser', 'Resolver'], direction: 'query', cache: [], description: '① ブラウザ → 再帰リゾルバに問い合わせ（再帰クエリ）' },
    { activeNode: 'Resolver', activeEdge: ['Resolver', 'Root'], direction: 'query', cache: [], description: '② リゾルバ → ルートDNSに「.com の NS は？」（反復クエリ）' },
    { activeNode: 'Root', activeEdge: ['Root', 'Resolver'], direction: 'response', cache: [], description: '③ ルートDNS → 「.com は a.gtld-servers.net に聞いて」' },
    { activeNode: 'Resolver', activeEdge: ['Resolver', 'TLD (.com)'], direction: 'query', cache: [], description: '④ リゾルバ → TLDサーバーに「example.com の NS は？」' },
    { activeNode: 'TLD (.com)', activeEdge: ['TLD (.com)', 'Resolver'], direction: 'response', cache: [], description: '⑤ TLDサーバー → 「example.com は a.iana-servers.net に聞いて」' },
    { activeNode: 'Resolver', activeEdge: ['Resolver', 'Auth (example.com)'], direction: 'query', cache: [], description: '⑥ リゾルバ → 権威サーバーに「www.example.com の A レコードは？」' },
    { activeNode: 'Auth (example.com)', activeEdge: ['Auth (example.com)', 'Resolver'], direction: 'response', cache: [], description: '⑦ 権威サーバー → 「93.184.216.34 です」(TTL=86400)' },
    { activeNode: 'Resolver', activeEdge: ['Resolver', 'Browser'], direction: 'response', cache: ['www.example.com → 93.184.216.34'], description: '⑧ リゾルバがキャッシュに保存し、ブラウザに回答' },
    { activeNode: 'Browser', activeEdge: null, direction: null, cache: ['www.example.com → 93.184.216.34'], description: '完了! ブラウザは 93.184.216.34 に接続可能。次回はキャッシュから即応答' },
  ];
}

export default function DNSViz() {
  const [steps] = useState<DNSStep[]>(generateDNSSteps());
  const [currentStep, setCurrentStep] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [speed, setSpeed] = useState(1000);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const step = steps[currentStep];

  const stopInterval = useCallback(() => {
    if (intervalRef.current) { clearInterval(intervalRef.current); intervalRef.current = null; }
  }, []);

  useEffect(() => {
    if (isPlaying && currentStep < steps.length - 1) {
      intervalRef.current = setInterval(() => {
        setCurrentStep(prev => {
          if (prev >= steps.length - 1) { setIsPlaying(false); return prev; }
          return prev + 1;
        });
      }, speed);
    } else {
      stopInterval();
      if (currentStep >= steps.length - 1) setIsPlaying(false);
    }
    return stopInterval;
  }, [isPlaying, speed, steps.length, currentStep]);

  if (!step) return null;

  return (
    <View style={styles.container}>
      <Text style={styles.title}>DNS 名前解決フロー</Text>
      <Text style={styles.subtitle}>www.example.com → ?</Text>

      <View style={styles.diagram}>
        {nodes.map(name => {
          const pos = nodePositions[name];
          const isActive = step.activeNode === name;
          const isInEdge = step.activeEdge?.includes(name);
          let bg = '#e0e0e0';
          if (isActive) bg = '#4361ee';
          else if (isInEdge) bg = '#f39c12';

          return (
            <View key={name} style={[styles.node, { left: pos.x, top: pos.y, backgroundColor: bg }]}>
              <Text style={[styles.nodeText, (isActive || isInEdge) && { color: '#fff' }]} numberOfLines={2}>
                {name}
              </Text>
            </View>
          );
        })}

        {/* Arrow indicator */}
        {step.activeEdge && (
          <View style={styles.arrowIndicator}>
            <Text style={styles.arrowDirection}>
              {step.direction === 'query' ? '📤 クエリ' : '📥 応答'}
            </Text>
          </View>
        )}
      </View>

      {/* Cache */}
      {step.cache.length > 0 && (
        <View style={styles.cacheBox}>
          <Text style={styles.cacheLabel}>キャッシュ:</Text>
          {step.cache.map((entry, i) => (
            <Text key={i} style={styles.cacheEntry}>{entry}</Text>
          ))}
        </View>
      )}

      <Text style={styles.description}>{step.description}</Text>

      <VizControls
        isPlaying={isPlaying}
        onPlay={() => setIsPlaying(true)}
        onPause={() => setIsPlaying(false)}
        onStepForward={() => setCurrentStep(p => Math.min(p + 1, steps.length - 1))}
        onReset={() => { setIsPlaying(false); setCurrentStep(0); }}
        speed={speed}
        onSpeedChange={setSpeed}
        currentStep={currentStep}
        totalSteps={steps.length - 1}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa' },
  title: { fontSize: 20, fontWeight: 'bold', color: '#1a1a2e', textAlign: 'center', paddingTop: 16 },
  subtitle: { fontSize: 14, color: '#4361ee', textAlign: 'center', fontFamily: 'SpaceMono' },
  diagram: { height: 230, marginHorizontal: 16, marginTop: 12, position: 'relative' },
  node: {
    position: 'absolute', paddingHorizontal: 8, paddingVertical: 10, borderRadius: 10,
    justifyContent: 'center', alignItems: 'center', minWidth: 80, borderWidth: 1, borderColor: '#ccc',
  },
  nodeText: { fontSize: 11, fontWeight: '600', color: '#333', textAlign: 'center' },
  arrowIndicator: { position: 'absolute', bottom: 0, left: 0, right: 0, alignItems: 'center' },
  arrowDirection: { fontSize: 14, color: '#666' },
  cacheBox: { marginHorizontal: 16, padding: 10, backgroundColor: '#e8f5e9', borderRadius: 8 },
  cacheLabel: { fontSize: 12, color: '#2e7d32', fontWeight: '600' },
  cacheEntry: { fontSize: 13, color: '#333', fontFamily: 'SpaceMono', marginTop: 2 },
  description: { fontSize: 14, color: '#333', textAlign: 'center', padding: 12, lineHeight: 22 },
});
