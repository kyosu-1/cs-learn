import { StyleSheet, Text, View } from 'react-native';

type Props = {
  type: 'info' | 'tip' | 'warning';
  text: string;
};

const config = {
  info: { bg: '#e8f4fd', border: '#2196f3', icon: 'i', label: '情報' },
  tip: { bg: '#e8f5e9', border: '#4caf50', icon: '✓', label: 'ヒント' },
  warning: { bg: '#fff3e0', border: '#ff9800', icon: '!', label: '注意' },
};

export default function CalloutBlock({ type, text }: Props) {
  const c = config[type] || config.info;

  return (
    <View style={[styles.container, { backgroundColor: c.bg, borderLeftColor: c.border }]}>
      <View style={styles.header}>
        <View style={[styles.iconBadge, { backgroundColor: c.border }]}>
          <Text style={styles.icon}>{c.icon}</Text>
        </View>
        <Text style={[styles.label, { color: c.border }]}>{c.label}</Text>
      </View>
      <Text style={styles.text}>{text}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    borderLeftWidth: 4,
    borderRadius: 8,
    padding: 16,
    marginVertical: 8,
  },
  header: { flexDirection: 'row', alignItems: 'center', marginBottom: 8 },
  iconBadge: {
    width: 20,
    height: 20,
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 8,
  },
  icon: { color: '#fff', fontSize: 12, fontWeight: 'bold' },
  label: { fontSize: 14, fontWeight: '600' },
  text: { fontSize: 15, lineHeight: 24, color: '#333' },
});
