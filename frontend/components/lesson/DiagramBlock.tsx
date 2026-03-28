import { StyleSheet, View, useWindowDimensions } from 'react-native';
import { WebView } from 'react-native-webview';
import { Platform } from 'react-native';

type Props = {
  source: string;
  diagramType?: string;
};

export default function DiagramBlock({ source, diagramType }: Props) {
  const { width } = useWindowDimensions();
  const containerWidth = Math.min(width - 40, 700);

  const html = `<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
  <style>
    body { margin: 0; display: flex; justify-content: center; background: #f8f9fa; }
    .mermaid { font-family: -apple-system, BlinkMacSystemFont, sans-serif; }
    .mermaid svg { max-width: 100%; height: auto; }
  </style>
</head>
<body>
  <div class="mermaid">
${source}
  </div>
  <script>
    mermaid.initialize({
      startOnLoad: true,
      theme: 'base',
      themeVariables: {
        primaryColor: '#e8edff',
        primaryBorderColor: '#4361ee',
        primaryTextColor: '#1a1a2e',
        lineColor: '#4361ee',
        secondaryColor: '#f0f4ff',
        tertiaryColor: '#fff',
        fontSize: '14px'
      }
    });
  </script>
</body>
</html>`;

  if (Platform.OS === 'web') {
    return (
      <View style={[styles.container, { width: containerWidth }]}>
        <iframe
          srcDoc={html}
          style={{ width: '100%', height: 300, border: 'none', borderRadius: 12, background: '#f8f9fa' }}
          sandbox="allow-scripts"
        />
      </View>
    );
  }

  return (
    <View style={[styles.container, { width: containerWidth, height: 300 }]}>
      <WebView
        source={{ html }}
        style={styles.webview}
        scrollEnabled={false}
        javaScriptEnabled={true}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginVertical: 12,
    borderRadius: 12,
    overflow: 'hidden',
    backgroundColor: '#f8f9fa',
    alignSelf: 'center',
  },
  webview: {
    flex: 1,
    backgroundColor: 'transparent',
  },
});
