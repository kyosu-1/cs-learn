import { useState, useEffect, useRef, useCallback } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import VizControls from './VizControls';

type HandshakeStep = {
  clientState: string;
  serverState: string;
  arrow: 'right' | 'left' | null;
  message: string;
  flags: string;
  description: string;
};

type Props = {
  type: 'tcp-connect' | 'tcp-close';
};

function generateTCPConnect(): HandshakeStep[] {
  return [
    { clientState: 'CLOSED', serverState: 'LISTEN', arrow: null, message: '', flags: '', description: 'サーバーは LISTEN 状態で接続を待機' },
    { clientState: 'SYN_SENT', serverState: 'LISTEN', arrow: 'right', message: 'SYN', flags: 'seq=100', description: 'クライアントが SYN を送信。シーケンス番号 100 を提示' },
    { clientState: 'SYN_SENT', serverState: 'SYN_RCVD', arrow: 'left', message: 'SYN+ACK', flags: 'seq=300, ack=101', description: 'サーバーが SYN+ACK を返信。自身の seq=300 を提示し、クライアントの seq+1 を確認' },
    { clientState: 'ESTABLISHED', serverState: 'SYN_RCVD', arrow: 'right', message: 'ACK', flags: 'ack=301', description: 'クライアントが ACK を送信。サーバーの seq+1 を確認' },
    { clientState: 'ESTABLISHED', serverState: 'ESTABLISHED', arrow: null, message: '', flags: '', description: '接続確立! 双方が ESTABLISHED 状態。データ送受信可能' },
  ];
}

function generateTCPClose(): HandshakeStep[] {
  return [
    { clientState: 'ESTABLISHED', serverState: 'ESTABLISHED', arrow: null, message: '', flags: '', description: '双方が ESTABLISHED 状態' },
    { clientState: 'FIN_WAIT_1', serverState: 'ESTABLISHED', arrow: 'right', message: 'FIN', flags: 'seq=500', description: 'クライアントが FIN を送信。送信完了を通知' },
    { clientState: 'FIN_WAIT_1', serverState: 'CLOSE_WAIT', arrow: 'left', message: 'ACK', flags: 'ack=501', description: 'サーバーが ACK を返信。FIN を確認' },
    { clientState: 'FIN_WAIT_2', serverState: 'CLOSE_WAIT', arrow: null, message: '', flags: '', description: 'サーバーはまだデータを送信可能（半二重クローズ）' },
    { clientState: 'FIN_WAIT_2', serverState: 'LAST_ACK', arrow: 'left', message: 'FIN', flags: 'seq=700', description: 'サーバーも FIN を送信。送信完了を通知' },
    { clientState: 'TIME_WAIT', serverState: 'LAST_ACK', arrow: 'right', message: 'ACK', flags: 'ack=701', description: 'クライアントが ACK を送信' },
    { clientState: 'TIME_WAIT', serverState: 'CLOSED', arrow: null, message: '', flags: '', description: 'サーバーは CLOSED。クライアントは TIME_WAIT（2MSL待機後にCLOSED）' },
  ];
}

const typeNames: Record<string, string> = {
  'tcp-connect': 'TCP 3ウェイハンドシェイク（接続確立）',
  'tcp-close': 'TCP 4ウェイハンドシェイク（切断）',
};

export default function HandshakeViz({ type }: Props) {
  const [steps, setSteps] = useState<HandshakeStep[]>([]);
  const [currentStep, setCurrentStep] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [speed, setSpeed] = useState(1000);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    setSteps(type === 'tcp-close' ? generateTCPClose() : generateTCPConnect());
    setCurrentStep(0);
    setIsPlaying(false);
  }, [type]);

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

  const stateColor = (state: string) => {
    if (state === 'ESTABLISHED') return '#2ecc71';
    if (state === 'CLOSED') return '#999';
    if (state === 'LISTEN') return '#f39c12';
    return '#4361ee';
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{typeNames[type]}</Text>

      <View style={styles.diagram}>
        {/* Client */}
        <View style={styles.endpoint}>
          <Text style={styles.endpointLabel}>Client</Text>
          <View style={[styles.stateBox, { borderColor: stateColor(step.clientState) }]}>
            <Text style={[styles.stateText, { color: stateColor(step.clientState) }]}>{step.clientState}</Text>
          </View>
          <View style={styles.line} />
        </View>

        {/* Arrow */}
        <View style={styles.arrowArea}>
          {step.arrow && (
            <View style={styles.messageBox}>
              <Text style={styles.arrowSymbol}>{step.arrow === 'right' ? '→' : '←'}</Text>
              <Text style={styles.messageText}>{step.message}</Text>
              <Text style={styles.flagsText}>{step.flags}</Text>
            </View>
          )}
        </View>

        {/* Server */}
        <View style={styles.endpoint}>
          <Text style={styles.endpointLabel}>Server</Text>
          <View style={[styles.stateBox, { borderColor: stateColor(step.serverState) }]}>
            <Text style={[styles.stateText, { color: stateColor(step.serverState) }]}>{step.serverState}</Text>
          </View>
          <View style={styles.line} />
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
  diagram: { flexDirection: 'row', justifyContent: 'space-between', padding: 20, paddingTop: 30, height: 200 },
  endpoint: { alignItems: 'center', width: 110 },
  endpointLabel: { fontSize: 16, fontWeight: '600', color: '#1a1a2e', marginBottom: 8 },
  stateBox: { borderWidth: 2, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 6, backgroundColor: '#fff' },
  stateText: { fontSize: 11, fontWeight: '700', fontFamily: 'SpaceMono' },
  line: { width: 2, flex: 1, backgroundColor: '#ccc', marginTop: 8 },
  arrowArea: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  messageBox: { alignItems: 'center', backgroundColor: '#fff', paddingHorizontal: 12, paddingVertical: 8, borderRadius: 8, shadowColor: '#000', shadowOffset: { width: 0, height: 1 }, shadowOpacity: 0.1, shadowRadius: 4, elevation: 2 },
  arrowSymbol: { fontSize: 24, color: '#4361ee' },
  messageText: { fontSize: 16, fontWeight: 'bold', color: '#e74c3c', marginTop: 2 },
  flagsText: { fontSize: 11, color: '#666', fontFamily: 'SpaceMono', marginTop: 2 },
  description: { fontSize: 14, color: '#333', textAlign: 'center', padding: 12, lineHeight: 22 },
});
