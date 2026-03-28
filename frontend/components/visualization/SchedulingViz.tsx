import { useState, useEffect, useRef, useCallback } from 'react';
import { StyleSheet, Text, View, ScrollView } from 'react-native';
import VizControls from './VizControls';

type SchedulingStep = {
  time: number;
  running: string | null;
  queue: string[];
  remaining: Record<string, number>;
  completed: string[];
  description: string;
};

type Props = {
  algorithm: 'fcfs' | 'rr' | 'sjf';
};

type Process = { name: string; arrival: number; burst: number };

const processes: Process[] = [
  { name: 'P1', arrival: 0, burst: 8 },
  { name: 'P2', arrival: 1, burst: 4 },
  { name: 'P3', arrival: 2, burst: 6 },
  { name: 'P4', arrival: 3, burst: 3 },
];

const processColors: Record<string, string> = {
  P1: '#4361ee', P2: '#e74c3c', P3: '#2ecc71', P4: '#f39c12',
};

function generateFCFS(procs: Process[]): SchedulingStep[] {
  const steps: SchedulingStep[] = [];
  const sorted = [...procs].sort((a, b) => a.arrival - b.arrival);
  const remaining: Record<string, number> = {};
  sorted.forEach(p => remaining[p.name] = p.burst);
  let time = 0;
  const completed: string[] = [];

  steps.push({ time: 0, running: null, queue: [], remaining: { ...remaining }, completed: [], description: '初期状態' });

  for (const p of sorted) {
    time = Math.max(time, p.arrival);
    const queue = sorted.filter(q => q.arrival <= time && q.name !== p.name && !completed.includes(q.name) && remaining[q.name] > 0).map(q => q.name);

    for (let t = 0; t < p.burst; t++) {
      const arrived = sorted.filter(q => q.arrival <= time + 1 && !completed.includes(q.name) && q.name !== p.name && remaining[q.name] > 0).map(q => q.name);
      remaining[p.name]--;
      time++;
      steps.push({
        time,
        running: p.name,
        queue: arrived,
        remaining: { ...remaining },
        completed: [...completed],
        description: `t=${time}: ${p.name} 実行中 (残り ${remaining[p.name]})`,
      });
    }
    completed.push(p.name);
    steps.push({
      time,
      running: null,
      queue: sorted.filter(q => q.arrival <= time && !completed.includes(q.name)).map(q => q.name),
      remaining: { ...remaining },
      completed: [...completed],
      description: `${p.name} 完了 (t=${time})`,
    });
  }
  return steps;
}

function generateRR(procs: Process[], quantum: number): SchedulingStep[] {
  const steps: SchedulingStep[] = [];
  const remaining: Record<string, number> = {};
  procs.forEach(p => remaining[p.name] = p.burst);
  const completed: string[] = [];
  let time = 0;
  const queue: string[] = [];
  const arrived = new Set<string>();

  steps.push({ time: 0, running: null, queue: [], remaining: { ...remaining }, completed: [], description: `Round Robin (quantum=${quantum})` });

  // Initial arrivals
  for (const p of procs) {
    if (p.arrival <= 0) { queue.push(p.name); arrived.add(p.name); }
  }

  while (queue.length > 0 || procs.some(p => !arrived.has(p.name))) {
    if (queue.length === 0) {
      time++;
      for (const p of procs) {
        if (p.arrival <= time && !arrived.has(p.name)) { queue.push(p.name); arrived.add(p.name); }
      }
      continue;
    }

    const current = queue.shift()!;
    const runTime = Math.min(quantum, remaining[current]);

    for (let t = 0; t < runTime; t++) {
      remaining[current]--;
      time++;
      // Check new arrivals
      for (const p of procs) {
        if (p.arrival <= time && !arrived.has(p.name)) { queue.push(p.name); arrived.add(p.name); }
      }
      steps.push({
        time, running: current, queue: [...queue],
        remaining: { ...remaining }, completed: [...completed],
        description: `t=${time}: ${current} 実行中 (残り ${remaining[current]})`,
      });
    }

    if (remaining[current] === 0) {
      completed.push(current);
      steps.push({ time, running: null, queue: [...queue], remaining: { ...remaining }, completed: [...completed], description: `${current} 完了 (t=${time})` });
    } else {
      queue.push(current);
    }
  }

  steps.push({ time, running: null, queue: [], remaining: { ...remaining }, completed: [...completed], description: '全プロセス完了!' });
  return steps;
}

