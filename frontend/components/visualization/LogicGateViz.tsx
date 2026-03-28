import { useState } from 'react';
import { StyleSheet, Text, View, TouchableOpacity, ScrollView } from 'react-native';

type GateType = 'AND' | 'OR' | 'NOT' | 'NAND' | 'NOR' | 'XOR';

type Props = {
  gateType: GateType;
};

function computeGate(gate: GateType, a: number, b: number): number {
  switch (gate) {
    case 'AND': return a & b;
    case 'OR': return a | b;
    case 'NOT': return a ? 0 : 1;
    case 'NAND': return (a & b) ? 0 : 1;
    case 'NOR': return (a | b) ? 0 : 1;
    case 'XOR': return a ^ b;
  }
}

const gateSymbols: Record<GateType, string> = {
  AND: '&', OR: '≥1', NOT: '1', NAND: '&', NOR: '≥1', XOR: '=1',
};

const gateExpressions: Record<GateType, string> = {
  AND: 'Y = A · B', OR: 'Y = A + B', NOT: 'Y = A\'',
  NAND: 'Y = (A · B)\'', NOR: 'Y = (A + B)\'', XOR: 'Y = A ⊕ B',
};

const isInverted = (gate: GateType) => gate === 'NAND' || gate === 'NOR' || gate === 'NOT';
const isSingleInput = (gate: GateType) => gate === 'NOT';

