-- Quiz: OSI/TCP/IP
INSERT INTO quizzes (id, category_id, title, difficulty_level, is_published)
VALUES ('d2000000-0000-0000-0000-000000000001', 'c2000000-0000-0000-0000-000000000001',
  'ネットワーク基礎クイズ', 1, true);

INSERT INTO questions (id, quiz_id, question_type, prompt, options, correct_answer, explanation, sort_order, points) VALUES
('f1000000-0000-0000-0000-000000000001', 'd2000000-0000-0000-0000-000000000001',
  'multiple_choice', 'OSI参照モデルでルーティングを担当するのは第何層？',
  '[{"id":"a","text":"第2層（データリンク層）"},{"id":"b","text":"第3層（ネットワーク層）"},{"id":"c","text":"第4層（トランスポート層）"},{"id":"d","text":"第5層（セッション層）"}]',
  '{"answer":"b"}',
  'ネットワーク層（第3層）がIPアドレスに基づくルーティングを担当します。',
  1, 10),
('f1000000-0000-0000-0000-000000000002', 'd2000000-0000-0000-0000-000000000001',
  'fill_in_blank', 'TCP/IPモデルは___層で構成されている。',
  NULL, '{"answers":["4","四"]}',
  'TCP/IPモデルはアプリケーション層、トランスポート層、インターネット層、ネットワークインターフェース層の4層です。',
  2, 10);

-- Quiz: トランスポート層
INSERT INTO quizzes (id, category_id, title, difficulty_level, is_published)
VALUES ('d2000000-0000-0000-0000-000000000002', 'c2000000-0000-0000-0000-000000000002',
  'TCP/UDPクイズ', 1, true);

INSERT INTO questions (id, quiz_id, question_type, prompt, options, correct_answer, explanation, sort_order, points) VALUES
('f1000000-0000-0000-0000-000000000003', 'd2000000-0000-0000-0000-000000000002',
  'multiple_choice', 'TCPの接続確立に使われる手順は？',
  '[{"id":"a","text":"2ウェイハンドシェイク"},{"id":"b","text":"3ウェイハンドシェイク"},{"id":"c","text":"4ウェイハンドシェイク"},{"id":"d","text":"ハンドシェイクは不要"}]',
  '{"answer":"b"}',
  'TCPは SYN → SYN+ACK → ACK の3ウェイハンドシェイクで接続を確立します。',
  1, 10),
('f1000000-0000-0000-0000-000000000004', 'd2000000-0000-0000-0000-000000000002',
  'multiple_choice', '動画ストリーミングやオンラインゲームに適したプロトコルは？',
  '[{"id":"a","text":"TCP"},{"id":"b","text":"UDP"},{"id":"c","text":"ICMP"},{"id":"d","text":"ARP"}]',
  '{"answer":"b"}',
  'UDPはコネクションレスで低遅延のため、リアルタイム性が求められるストリーミングやゲームに適しています。',
  2, 10),
('f1000000-0000-0000-0000-000000000005', 'd2000000-0000-0000-0000-000000000002',
  'true_false', 'UDPはデータの順序保証と再送制御を提供する。',
  '[{"id":"true","text":"正しい"},{"id":"false","text":"誤り"}]',
  '{"answer":false}',
  'UDPは順序保証も再送制御も提供しません。これらが必要な場合はTCPを使うか、アプリケーション側で実装します。',
  3, 10);

-- Quiz: アプリケーション層
INSERT INTO quizzes (id, category_id, title, difficulty_level, is_published)
VALUES ('d2000000-0000-0000-0000-000000000003', 'c2000000-0000-0000-0000-000000000003',
  'HTTP/DNSクイズ', 1, true);

INSERT INTO questions (id, quiz_id, question_type, prompt, options, correct_answer, explanation, sort_order, points) VALUES
('f1000000-0000-0000-0000-000000000006', 'd2000000-0000-0000-0000-000000000003',
  'multiple_choice', 'HTTPステータスコード 404 の意味は？',
  '[{"id":"a","text":"サーバーエラー"},{"id":"b","text":"リダイレクト"},{"id":"c","text":"リソースが見つからない"},{"id":"d","text":"認証が必要"}]',
  '{"answer":"c"}',
  '404 Not Found はリクエストされたリソースがサーバー上に存在しないことを示します。',
  1, 10),
('f1000000-0000-0000-0000-000000000007', 'd2000000-0000-0000-0000-000000000003',
  'multiple_choice', 'DNSが主に使用するトランスポートプロトコルは？',
  '[{"id":"a","text":"TCP"},{"id":"b","text":"UDP"},{"id":"c","text":"HTTP"},{"id":"d","text":"ICMP"}]',
  '{"answer":"b"}',
  'DNSは通常UDPポート53を使用します。応答が512バイトを超える場合はTCPにフォールバックします。',
  2, 10),
('f1000000-0000-0000-0000-000000000008', 'd2000000-0000-0000-0000-000000000003',
  'multiple_choice', 'HTTP/3 が使用するトランスポートプロトコルは？',
  '[{"id":"a","text":"TCP"},{"id":"b","text":"UDP上のQUIC"},{"id":"c","text":"SCTP"},{"id":"d","text":"ICMP"}]',
  '{"answer":"b"}',
  'HTTP/3はQUICプロトコル上で動作します。QUICはUDP上に構築され、TCPのHoLブロッキング問題を解消します。',
  3, 10);

-- Quiz: セキュリティ
INSERT INTO quizzes (id, category_id, title, difficulty_level, is_published)
VALUES ('d2000000-0000-0000-0000-000000000004', 'c2000000-0000-0000-0000-000000000005',
  'ネットワークセキュリティクイズ', 2, true);

INSERT INTO questions (id, quiz_id, question_type, prompt, options, correct_answer, explanation, sort_order, points) VALUES
('f1000000-0000-0000-0000-000000000009', 'd2000000-0000-0000-0000-000000000004',
  'multiple_choice', 'HTTPS のデフォルトポート番号は？',
  '[{"id":"a","text":"80"},{"id":"b","text":"443"},{"id":"c","text":"8080"},{"id":"d","text":"22"}]',
  '{"answer":"b"}',
  'HTTPSはポート443を使用します（HTTPはポート80）。',
  1, 10),
('f1000000-0000-0000-0000-000000000010', 'd2000000-0000-0000-0000-000000000004',
  'true_false', 'TLS 1.3 では接続確立に1-RTT（1往復）で済む。',
  '[{"id":"true","text":"正しい"},{"id":"false","text":"誤り"}]',
  '{"answer":true}',
  'TLS 1.3はハンドシェイクを最適化し、1-RTTで接続確立が完了します（TLS 1.2は2-RTT）。',
  2, 10);
