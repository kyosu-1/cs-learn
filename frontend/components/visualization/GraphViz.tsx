import { useState, useEffect, useRef, useCallback } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import VizControls from './VizControls';

type GraphStep = {
  visited: string[];
  current: string | null;
  queue: string[];
  description: string;
};

type GraphAlgorithm = 'bfs' | 'dfs';

type Props = {
  algorithm: GraphAlgorithm;
};

const graph: Record<string, string[]> = {
  A: ['B', 'C'],
  B: ['A', 'D', 'E'],
  C: ['A', 'F'],
  D: ['B'],
  E: ['B', 'F'],
  F: ['C', 'E'],
};

const nodePositions: Record<string, { x: number; y: number }> = {
  A: { x: 140, y: 10 },
  B: { x: 60, y: 80 },
  C: { x: 220, y: 80 },
  D: { x: 20, y: 160 },
  E: { x: 140, y: 160 },
  F: { x: 260, y: 160 },
};

const graphEdges: [string, string][] = [['A', 'B'], ['A', 'C'], ['B', 'D'], ['B', 'E'], ['C', 'F'], ['E', 'F']];

function generateBFSSteps(start: string): GraphStep[] {
  const steps: GraphStep[] = [];
  const visited: string[] = [];
  const queue = [start];
  visited.push(start);

  steps.push({ visited: [], current: null, queue: [start], description: `開始ノード: ${start}` });

  while (queue.length > 0) {
    const node = queue.shift()!;
    steps.push({ visited: [...visited], current: node, queue: [...queue], description: `${node} を探索中` });

    for (const neighbor of graph[node]) {
      if (!visited.includes(neighbor)) {
        visited.push(neighbor);
        queue.push(neighbor);
        steps.push({ visited: [...visited], current: node, queue: [...queue], description: `${neighbor} をキューに追加` });
      }
    }
  }

  steps.push({ visited: [...visited], current: null, queue: [], description: '探索完了!' });
  return steps;
}

function generateDFSSteps(start: string): GraphStep[] {
  const steps: GraphStep[] = [];
  const visited: string[] = [];
  const stack: string[] = [];

  steps.push({ visited: [], current: null, queue: [], description: `開始ノード: ${start}` });

  function dfs(node: string) {
    visited.push(node);
    stack.push(node);
    steps.push({ visited: [...visited], current: node, queue: [...stack], description: `${node} を訪問（深さ優先）` });

    for (const neighbor of graph[node]) {
      if (!visited.includes(neighbor)) {
        dfs(neighbor);
      }
    }
    stack.pop();
  }

  dfs(start);
  steps.push({ visited: [...visited], current: null, queue: [], description: '探索完了!' });
  return steps;
}

const algorithmNames: Record<GraphAlgorithm, string> = {
  bfs: '幅優先探索 (BFS)',
  dfs: '深さ優先探索 (DFS)',
};

export default function GraphViz({ algorithm }: Props) {
  const [steps, setSteps] = useState<GraphStep[]>([]);
  const [currentStep, setCurrentStep] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [speed, setSpeed] = useState(1000);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    const s = algorithm === 'bfs' ? generateBFSSteps('A') : generateDFSSteps('A');
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
        setCurrentStep((prev) => {
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
      <Text style={styles.title}>{algorithmNames[algorithm]}</Text>

      <View style={styles.graphContainer}>
        {/* Edges */}
        {graphEdges.map(([from, to]) => {
          const fp = nodePositions[from];
          const tp = nodePositions[to];
          const bothVisited = step.visited.includes(from) && step.visited.includes(to);
          return (
            <View key={`${from}-${to}`} style={[styles.edge, {
              left: Math.min(fp.x, tp.x) + 20,
              top: Math.min(fp.y, tp.y) + 20,
              width: Math.abs(fp.x - tp.x) || 2,
              height: Math.abs(fp.y - tp.y) || 2,
            }]}>
              <View style={[styles.edgeLine, bothVisited && { backgroundColor: '#4caf50' }]} />
            </View>
          );
        })}

        {/* Nodes */}
        {Object.entries(nodePositions).map(([label, pos]) => {
          const isCurrent = step.current === label;
          const isVisited = step.visited.includes(label);

          let bgColor = '#e0e0e0';
          if (isCurrent) bgColor = '#ff9800';
          else if (isVisited) bgColor = '#4caf50';

          return (
            <View key={label} style={[styles.node, { left: pos.x, top: pos.y, backgroundColor: bgColor }]}>
              <Text style={[styles.nodeText, (isCurrent || isVisited) && { color: '#fff' }]}>{label}</Text>
            </View>
          );
        })}
      </View>

      <Text style={styles.visitedLabel}>
        訪問順: [{step.visited.join(', ')}]
      </Text>
      <Text style={styles.queueLabel}>
        {algorithm === 'bfs' ? 'キュー' : 'スタック'}: [{step.queue.join(', ')}]
      </Text>
      <Text style={styles.description}>{step.description}</Text>

      <VizControls
        isPlaying={isPlaying}
        onPlay={() => setIsPlaying(true)}
        onPause={() => setIsPlaying(false)}
        onStepForward={() => setCurrentStep((p) => Math.min(p + 1, steps.length - 1))}
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
  title: { fontSize: 22, fontWeight: 'bold', color: '#1a1a2e', textAlign: 'center', paddingTop: 16 },
  graphContainer: { height: 220, marginHorizontal: 16, marginTop: 16, position: 'relative' },
  node: {
    position: 'absolute',
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 2,
    borderColor: '#ccc',
  },
  nodeText: { fontSize: 16, fontWeight: 'bold', color: '#333' },
  edge: { position: 'absolute' },
  edgeLine: { width: 2, height: '100%', backgroundColor: '#ccc', alignSelf: 'center' },
  visitedLabel: { fontSize: 14, color: '#4361ee', textAlign: 'center', fontFamily: 'SpaceMono', marginTop: 8 },
  queueLabel: { fontSize: 13, color: '#666', textAlign: 'center', fontFamily: 'SpaceMono', marginTop: 4 },
  description: { fontSize: 15, color: '#333', textAlign: 'center', padding: 12 },
});
