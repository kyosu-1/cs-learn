import { useState } from 'react';
import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';

type Props = {
  type: 'half' | 'full';
};

export default function AdderViz({ type }: Props) {
  const [a, setA] = useState(0);
  const [b, setB] = useState(0);
  const [cin, setCin] = useState(0);

  const sum = type === 'half' ? a ^ b : a ^ b ^ cin;
  const cout = type === 'half' ? a & b : (a & b) | (cin & (a ^ b));

  const wireColor = (v: number) => v ? '#4361ee' : '#ddd';
  const bitStyle = (v: number) => [styles.bit, v ? styles.bitHigh : styles.bitLow];

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{type === 'half' ? '半加算器' : '全加算器'}</Text>
      <Text style={styles.subtitle}>
        {type === 'half' ? 'Sum = A ⊕ B, Carry = A · B' : 'Sum = A ⊕ B ⊕ Cᵢₙ, Cₒᵤₜ = A·B + Cᵢₙ·(A ⊕ B)'}
      </Text>

      <View style={styles.circuit}>
        {/* Inputs */}
        <View style={styles.inputArea}>
          <TouchableOpacity onPress={() => setA(a ? 0 : 1)} style={bitStyle(a)}>
            <Text style={styles.bitLabel}>A</Text>
            <Text style={styles.bitValue}>{a}</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => setB(b ? 0 : 1)} style={bitStyle(b)}>
            <Text style={styles.bitLabel}>B</Text>
            <Text style={styles.bitValue}>{b}</Text>
          </TouchableOpacity>

          {type === 'full' && (
            <TouchableOpacity onPress={() => setCin(cin ? 0 : 1)} style={bitStyle(cin)}>
              <Text style={styles.bitLabel}>Cᵢₙ</Text>
              <Text style={styles.bitValue}>{cin}</Text>
            </TouchableOpacity>
          )}
        </View>

        {/* Adder block */}
        <View style={styles.adderBlock}>
          <View style={styles.adderBox}>
            <Text style={styles.adderSymbol}>{type === 'half' ? 'HA' : 'FA'}</Text>
            <Text style={styles.adderLabel}>{type === 'half' ? 'Half Adder' : 'Full Adder'}</Text>
          </View>

          {/* Internal representation */}
          <View style={styles.internalOps}>
            <View style={styles.opRow}>
              <View style={[styles.opGate, { borderColor: wireColor(a ^ b) }]}>
                <Text style={styles.opText}>XOR</Text>
              </View>
              <View style={[styles.opWire, { backgroundColor: wireColor(sum) }]} />
              <Text style={styles.opResult}>{type === 'half' ? `${a}⊕${b}=${a ^ b}` : `${a}⊕${b}⊕${cin}=${sum}`}</Text>
            </View>
            <View style={styles.opRow}>
              <View style={[styles.opGate, { borderColor: wireColor(a & b) }]}>
                <Text style={styles.opText}>AND</Text>
              </View>
              <View style={[styles.opWire, { backgroundColor: wireColor(cout) }]} />
              <Text style={styles.opResult}>{type === 'half' ? `${a}·${b}=${a & b}` : `carry=${cout}`}</Text>
            </View>
          </View>
        </View>

        {/* Outputs */}
        <View style={styles.outputArea}>
          <View style={bitStyle(sum)}>
            <Text style={styles.bitLabel}>Sum</Text>
            <Text style={styles.bitValue}>{sum}</Text>
          </View>

          <View style={bitStyle(cout)}>
            <Text style={styles.bitLabel}>Cₒᵤₜ</Text>
            <Text style={styles.bitValue}>{cout}</Text>
          </View>
        </View>
      </View>

      <Text style={styles.equation}>
        {type === 'half'
          ? `${a} + ${b} = ${cout}${sum}₂ (= ${a + b}₁₀)`
          : `${a} + ${b} + ${cin} = ${cout}${sum}₂ (= ${a + b + cin}₁₀)`
        }
      </Text>

      <Text style={styles.tapHint}>ビットをタップして切り替え</Text>

      {/* Ripple carry preview for full adder */}
      {type === 'full' && (
        <View style={styles.ripplePreview}>
          <Text style={styles.rippleTitle}>4ビット リプルキャリー加算器</Text>
          <RippleCarryDemo />
        </View>
      )}
    </View>
  );
}

