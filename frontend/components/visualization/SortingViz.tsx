import { useState, useEffect, useRef, useCallback } from 'react';
import { StyleSheet, Text, View, ScrollView } from 'react-native';
import VizControls from './VizControls';

type SortStep = {
  array: number[];
  comparing: number[];
  swapping: number[];
  sorted: number[];
  description: string;
};

type Algorithm = 'bubble' | 'merge' | 'quick';

type Props = {
  algorithm: Algorithm;
  initialArray?: number[];
};

function generateBubbleSortSteps(arr: number[]): SortStep[] {
  const steps: SortStep[] = [];
  const a = [...arr];
  const sorted: number[] = [];

  steps.push({ array: [...a], comparing: [], swapping: [], sorted: [], description: '初期状態' });

  for (let i = 0; i < a.length; i++) {
    let swapped = false;
    for (let j = 0; j < a.length - i - 1; j++) {
      steps.push({ array: [...a], comparing: [j, j + 1], swapping: [], sorted: [...sorted], description: `${a[j]} と ${a[j + 1]} を比較` });

      if (a[j] > a[j + 1]) {
        [a[j], a[j + 1]] = [a[j + 1], a[j]];
        steps.push({ array: [...a], comparing: [], swapping: [j, j + 1], sorted: [...sorted], description: `${a[j + 1]} と ${a[j]} を交換` });
        swapped = true;
      }
    }
    sorted.unshift(a.length - i - 1);
    if (!swapped) break;
  }

  steps.push({ array: [...a], comparing: [], swapping: [], sorted: a.map((_, i) => i), description: 'ソート完了!' });
  return steps;
}

function generateMergeSortSteps(arr: number[]): SortStep[] {
  const steps: SortStep[] = [];
  const a = [...arr];

  steps.push({ array: [...a], comparing: [], swapping: [], sorted: [], description: '初期状態' });

  function mergeSort(start: number, end: number) {
    if (end - start <= 1) return;
    const mid = Math.floor((start + end) / 2);
    mergeSort(start, mid);
    mergeSort(mid, end);

    const left = a.slice(start, mid);
    const right = a.slice(mid, end);
    let i = 0, j = 0, k = start;

    steps.push({ array: [...a], comparing: Array.from({ length: end - start }, (_, idx) => start + idx), swapping: [], sorted: [], description: `区間 [${start}..${end - 1}] をマージ` });

    while (i < left.length && j < right.length) {
      if (left[i] <= right[j]) {
        a[k] = left[i];
        i++;
      } else {
        a[k] = right[j];
        j++;
      }
      steps.push({ array: [...a], comparing: [], swapping: [k], sorted: [], description: `位置 ${k} に ${a[k]} を配置` });
      k++;
    }
    while (i < left.length) { a[k] = left[i]; i++; k++; }
    while (j < right.length) { a[k] = right[j]; j++; k++; }

    steps.push({ array: [...a], comparing: [], swapping: [], sorted: [], description: `区間 [${start}..${end - 1}] のマージ完了` });
  }

  mergeSort(0, a.length);
  steps.push({ array: [...a], comparing: [], swapping: [], sorted: a.map((_, i) => i), description: 'ソート完了!' });
  return steps;
}

function generateQuickSortSteps(arr: number[]): SortStep[] {
  const steps: SortStep[] = [];
  const a = [...arr];
  const sortedIndices: Set<number> = new Set();

  steps.push({ array: [...a], comparing: [], swapping: [], sorted: [], description: '初期状態' });

  function quickSort(low: number, high: number) {
    if (low >= high) {
      if (low === high) sortedIndices.add(low);
      return;
    }
    const pivotIdx = Math.floor((low + high) / 2);
    const pivot = a[pivotIdx];

    steps.push({ array: [...a], comparing: [pivotIdx], swapping: [], sorted: [...sortedIndices], description: `ピボット: ${pivot} (位置 ${pivotIdx})` });

    // Move pivot to end
    [a[pivotIdx], a[high]] = [a[high], a[pivotIdx]];
    let storeIdx = low;

    for (let i = low; i < high; i++) {
      steps.push({ array: [...a], comparing: [i, high], swapping: [], sorted: [...sortedIndices], description: `${a[i]} と ピボット ${pivot} を比較` });
      if (a[i] < pivot) {
        [a[i], a[storeIdx]] = [a[storeIdx], a[i]];
        if (i !== storeIdx) {
          steps.push({ array: [...a], comparing: [], swapping: [i, storeIdx], sorted: [...sortedIndices], description: `${a[storeIdx]} と ${a[i]} を交換` });
        }
        storeIdx++;
      }
    }
    [a[storeIdx], a[high]] = [a[high], a[storeIdx]];
    steps.push({ array: [...a], comparing: [], swapping: [storeIdx], sorted: [...sortedIndices], description: `ピボット ${pivot} を位置 ${storeIdx} に配置` });

    sortedIndices.add(storeIdx);
    quickSort(low, storeIdx - 1);
    quickSort(storeIdx + 1, high);
  }

  quickSort(0, a.length - 1);
  steps.push({ array: [...a], comparing: [], swapping: [], sorted: a.map((_, i) => i), description: 'ソート完了!' });
  return steps;
}