const algorithmNames: Record<string, string> = {
  fcfs: 'FCFS (First Come First Served)',
  rr: 'Round Robin (quantum=3)',
  sjf: 'SJF (Shortest Job First)',
};

export default function SchedulingViz({ algorithm }: Props) {
  const [steps, setSteps] = useState<SchedulingStep[]>([]);
  const [currentStep, setCurrentStep] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [speed, setSpeed] = useState(1000);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    let s: SchedulingStep[];
    switch (algorithm) {
      case 'rr': s = generateRR(processes, 3); break;
      case 'fcfs':
      default: s = generateFCFS(processes); break;
    }
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

  // Build gantt chart from steps
  const gantt: { name: string; start: number; end: number }[] = [];
  let lastRunning: string | null = null;
  let lastStart = 0;
  for (const s of steps) {
    if (s.running !== lastRunning) {
      if (lastRunning) gantt.push({ name: lastRunning, start: lastStart, end: s.time });
      lastRunning = s.running;
      lastStart = s.time;
    }
  }
  if (lastRunning) gantt.push({ name: lastRunning, start: lastStart, end: steps[steps.length - 1].time });

  const maxTime = steps[steps.length - 1]?.time || 1;

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{algorithmNames[algorithm]}</Text>

      {/* Process info */}
      <View style={styles.processInfo}>
        {processes.map(p => (
          <View key={p.name} style={styles.processRow}>
            <View style={[styles.processColor, { backgroundColor: processColors[p.name] }]} />
            <Text style={styles.processLabel}>{p.name}: burst={p.burst}, arrival={p.arrival}</Text>
            <Text style={styles.processRemaining}>
              {step.completed.includes(p.name) ? '✓' : `残り ${step.remaining[p.name]}`}
            </Text>
          </View>
        ))}
      </View>

      {/* Gantt chart */}
      <ScrollView horizontal style={styles.ganttContainer}>
        <View style={styles.gantt}>
          {gantt.filter(g => g.end <= step.time || (step.running === g.name && g.start < step.time)).map((g, i) => {
            const end = g.name === step.running ? Math.min(g.end, step.time) : g.end;
            return (
              <View key={i} style={[styles.ganttBlock, {
                backgroundColor: processColors[g.name],
                width: Math.max((end - g.start) * 30, 20),
                opacity: g.end <= step.time ? 1 : 0.7,
              }]}>
                <Text style={styles.ganttText}>{g.name}</Text>
              </View>
            );
          })}
        </View>
      </ScrollView>

      {/* Queue */}
      <View style={styles.queueRow}>
        <Text style={styles.queueLabel}>Ready Queue: </Text>
        {step.queue.length === 0 ? (
          <Text style={styles.queueEmpty}>(空)</Text>
        ) : step.queue.map((name, i) => (
          <View key={i} style={[styles.queueItem, { backgroundColor: processColors[name] }]}>
            <Text style={styles.queueItemText}>{name}</Text>
          </View>
        ))}
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
  processInfo: { padding: 16, gap: 6 },
  processRow: { flexDirection: 'row', alignItems: 'center' },
  processColor: { width: 14, height: 14, borderRadius: 3, marginRight: 8 },
  processLabel: { fontSize: 13, color: '#333', flex: 1 },
  processRemaining: { fontSize: 13, color: '#666', fontFamily: 'SpaceMono' },
  ganttContainer: { marginHorizontal: 16, marginBottom: 8 },
  gantt: { flexDirection: 'row', height: 40, alignItems: 'center', gap: 1 },
  ganttBlock: { height: 36, borderRadius: 4, justifyContent: 'center', alignItems: 'center', minWidth: 24 },
  ganttText: { color: '#fff', fontSize: 12, fontWeight: '600' },
  queueRow: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 16, marginBottom: 4 },
  queueLabel: { fontSize: 13, color: '#666' },
  queueEmpty: { fontSize: 13, color: '#999' },
  queueItem: { paddingHorizontal: 10, paddingVertical: 4, borderRadius: 4, marginLeft: 4 },
  queueItemText: { color: '#fff', fontSize: 12, fontWeight: '600' },
  description: { fontSize: 14, color: '#333', textAlign: 'center', padding: 8 },
});