export default function LogicGateViz({ gateType }: Props) {
  const [inputA, setInputA] = useState(0);
  const [inputB, setInputB] = useState(0);
  const output = computeGate(gateType, inputA, inputB);

  const wireColor = (val: number) => val ? '#4361ee' : '#ccc';
  const dotColor = (val: number) => val ? '#4361ee' : '#e0e0e0';

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{gateType} ゲート</Text>
      <Text style={styles.expression}>{gateExpressions[gateType]}</Text>

      {/* Interactive circuit diagram */}
      <View style={styles.circuit}>
        {/* Input A */}
        <View style={styles.inputColumn}>
          <TouchableOpacity
            style={[styles.inputButton, { backgroundColor: dotColor(inputA) }]}
            onPress={() => setInputA(inputA ? 0 : 1)}
          >
            <Text style={[styles.inputText, inputA === 1 && styles.inputTextActive]}>A = {inputA}</Text>
          </TouchableOpacity>

          {!isSingleInput(gateType) && (
            <TouchableOpacity
              style={[styles.inputButton, { backgroundColor: dotColor(inputB) }]}
              onPress={() => setInputB(inputB ? 0 : 1)}
            >
              <Text style={[styles.inputText, inputB === 1 && styles.inputTextActive]}>B = {inputB}</Text>
            </TouchableOpacity>
          )}
        </View>

        {/* Wires in */}
        <View style={styles.wireColumn}>
          <View style={[styles.wire, { backgroundColor: wireColor(inputA) }]} />
          {!isSingleInput(gateType) && (
            <View style={[styles.wire, { backgroundColor: wireColor(inputB) }]} />
          )}
        </View>

        {/* Gate body */}
        <View style={[styles.gateBody, isInverted(gateType) && styles.gateBodyInverted]}>
          <Text style={styles.gateSymbol}>{gateSymbols[gateType]}</Text>
          {isInverted(gateType) && <View style={styles.invertDot} />}
        </View>

        {/* Wire out */}
        <View style={styles.wireColumn}>
          <View style={[styles.wire, { backgroundColor: wireColor(output) }]} />
        </View>

        {/* Output */}
        <View style={[styles.outputBox, { backgroundColor: dotColor(output) }]}>
          <Text style={[styles.outputText, output === 1 && styles.outputTextActive]}>Y = {output}</Text>
        </View>
      </View>

      <Text style={styles.tapHint}>入力をタップして切り替え</Text>

      {/* Truth table */}
      <View style={styles.truthTable}>
        <Text style={styles.tableTitle}>真理値表</Text>
        <View style={styles.tableHeader}>
          <Text style={styles.th}>A</Text>
          {!isSingleInput(gateType) && <Text style={styles.th}>B</Text>}
          <Text style={styles.th}>Y</Text>
        </View>
        {(isSingleInput(gateType) ? [[0], [1]] : [[0, 0], [0, 1], [1, 0], [1, 1]]).map((inputs, i) => {
          const a = inputs[0];
          const b = inputs.length > 1 ? inputs[1] : 0;
          const y = computeGate(gateType, a, b);
          const isActive = a === inputA && (isSingleInput(gateType) || b === inputB);
          return (
            <View key={i} style={[styles.tableRow, isActive && styles.tableRowActive]}>
              <Text style={[styles.td, isActive && styles.tdActive]}>{a}</Text>
              {!isSingleInput(gateType) && <Text style={[styles.td, isActive && styles.tdActive]}>{b}</Text>}
              <Text style={[styles.td, styles.tdResult, isActive && styles.tdActive, y === 1 && styles.tdHigh]}>{y}</Text>
            </View>
          );
        })}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa', padding: 16 },
  title: { fontSize: 22, fontWeight: 'bold', color: '#1a1a2e', textAlign: 'center' },
  expression: { fontSize: 16, color: '#4361ee', textAlign: 'center', fontFamily: 'SpaceMono', marginTop: 4, marginBottom: 16 },
  circuit: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingVertical: 20 },
  inputColumn: { gap: 16, alignItems: 'flex-end' },
  inputButton: {
    width: 70, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center',
    borderWidth: 2, borderColor: '#ccc',
  },
  inputText: { fontSize: 14, fontWeight: '600', color: '#666' },
  inputTextActive: { color: '#fff' },
  wireColumn: { width: 30, gap: 16, justifyContent: 'center' },
  wire: { height: 3, borderRadius: 1.5 },
  gateBody: {
    width: 60, height: 60, borderRadius: 8, backgroundColor: '#fff',
    borderWidth: 2, borderColor: '#1a1a2e', justifyContent: 'center', alignItems: 'center',
    shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 4, elevation: 3,
  },
  gateBodyInverted: { borderColor: '#e74c3c' },
  gateSymbol: { fontSize: 18, fontWeight: 'bold', color: '#1a1a2e' },
  invertDot: {
    position: 'absolute', right: -8, width: 12, height: 12, borderRadius: 6,
    backgroundColor: '#fff', borderWidth: 2, borderColor: '#e74c3c',
  },
  outputBox: {
    width: 70, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center',
    borderWidth: 2, borderColor: '#ccc',
  },
  outputText: { fontSize: 14, fontWeight: '600', color: '#666' },
  outputTextActive: { color: '#fff' },
  tapHint: { fontSize: 12, color: '#999', textAlign: 'center', marginTop: 8 },
  truthTable: {
    marginTop: 20, backgroundColor: '#fff', borderRadius: 12, padding: 16,
    shadowColor: '#000', shadowOffset: { width: 0, height: 1 }, shadowOpacity: 0.05, shadowRadius: 4, elevation: 2,
  },
  tableTitle: { fontSize: 16, fontWeight: '600', color: '#1a1a2e', marginBottom: 12, textAlign: 'center' },
  tableHeader: { flexDirection: 'row', borderBottomWidth: 2, borderColor: '#e0e0e0', paddingBottom: 8 },
  th: { flex: 1, fontSize: 14, fontWeight: '700', color: '#1a1a2e', textAlign: 'center' },
  tableRow: { flexDirection: 'row', paddingVertical: 8, borderBottomWidth: 1, borderColor: '#f0f0f0' },
  tableRowActive: { backgroundColor: '#e8edff', borderRadius: 4 },
  td: { flex: 1, fontSize: 16, color: '#333', textAlign: 'center', fontFamily: 'SpaceMono' },
  tdActive: { fontWeight: 'bold', color: '#4361ee' },
  tdResult: { fontWeight: '600' },
  tdHigh: { color: '#2ecc71' },
});
