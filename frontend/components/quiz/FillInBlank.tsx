import { StyleSheet, TextInput, View } from 'react-native';

type Props = {
  value: string;
  onChange: (text: string) => void;
  disabled?: boolean;
};

export default function FillInBlank({ value, onChange, disabled }: Props) {
  return (
    <View style={styles.container}>
      <TextInput
        style={styles.input}
        value={value}
        onChangeText={onChange}
        placeholder="回答を入力..."
        editable={!disabled}
        autoCapitalize="none"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { marginVertical: 8 },
  input: {
    backgroundColor: '#fff',
    borderWidth: 2,
    borderColor: '#e0e0e0',
    borderRadius: 12,
    padding: 16,
    fontSize: 18,
    fontFamily: 'SpaceMono',
  },
});
