import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';

type Option = { id: string; text: string };

type Props = {
  options: Option[];
  selected: string | null;
  onSelect: (id: string) => void;
  disabled?: boolean;
  correctAnswer?: string;
};

export default function MultipleChoice({ options, selected, onSelect, disabled, correctAnswer }: Props) {
  return (
    <View style={styles.container}>
      {options.map((option) => {
        const isSelected = selected === option.id;
        const isCorrect = correctAnswer === option.id;
        const showResult = disabled && correctAnswer;

        let borderColor = '#e0e0e0';
        let backgroundColor = '#fff';
        if (showResult && isCorrect) {
          borderColor = '#4caf50';
          backgroundColor = '#e8f5e9';
        } else if (showResult && isSelected && !isCorrect) {
          borderColor = '#e74c3c';
          backgroundColor = '#fde8e8';
        } else if (isSelected) {
          borderColor = '#4361ee';
          backgroundColor = '#e8edff';
        }

        return (
          <TouchableOpacity
            key={option.id}
            style={[styles.option, { borderColor, backgroundColor }]}
            onPress={() => onSelect(option.id)}
            disabled={disabled}
          >
            <View style={[styles.radio, isSelected && styles.radioSelected]}>
              {isSelected && <View style={styles.radioInner} />}
            </View>
            <Text style={styles.optionText}>{option.text}</Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { gap: 10 },
  option: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    borderRadius: 12,
    borderWidth: 2,
  },
  radio: {
    width: 22,
    height: 22,
    borderRadius: 11,
    borderWidth: 2,
    borderColor: '#ccc',
    marginRight: 12,
    justifyContent: 'center',
    alignItems: 'center',
  },
  radioSelected: { borderColor: '#4361ee' },
  radioInner: { width: 12, height: 12, borderRadius: 6, backgroundColor: '#4361ee' },
  optionText: { fontSize: 16, color: '#333', flex: 1 },
});
