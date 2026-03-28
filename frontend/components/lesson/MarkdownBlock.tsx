import { StyleSheet, Text, View } from 'react-native';

type Props = {
  text: string;
};

export default function MarkdownBlock({ text }: Props) {
  const lines = text.split('\n');

  return (
    <View style={styles.container}>
      {lines.map((line, index) => {
        if (line.startsWith('# ')) {
          return <Text key={index} style={styles.h1}>{line.slice(2)}</Text>;
        }
        if (line.startsWith('## ')) {
          return <Text key={index} style={styles.h2}>{line.slice(3)}</Text>;
        }
        if (line.startsWith('### ')) {
          return <Text key={index} style={styles.h3}>{line.slice(4)}</Text>;
        }
        if (line.startsWith('- ')) {
          return (
            <View key={index} style={styles.listItem}>
              <Text style={styles.bullet}>•</Text>
              <Text style={styles.listText}>{line.slice(2)}</Text>
            </View>
          );
        }
        if (line.startsWith('| ')) {
          return (
            <Text key={index} style={styles.tableRow}>
              {line}
            </Text>
          );
        }
        if (line.trim() === '') {
          return <View key={index} style={styles.spacer} />;
        }
        return <Text key={index} style={styles.paragraph}>{line}</Text>;
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { paddingVertical: 4 },
  h1: { fontSize: 26, fontWeight: 'bold', color: '#1a1a2e', marginBottom: 12, marginTop: 8 },
  h2: { fontSize: 22, fontWeight: '600', color: '#1a1a2e', marginBottom: 8, marginTop: 16 },
  h3: { fontSize: 18, fontWeight: '600', color: '#1a1a2e', marginBottom: 6, marginTop: 12 },
  paragraph: { fontSize: 16, lineHeight: 26, color: '#333' },
  listItem: { flexDirection: 'row', paddingLeft: 8, marginVertical: 2 },
  bullet: { fontSize: 16, color: '#4361ee', marginRight: 8, lineHeight: 26 },
  listText: { fontSize: 16, lineHeight: 26, color: '#333', flex: 1 },
  tableRow: { fontSize: 14, fontFamily: 'SpaceMono', color: '#333', lineHeight: 24 },
  spacer: { height: 8 },
});
