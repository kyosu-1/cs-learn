import { StyleSheet, Text, View, ScrollView } from 'react-native';

type Props = {
  language: string;
  code: string;
};

export default function CodeBlock({ language, code }: Props) {
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.language}>{language}</Text>
      </View>
      <ScrollView horizontal style={styles.codeScroll}>
        <Text style={styles.code}>{code}</Text>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#1e1e2e',
    borderRadius: 12,
    overflow: 'hidden',
    marginVertical: 8,
  },
  header: {
    backgroundColor: '#2d2d3f',
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  language: { color: '#a0a0c0', fontSize: 12, fontWeight: '600', textTransform: 'uppercase' },
  codeScroll: { padding: 16 },
  code: {
    fontFamily: 'SpaceMono',
    fontSize: 14,
    lineHeight: 22,
    color: '#e0e0ff',
  },
});
