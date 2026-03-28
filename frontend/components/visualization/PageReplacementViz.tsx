import { useState, useEffect, useRef, useCallback } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import VizControls from './VizControls';

type PageStep = {
  request: number;
  frames: (number | null)[];
  fault: boolean;
  evicted: number | null;
  description: string;
};

type Props = {
  algorithm: 'fifo' | 'lru';
};

const pageRequests = [7, 0, 1, 2, 0, 3, 0, 4, 2, 3, 0, 3, 2, 1, 2, 0, 1, 7, 0, 1];
const frameCount = 3;

function generateFIFO(requests: number[], frames: number): PageStep[] {
  const steps: PageStep[] = [];
  const mem: number[] = [];
  let pointer = 0;

  steps.push({ request: -1, frames: Array(frames).fill(null), fault: false, evicted: null, description: `FIFO: ${frames}フレーム、${requests.length}回のページ参照` });

  for (const page of requests) {
    if (mem.includes(page)) {
      steps.push({ request: page, frames: [...mem, ...Array(frames - mem.length).fill(null)], fault: false, evicted: null, description: `ページ ${page}: ヒット` });
    } else {
      let evicted: number | null = null;
      if (mem.length >= frames) {
        evicted = mem[pointer % frames];
        mem[pointer % frames] = page;
        pointer++;
      } else {
        mem.push(page);
      }
      steps.push({
        request: page,
        frames: [...mem, ...Array(frames - mem.length).fill(null)],
        fault: true,
        evicted,
        description: evicted !== null ? `ページ ${page}: フォールト! ページ ${evicted} を追い出し` : `ページ ${page}: フォールト! フレームに空きあり`,
      });
    }
  }

  const faults = steps.filter(s => s.fault).length;
  steps.push({ request: -1, frames: [...mem, ...Array(frames - mem.length).fill(null)], fault: false, evicted: null, description: `完了! ページフォールト: ${faults}回 / ${requests.length}回 (${Math.round(faults / requests.length * 100)}%)` });
  return steps;
}

function generateLRU(requests: number[], frames: number): PageStep[] {
  const steps: PageStep[] = [];
  const mem: number[] = [];
  const lastUsed: Map<number, number> = new Map();

  steps.push({ request: -1, frames: Array(frames).fill(null), fault: false, evicted: null, description: `LRU: ${frames}フレーム、${requests.length}回のページ参照` });

  for (let t = 0; t < requests.length; t++) {
    const page = requests[t];
    if (mem.includes(page)) {
      lastUsed.set(page, t);
      steps.push({ request: page, frames: [...mem, ...Array(frames - mem.length).fill(null)], fault: false, evicted: null, description: `ページ ${page}: ヒット` });
    } else {
      let evicted: number | null = null;
      if (mem.length >= frames) {
        // Find LRU page
        let lruPage = mem[0];
        let lruTime = lastUsed.get(mem[0]) ?? -1;
        for (const p of mem) {
          const use = lastUsed.get(p) ?? -1;
          if (use < lruTime) { lruPage = p; lruTime = use; }
        }
        evicted = lruPage;
        const idx = mem.indexOf(lruPage);
        mem[idx] = page;
        lastUsed.delete(lruPage);
      } else {
        mem.push(page);
      }
      lastUsed.set(page, t);
      steps.push({
        request: page,
        frames: [...mem, ...Array(frames - mem.length).fill(null)],
        fault: true,
        evicted,
        description: evicted !== null ? `ページ ${page}: フォールト! LRU ページ ${evicted} を追い出し` : `ページ ${page}: フォールト! フレームに空きあり`,
      });
    }
  }

  const faults = steps.filter(s => s.fault).length;
  steps.push({ request: -1, frames: [...mem, ...Array(frames - mem.length).fill(null)], fault: false, evicted: null, description: `完了! ページフォールト: ${faults}回 / ${requests.length}回 (${Math.round(faults / requests.length * 100)}%)` });
  return steps;
}

const algorithmNames: Record<string, string> = {
  fifo: 'FIFO ページ置換',
  lru: 'LRU ページ置換',
};

