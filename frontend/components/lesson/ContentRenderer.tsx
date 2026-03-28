import { View } from 'react-native';
import type { LessonBlock } from '@/lib/types';
import MarkdownBlock from './MarkdownBlock';
import CodeBlock from './CodeBlock';
import CalloutBlock from './CalloutBlock';
import DiagramBlock from './DiagramBlock';

type Props = {
  blocks: LessonBlock[];
};

export default function ContentRenderer({ blocks }: Props) {
  return (
    <View>
      {blocks.map((block) => {
        const content = block.content as Record<string, any>;

        switch (block.block_type) {
          case 'markdown':
            return <MarkdownBlock key={block.id} text={content.text} />;
          case 'code':
            return (
              <CodeBlock
                key={block.id}
                language={content.language}
                code={content.code}
              />
            );
          case 'callout':
            return (
              <CalloutBlock
                key={block.id}
                type={content.type}
                text={content.text}
              />
            );
          case 'diagram':
            return (
              <DiagramBlock
                key={block.id}
                source={content.source}
                diagramType={content.diagram_type}
              />
            );
          default:
            return null;
        }
      })}
    </View>
  );
}
