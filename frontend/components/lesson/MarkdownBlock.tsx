import { StyleSheet } from 'react-native';
import Markdown from 'react-native-markdown-display';

type Props = {
  text: string;
};

export default function MarkdownBlock({ text }: Props) {
  return (
    <Markdown style={markdownStyles}>
      {text}
    </Markdown>
  );
}

const markdownStyles = StyleSheet.create({
  body: { fontSize: 16, lineHeight: 26, color: '#333' },
  heading1: { fontSize: 26, fontWeight: 'bold', color: '#1a1a2e', marginBottom: 12, marginTop: 8 },
  heading2: { fontSize: 22, fontWeight: '600', color: '#1a1a2e', marginBottom: 8, marginTop: 20 },
  heading3: { fontSize: 18, fontWeight: '600', color: '#1a1a2e', marginBottom: 6, marginTop: 14 },
  paragraph: { fontSize: 16, lineHeight: 26, color: '#333', marginBottom: 10 },
  strong: { fontWeight: 'bold', color: '#1a1a2e' },
  em: { fontStyle: 'italic' },
  link: { color: '#4361ee', textDecorationLine: 'underline' },
  blockquote: {
    backgroundColor: '#f0f4ff',
    borderLeftWidth: 4,
    borderLeftColor: '#4361ee',
    paddingHorizontal: 16,
    paddingVertical: 8,
    marginVertical: 8,
  },
  code_inline: {
    backgroundColor: '#f0f0f5',
    color: '#e74c3c',
    fontFamily: 'SpaceMono',
    fontSize: 14,
    paddingHorizontal: 5,
    paddingVertical: 1,
    borderRadius: 4,
  },
  code_block: {
    backgroundColor: '#1e1e2e',
    color: '#e0e0ff',
    fontFamily: 'SpaceMono',
    fontSize: 14,
    lineHeight: 22,
    padding: 16,
    borderRadius: 12,
    marginVertical: 8,
  },
  fence: {
    backgroundColor: '#1e1e2e',
    color: '#e0e0ff',
    fontFamily: 'SpaceMono',
    fontSize: 14,
    lineHeight: 22,
    padding: 16,
    borderRadius: 12,
    marginVertical: 8,
  },
  list_item: { flexDirection: 'row', marginVertical: 2 },
  bullet_list: { marginVertical: 4 },
  ordered_list: { marginVertical: 4 },
  bullet_list_icon: { color: '#4361ee', fontSize: 16, marginRight: 8 },
  ordered_list_icon: { color: '#4361ee', fontSize: 16, marginRight: 8 },
  table: { borderWidth: 1, borderColor: '#e0e0e0', borderRadius: 8, marginVertical: 8 },
  thead: { backgroundColor: '#f0f4ff' },
  th: { padding: 10, fontWeight: '600', fontSize: 14, color: '#1a1a2e', borderWidth: 0.5, borderColor: '#e0e0e0' },
  td: { padding: 10, fontSize: 14, color: '#333', borderWidth: 0.5, borderColor: '#e0e0e0' },
  tr: { borderBottomWidth: 1, borderColor: '#e0e0e0' },
  hr: { backgroundColor: '#e0e0e0', height: 1, marginVertical: 16 },
});
