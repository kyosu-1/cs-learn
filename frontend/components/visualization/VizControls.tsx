import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';

type Props = {
  isPlaying: boolean;
  onPlay: () => void;
  onPause: () => void;
  onStepForward: () => void;
  onReset: () => void;
  speed: number;
  onSpeedChange: (speed: number) => void;
  currentStep: number;
  totalSteps: number;
};

const speeds = [
  { label: '0.5x', value: 2000 },
  { label: '1x', value: 1000 },
  { label: '2x', value: 500 },
  { label: '4x', value: 250 },
];

export default function VizControls({
  isPlaying, onPlay, onPause, onStepForward, onReset,
  speed, onSpeedChange, currentStep, totalSteps,
}: Props) {
  return (
    <View style={styles.container}>
      <View style={styles.progressInfo}>
        <Text style={styles.stepText}>
          ステップ {currentStep} / {totalSteps}
        </Text>
        <View style={styles.progressBar}>
          <View style={[styles.progressFill, {
            width: totalSteps > 0 ? `${(currentStep / totalSteps) * 100}%` : '0%'
          }]} />
        </View>
      </View>

      <View style={styles.controls}>
        <TouchableOpacity style={styles.controlButton} onPress={onReset}>
          <Text style={styles.controlIcon}>⟲</Text>
        </TouchableOpacity>

        {isPlaying ? (
          <TouchableOpacity style={[styles.controlButton, styles.playButton]} onPress={onPause}>
            <Text style={styles.playIcon}>⏸</Text>
          </TouchableOpacity>
        ) : (
          <TouchableOpacity style={[styles.controlButton, styles.playButton]} onPress={onPlay}>
            <Text style={styles.playIcon}>▶</Text>
          </TouchableOpacity>
        )}

        <TouchableOpacity
          style={styles.controlButton}
          onPress={onStepForward}
          disabled={isPlaying}
        >
          <Text style={[styles.controlIcon, isPlaying && { opacity: 0.3 }]}>⏭</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.speedRow}>
        {speeds.map((s) => (
          <TouchableOpacity
            key={s.value}
            style={[styles.speedButton, speed === s.value && styles.speedActive]}
            onPress={() => onSpeedChange(s.value)}
          >
            <Text style={[styles.speedText, speed === s.value && styles.speedTextActive]}>
              {s.label}
            </Text>
          </TouchableOpacity>
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { padding: 16, backgroundColor: '#fff', borderTopWidth: 1, borderTopColor: '#e0e0e0' },
  progressInfo: { marginBottom: 12 },
  stepText: { fontSize: 12, color: '#999', marginBottom: 4, textAlign: 'center' },
  progressBar: { height: 3, backgroundColor: '#e0e0e0', borderRadius: 2 },
  progressFill: { height: '100%', backgroundColor: '#4361ee', borderRadius: 2 },
  controls: { flexDirection: 'row', justifyContent: 'center', alignItems: 'center', gap: 16, marginBottom: 12 },
  controlButton: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: '#f0f0f0',
    justifyContent: 'center',
    alignItems: 'center',
  },
  playButton: { width: 56, height: 56, borderRadius: 28, backgroundColor: '#4361ee' },
  controlIcon: { fontSize: 20, color: '#333' },
  playIcon: { fontSize: 22, color: '#fff' },
  speedRow: { flexDirection: 'row', justifyContent: 'center', gap: 8 },
  speedButton: {
    paddingHorizontal: 14,
    paddingVertical: 6,
    borderRadius: 16,
    backgroundColor: '#f0f0f0',
  },
  speedActive: { backgroundColor: '#4361ee' },
  speedText: { fontSize: 13, color: '#666', fontWeight: '600' },
  speedTextActive: { color: '#fff' },
});