export default function PageReplacementViz({ algorithm }: Props) {
  const [steps, setSteps] = useState<PageStep[]>([]);
  const [currentStep, setCurrentStep] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [speed, setSpeed] = useState(1000);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    const s = algorithm === 'lru' ? generateLRU(pageRequests, frameCount) : generateFIFO(pageRequests, frameCount);
    setSteps(s);
    setCurrentStep(0);
    setIsPlaying(false);
  }, [algorithm]);

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

  // Faults so far
  const faultsSoFar = steps.slice(0, currentStep + 1).filter(s => s.fault).length;

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{algorithmNames[algorithm]}</Text>

      {/* Page reference string */}
      <View style={styles.refStringRow}>
        <Text style={styles.refLabel}>参照列: </Text>
        {pageRequests.map((p, i) => {
          const stepIdx = i + 1;
          const isActive = stepIdx === currentStep;
          const isPast = stepIdx < currentStep;
          const wasFault = stepIdx < steps.length && steps[stepIdx]?.fault;
          return (
            <View key={i} style={[styles.refItem, isActive && styles.refActive, isPast && wasFault && styles.refFault, isPast && !wasFault && styles.refHit]}>
              <Text style={[styles.refText, (isActive || isPast) && { color: '#fff' }]}>{p}</Text>
            </View>
          );
        })}
      </View>

      {/* Frames */}
      <View style={styles.framesContainer}>
        <Text style={styles.framesLabel}>物理フレーム:</Text>
        <View style={styles.framesRow}>
          {step.frames.map((page, i) => (
            <View key={i} style={[styles.frame, page !== null && styles.frameOccupied]}>
              <Text style={styles.frameLabel}>F{i}</Text>
              <Text style={styles.framePage}>{page !== null ? page : '-'}</Text>
            </View>
          ))}
        </View>
      </View>

      {/* Stats */}
      <View style={styles.statsRow}>
        <View style={[styles.statBadge, { backgroundColor: '#e74c3c20' }]}>
          <Text style={[styles.statText, { color: '#e74c3c' }]}>フォールト: {faultsSoFar}</Text>
        </View>
        <View style={[styles.statBadge, { backgroundColor: '#2ecc7120' }]}>
          <Text style={[styles.statText, { color: '#2ecc71' }]}>ヒット: {Math.max(0, currentStep - faultsSoFar - (currentStep > 0 ? 0 : 0))}</Text>
        </View>
      </View>

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
  refStringRow: { flexDirection: 'row', flexWrap: 'wrap', padding: 12, alignItems: 'center', gap: 3 },
  refLabel: { fontSize: 13, color: '#666', marginRight: 4 },
  refItem: { width: 28, height: 28, borderRadius: 4, backgroundColor: '#e0e0e0', justifyContent: 'center', alignItems: 'center' },
  refActive: { backgroundColor: '#4361ee' },
  refFault: { backgroundColor: '#e74c3c' },
  refHit: { backgroundColor: '#2ecc71' },
  refText: { fontSize: 13, fontWeight: '600', color: '#333' },
  framesContainer: { padding: 16 },
  framesLabel: { fontSize: 14, color: '#666', marginBottom: 8 },
  framesRow: { flexDirection: 'row', gap: 12, justifyContent: 'center' },
  frame: { width: 70, height: 70, borderRadius: 12, backgroundColor: '#e9ecef', justifyContent: 'center', alignItems: 'center', borderWidth: 2, borderColor: '#ccc' },
  frameOccupied: { backgroundColor: '#fff', borderColor: '#4361ee' },
  frameLabel: { fontSize: 11, color: '#999' },
  framePage: { fontSize: 28, fontWeight: 'bold', color: '#1a1a2e' },
  statsRow: { flexDirection: 'row', justifyContent: 'center', gap: 12, marginVertical: 8 },
  statBadge: { paddingHorizontal: 14, paddingVertical: 6, borderRadius: 8 },
  statText: { fontSize: 14, fontWeight: '600' },
  description: { fontSize: 14, color: '#333', textAlign: 'center', padding: 8 },
});