function RippleCarryDemo() {
  const [numA, setNumA] = useState(5);  // 0101
  const [numB, setNumB] = useState(3);  // 0011

  const bitsA = [(numA >> 3) & 1, (numA >> 2) & 1, (numA >> 1) & 1, numA & 1];
  const bitsB = [(numB >> 3) & 1, (numB >> 2) & 1, (numB >> 1) & 1, numB & 1];

  // Compute carries and sums
  let carry = 0;
  const carries: number[] = [0];
  const sums: number[] = [];
  for (let i = 3; i >= 0; i--) {
    const s = bitsA[i] ^ bitsB[i] ^ carry;
    const c = (bitsA[i] & bitsB[i]) | (carry & (bitsA[i] ^ bitsB[i]));
    sums.unshift(s);
    carry = c;
    carries.unshift(c);
  }

  const cycleA = () => setNumA((numA + 1) % 16);
  const cycleB = () => setNumB((numB + 1) % 16);

  return (
    <View style={styles.ripple}>
      <View style={styles.rippleRow}>
        <Text style={styles.rippleLabel}>Carry:</Text>
        {carries.slice(0, 4).map((c, i) => (
          <View key={i} style={[styles.rippleBit, c ? styles.rippleBitHigh : styles.rippleBitCarry]}>
            <Text style={styles.rippleBitText}>{c}</Text>
          </View>
        ))}
        <Text style={styles.rippleValue}></Text>
      </View>
      <TouchableOpacity onPress={cycleA} style={styles.rippleRow}>
        <Text style={styles.rippleLabel}>A:</Text>
        {bitsA.map((b, i) => (
          <View key={i} style={[styles.rippleBit, b ? styles.rippleBitHigh : null]}>
            <Text style={styles.rippleBitText}>{b}</Text>
          </View>
        ))}
        <Text style={styles.rippleValue}>= {numA}</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={cycleB} style={styles.rippleRow}>
        <Text style={styles.rippleLabel}>B:</Text>
        {bitsB.map((b, i) => (
          <View key={i} style={[styles.rippleBit, b ? styles.rippleBitHigh : null]}>
            <Text style={styles.rippleBitText}>{b}</Text>
          </View>
        ))}
        <Text style={styles.rippleValue}>= {numB}</Text>
      </TouchableOpacity>
      <View style={styles.rippleDivider} />
      <View style={styles.rippleRow}>
        <Text style={styles.rippleLabel}>Sum:</Text>
        {[carries[0], ...sums].map((b, i) => (
          <View key={i} style={[styles.rippleBit, b ? styles.rippleBitResult : null]}>
            <Text style={styles.rippleBitText}>{b}</Text>
          </View>
        ))}
        <Text style={styles.rippleValue}>= {numA + numB}</Text>
      </View>
      <Text style={styles.tapHint}>A, B をタップして値を変更</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa' },
  title: { fontSize: 22, fontWeight: 'bold', color: '#1a1a2e', textAlign: 'center', paddingTop: 16 },
  subtitle: { fontSize: 13, color: '#4361ee', textAlign: 'center', fontFamily: 'SpaceMono', marginTop: 4 },
  circuit: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', padding: 20, gap: 12 },
  inputArea: { gap: 10, alignItems: 'center' },
  outputArea: { gap: 10, alignItems: 'center' },
  bit: { width: 56, height: 56, borderRadius: 12, justifyContent: 'center', alignItems: 'center', borderWidth: 2 },
  bitLow: { backgroundColor: '#f0f0f0', borderColor: '#ccc' },
  bitHigh: { backgroundColor: '#4361ee', borderColor: '#3451de' },
  bitLabel: { fontSize: 11, color: '#999', fontWeight: '600' },
  bitValue: { fontSize: 22, fontWeight: 'bold', color: '#1a1a2e' },
  adderBlock: { alignItems: 'center' },
  adderBox: {
    width: 80, height: 70, borderRadius: 8, backgroundColor: '#fff', borderWidth: 2, borderColor: '#1a1a2e',
    justifyContent: 'center', alignItems: 'center',
    shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 4, elevation: 3,
  },
  adderSymbol: { fontSize: 20, fontWeight: 'bold', color: '#1a1a2e' },
  adderLabel: { fontSize: 9, color: '#999' },
  internalOps: { marginTop: 8, gap: 4 },
  opRow: { flexDirection: 'row', alignItems: 'center', gap: 4 },
  opGate: { paddingHorizontal: 6, paddingVertical: 2, borderWidth: 1, borderRadius: 4 },
  opText: { fontSize: 10, fontWeight: '600', color: '#666' },
  opWire: { width: 12, height: 2, borderRadius: 1 },
  opResult: { fontSize: 11, color: '#666', fontFamily: 'SpaceMono' },
  equation: { fontSize: 18, fontWeight: '600', color: '#1a1a2e', textAlign: 'center', marginTop: 12, fontFamily: 'SpaceMono' },
  tapHint: { fontSize: 12, color: '#999', textAlign: 'center', marginTop: 6 },
  ripplePreview: { marginTop: 24, padding: 16, backgroundColor: '#fff', borderRadius: 12, marginHorizontal: 8 },
  rippleTitle: { fontSize: 16, fontWeight: '600', color: '#1a1a2e', marginBottom: 12, textAlign: 'center' },
  ripple: { gap: 6 },
  rippleRow: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 4 },
  rippleLabel: { width: 45, fontSize: 13, color: '#666', fontWeight: '600', textAlign: 'right' },
  rippleBit: {
    width: 36, height: 36, borderRadius: 6, backgroundColor: '#f0f0f0',
    justifyContent: 'center', alignItems: 'center', borderWidth: 1, borderColor: '#e0e0e0',
  },
  rippleBitHigh: { backgroundColor: '#4361ee', borderColor: '#3451de' },
  rippleBitCarry: { backgroundColor: '#f8f9fa', borderColor: '#ddd' },
  rippleBitResult: { backgroundColor: '#2ecc71', borderColor: '#27ae60' },
  rippleBitText: { fontSize: 16, fontWeight: 'bold', color: '#1a1a2e' },
  rippleValue: { width: 40, fontSize: 14, color: '#666', fontFamily: 'SpaceMono', marginLeft: 8 },
  rippleDivider: { height: 2, backgroundColor: '#1a1a2e', marginHorizontal: 50, marginVertical: 4 },
});