const algorithmNames: Record<Algorithm, string> = {
  bubble: 'バブルソート',
  merge: 'マージソート',
  quick: 'クイックソート',
};

const defaultArray = [64, 34, 25, 12, 22, 11, 90];

export default function SortingViz({ algorithm, initialArray }: Props) {
  const arr = initialArray || defaultArray;
  const [steps, setSteps] = useState<SortStep[]>([]);
  const [currentStep, setCurrentStep] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [speed, setSpeed] = useState(1000);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    let s: SortStep[];
    switch (algorithm) {
      case 'bubble': s = generateBubbleSortSteps([...arr]); break;
      case 'merge': s = generateMergeSortSteps([...arr]); break;
      case 'quick': s = generateQuickSortSteps([...arr]); break;
      default: s = generateBubbleSortSteps([...arr]);
    }
    setSteps(s);
    setCurrentStep(0);
    setIsPlaying(false);
  }, [algorithm]);

  const step = steps[currentStep];
  const maxVal = Math.max(...arr);

  const stopInterval = useCallback(() => {
    if (intervalRef.current) {
      clearInterval(intervalRef.current);
      intervalRef.current = null;
    }
  }, []);

  useEffect(() => {
    if (isPlaying && currentStep < steps.length - 1) {
      intervalRef.current = setInterval(() => {
        setCurrentStep((prev) => {
          if (prev >= steps.length - 1) {
            setIsPlaying(false);
            return prev;
          }
          return prev + 1;
        });
      }, speed);
    } else {
      stopInterval();
      if (currentStep >= steps.length - 1) setIsPlaying(false);
    }
    return stopInterval;
  }, [isPlaying, speed, steps.length, currentStep]);

  const handleReset = () => {
    setIsPlaying(false);
    setCurrentStep(0);
  };

  if (!step) return null;

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{algorithmNames[algorithm]}</Text>

      <View style={styles.arrayContainer}>
        {step.array.map((value, index) => {
          const isComparing = step.comparing.includes(index);
          const isSwapping = step.swapping.includes(index);
          const isSorted = step.sorted.includes(index);

          let barColor = '#94a3b8';
          if (isSorted) barColor = '#4caf50';
          else if (isSwapping) barColor = '#e74c3c';
          else if (isComparing) barColor = '#ff9800';

          const heightPercent = (value / maxVal) * 100;

          return (
            <View key={index} style={styles.barWrapper}>
              <Text style={styles.barValue}>{value}</Text>
              <View style={[styles.bar, { height: `${heightPercent}%`, backgroundColor: barColor }]} />
            </View>
          );
        })}
      </View>

      <Text style={styles.description}>{step.description}</Text>

      <View style={styles.legend}>
        <View style={styles.legendItem}>
          <View style={[styles.legendDot, { backgroundColor: '#ff9800' }]} />
          <Text style={styles.legendText}>比較中</Text>
        </View>
        <View style={styles.legendItem}>
          <View style={[styles.legendDot, { backgroundColor: '#e74c3c' }]} />
          <Text style={styles.legendText}>交換/配置</Text>
        </View>
        <View style={styles.legendItem}>
          <View style={[styles.legendDot, { backgroundColor: '#4caf50' }]} />
          <Text style={styles.legendText}>確定済み</Text>
        </View>
      </View>

      <VizControls
        isPlaying={isPlaying}
        onPlay={() => setIsPlaying(true)}
        onPause={() => setIsPlaying(false)}
        onStepForward={() => setCurrentStep((p) => Math.min(p + 1, steps.length - 1))}
        onReset={handleReset}
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
  arrayContainer: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    justifyContent: 'center',
    height: 220,
    paddingHorizontal: 16,
    paddingTop: 16,
    gap: 4,
  },
  barWrapper: { flex: 1, alignItems: 'center', height: '100%', justifyContent: 'flex-end' },
  barValue: { fontSize: 11, color: '#666', fontWeight: '600', marginBottom: 4 },
  bar: { width: '80%', borderRadius: 4, minHeight: 8 },
  description: {
    fontSize: 15,
    color: '#333',
    textAlign: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    minHeight: 44,
  },
  legend: { flexDirection: 'row', justifyContent: 'center', gap: 16, paddingBottom: 8 },
  legendItem: { flexDirection: 'row', alignItems: 'center', gap: 4 },
  legendDot: { width: 10, height: 10, borderRadius: 5 },
  legendText: { fontSize: 12, color: '#666' },
});
