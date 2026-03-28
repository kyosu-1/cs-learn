import { useState } from 'react';
import { StyleSheet, Text, View, TextInput, TouchableOpacity, Alert, ActivityIndicator } from 'react-native';
import { Link, router } from 'expo-router';
import { apiClient } from '@/lib/api';
import { useAuthStore } from '@/stores/authStore';
import type { User, AuthTokens } from '@/lib/types';

type RegisterResponse = {
  user: User;
  tokens: AuthTokens;
};

export default function RegisterScreen() {
  const [displayName, setDisplayName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const setAuth = useAuthStore((s) => s.setAuth);

  const handleRegister = async () => {
    if (!displayName || !email || !password) {
      Alert.alert('エラー', 'すべての項目を入力してください');
      return;
    }
    if (password.length < 8) {
      Alert.alert('エラー', 'パスワードは8文字以上にしてください');
      return;
    }

    setLoading(true);
    try {
      const data = await apiClient<RegisterResponse>('/auth/register', {
        method: 'POST',
        body: { email, password, display_name: displayName },
      });
      await setAuth(data.user, data.tokens.access_token, data.tokens.refresh_token);
      router.replace('/(tabs)');
    } catch (err) {
      Alert.alert('登録失敗', err instanceof Error ? err.message : 'エラーが発生しました');
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.logo}>CS Learn</Text>
        <Text style={styles.subtitle}>アカウントを作成</Text>
      </View>

      <View style={styles.form}>
        <TextInput
          style={styles.input}
          placeholder="表示名"
          value={displayName}
          onChangeText={setDisplayName}
        />
        <TextInput
          style={styles.input}
          placeholder="メールアドレス"
          value={email}
          onChangeText={setEmail}
          keyboardType="email-address"
          autoCapitalize="none"
        />
        <TextInput
          style={styles.input}
          placeholder="パスワード（8文字以上）"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
        />
        <TouchableOpacity style={styles.button} onPress={handleRegister} disabled={loading}>
          {loading ? (
            <ActivityIndicator color="#fff" />
          ) : (
            <Text style={styles.buttonText}>登録</Text>
          )}
        </TouchableOpacity>

        <Link href="/(auth)/login" style={styles.link}>
          <Text style={styles.linkText}>すでにアカウントをお持ちの方</Text>
        </Link>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f8f9fa', justifyContent: 'center', padding: 24 },
  header: { alignItems: 'center', marginBottom: 48 },
  logo: { fontSize: 36, fontWeight: 'bold', color: '#4361ee' },
  subtitle: { fontSize: 20, color: '#1a1a2e', marginTop: 8, fontWeight: '600' },
  form: { gap: 16 },
  input: {
    backgroundColor: '#fff',
    borderRadius: 12,
    padding: 16,
    fontSize: 16,
    borderWidth: 1,
    borderColor: '#e0e0e0',
  },
  button: {
    backgroundColor: '#4361ee',
    borderRadius: 12,
    padding: 16,
    alignItems: 'center',
    marginTop: 8,
  },
  buttonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
  link: { alignSelf: 'center', marginTop: 16 },
  linkText: { color: '#4361ee', fontSize: 14 },
});
