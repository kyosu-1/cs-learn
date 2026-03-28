import { useState, useEffect, useRef, useCallback } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import VizControls from './VizControls';

type TreeNode = {
  val: number;
  left?: TreeNode;
  right?: TreeNode;
};

type TraversalStep = {
  visited: number[];
  current: number | null;
  description: string;
};

type TraversalType = 'inorder' | 'preorder' | 'postorder' | 'bfs';

type Props = {
  traversalType: TraversalType;
};

const sampleTree: TreeNode = {
  val: 1,
  left: {
    val: 2,
    left: { val: 4 },
    right: { val: 5 },
  },
  right: {
    val: 3,
    left: { val: 6 },
    right: { val: 7 },
  },
};

function getNodes(node?: TreeNode): number[] {
  if (!node) return [];
  return [node.val, ...getNodes(node.left), ...getNodes(node.right)];
}

function generateInorderSteps(node: TreeNode | undefined, steps: TraversalStep[], visited: number[]) {
  if (!node) return;
  generateInorderSteps(node.left, steps, visited);
  steps.push({ visited: [...visited], current: node.val, description: `ノード ${node.val} を訪問 (左→根→右)` });
  visited.push(node.val);
  generateInorderSteps(node.right, steps, visited);
}

function generatePreorderSteps(node: TreeNode | undefined, steps: TraversalStep[], visited: number[]) {
  if (!node) return;
  steps.push({ visited: [...visited], current: node.val, description: `ノード ${node.val} を訪問 (根→左→右)` });
  visited.push(node.val);
  generatePreorderSteps(node.left, steps, visited);
  generatePreorderSteps(node.right, steps, visited);
}

function generatePostorderSteps(node: TreeNode | undefined, steps: TraversalStep[], visited: number[]) {
  if (!node) return;
  generatePostorderSteps(node.left, steps, visited);
  generatePostorderSteps(node.right, steps, visited);
  steps.push({ visited: [...visited], current: node.val, description: `ノード ${node.val} を訪問 (左→右→根)` });
  visited.push(node.val);
}

function generateBFSSteps(root: TreeNode): TraversalStep[] {
  const steps: TraversalStep[] = [];
  const visited: number[] = [];
  const queue: TreeNode[] = [root];

  while (queue.length > 0) {
    const node = queue.shift()!;
    steps.push({ visited: [...visited], current: node.val, description: `ノード ${node.val} を訪問 (レベル順)` });
    visited.push(node.val);
    if (node.left) queue.push(node.left);
    if (node.right) queue.push(node.right);
  }
  return steps;
}

const traversalNames: Record<TraversalType, string> = {
  inorder: '中順走査 (Inorder)',
  preorder: '前順走査 (Preorder)',
  postorder: '後順走査 (Postorder)',
  bfs: '幅優先探索 (BFS)',
};

// Position map for a complete binary tree of depth 3
const nodePositions: Record<number, { x: number; y: number }> = {
  1: { x: 160, y: 20 },
  2: { x: 80, y: 80 },
  3: { x: 240, y: 80 },
  4: { x: 40, y: 140 },
  5: { x: 120, y: 140 },
  6: { x: 200, y: 140 },
  7: { x: 280, y: 140 },
};

const edges: [number, number][] = [[1, 2], [1, 3], [2, 4], [2, 5], [3, 6], [3, 7]];

export default function TreeTraversalViz({ traversalType }: Props) {
  const [steps, setSteps] = useState<TraversalStep[]>([]);
  const [currentStep, setCurrentStep] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [speed, setSpeed] = useState(1000);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    let s: TraversalStep[] = [];
    const visited: number[] = [];

    switch (traversalType) {
      case 'inorder': generateInorderSteps(sampleTree, s, visited); break;
      case 'preorder': generatePreorderSteps(sampleTree, s, visited); break;
      case 'postorder': generatePostorderSteps(sampleTree, s, visited); break;
      case 'bfs': s = generateBFSSteps(sampleTree); break;
    }

    s.unshift({ visited: [], current: null, description: '走査を開始' });
    s.push({ visited: getNodes(sampleTree), current: null, description: '走査完了!' });
    setSteps(s);
    setCurrentStep(0);
    setIsPlaying(false);
  }, [traversalType]);

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
      <Text style={styles.title}>{traversalNames[traversalType]}</Text>

      <View style={styles.treeContainer}>
        {/* Edges */}
        {edges.map(([from, to]) => {
          const fp = nodePositions[from];
          const tp = nodePositions[to];
          return (
            <View key={`${from}-${to}`} style={[styles.edge, {
              left: Math.min(fp.x, tp.x) + 20,
              top: fp.y + 20,
              width: Math.abs(fp.x - tp.x),
              height: Math.abs(fp.y - tp.y),
            }]}>
              <View style={styles.edgeLine} />
            </View>
          );
        })}

        {/* Nodes */}
        {Object.entries(nodePositions).map(([val, pos]) => {
          const numVal = parseInt(val);
          const isCurrent = step.current === numVal;
          const isVisited = step.visited.includes(numVal);

          let bgColor = '#e0e0e0';
          if (isCurrent) bgColor = '#ff9800';
          else if (isVisited) bgColor = '#4caf50';

          return (
            <View key={val} style={[styles.node, { left: pos.x, top: pos.y, backgroundColor: bgColor }]}>
              <Text style={[styles.nodeText, (isCurrent || isVisited) && { color: '#fff' }]}>{val}</Text>
            </View>
          );
        })}
      </View>

      <Text style={styles.visitedLabel}>
        訪問順: [{step.visited.join(', ')}]
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
  treeContainer: { height: 200, marginHorizontal: 16, marginTop: 16, position: 'relative' },
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
  edgeLine: { width: 1, height: '100%', backgroundColor: '#ccc', alignSelf: 'center' },
  visitedLabel: { fontSize: 14, color: '#4361ee', textAlign: 'center', fontFamily: 'SpaceMono', marginTop: 8 },
  description: { fontSize: 15, color: '#333', textAlign: 'center', padding: 12 },
});
