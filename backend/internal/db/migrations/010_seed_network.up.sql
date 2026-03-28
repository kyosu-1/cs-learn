-- Topic: Computer Networks
INSERT INTO topics (id, slug, title, description, icon_name, sort_order, is_published)
VALUES (
  'a0000000-0000-0000-0000-000000000003',
  'computer-networks',
  'コンピュータネットワーク',
  'TCP/IP、HTTP、DNS、ルーティングなどネットワークの基礎から応用まで',
  'network',
  3,
  true
);

-- Categories
INSERT INTO categories (id, topic_id, slug, title, description, sort_order) VALUES
('c2000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000003', 'osi-tcpip', 'OSI参照モデルとTCP/IP', 'ネットワーク階層モデルの基礎', 1),
('c2000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000003', 'transport-layer', 'トランスポート層', 'TCP、UDP、ポート番号', 2),
('c2000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000003', 'application-layer', 'アプリケーション層', 'HTTP、DNS、DHCP', 3),
('c2000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000003', 'network-layer', 'ネットワーク層', 'IP、ルーティング、サブネット', 4),
('c2000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000003', 'security', 'ネットワークセキュリティ', 'TLS、暗号化、ファイアウォール', 5);

-- ===== Lessons: OSI参照モデルとTCP/IP =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000001', 'c2000000-0000-0000-0000-000000000001', 'osi-model',
  'OSI参照モデル', 'ネットワーク通信の7階層モデル', 1, 15, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000001', 'markdown', '{"text": "# OSI参照モデル\n\nOSI参照モデルは、ネットワーク通信を**7つの層（レイヤー）**に分割して整理したモデルです。\n\n各層は特定の機能を担当し、上位層にサービスを提供します。"}', 0),
('30000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## 7つの層\n\n| 層 | 名称 | 役割 | プロトコル例 |\n|---|---|---|---|\n| 7 | アプリケーション層 | ユーザーへのサービス提供 | HTTP, SMTP, DNS |\n| 6 | プレゼンテーション層 | データ形式の変換・暗号化 | SSL/TLS, JPEG |\n| 5 | セッション層 | 通信の確立・維持・終了 | NetBIOS |\n| 4 | トランスポート層 | エンドツーエンドの信頼性 | TCP, UDP |\n| 3 | ネットワーク層 | ルーティング・論理アドレス | IP, ICMP |\n| 2 | データリンク層 | フレーム化・物理アドレス | Ethernet, Wi-Fi |\n| 1 | 物理層 | ビット列の電気信号変換 | RS-232, USB |"}', 1),
('30000000-0000-0000-0000-000000000001', 'callout', '{"type": "tip", "text": "覚え方: 「アプセトネデブ」（ア=アプリケーション、プ=プレゼンテーション、セ=セッション、ト=トランスポート、ネ=ネットワーク、デ=データリンク、ブ=物理）"}', 2),
('30000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## TCP/IPモデルとの対応\n\nOSIは理論的なモデルですが、実際のインターネットは**TCP/IP**（4層モデル）で動いています:\n\n| TCP/IP | OSI対応 |\n|---|---|\n| アプリケーション層 | アプリ + プレゼン + セッション |\n| トランスポート層 | トランスポート層 |\n| インターネット層 | ネットワーク層 |\n| ネットワークインターフェース層 | データリンク + 物理 |"}', 3),
('30000000-0000-0000-0000-000000000001', 'callout', '{"type": "info", "text": "データは送信時に各層でヘッダーが付加され（カプセル化）、受信時に各層で取り除かれます（非カプセル化）。"}', 4);

-- ===== Lessons: トランスポート層 =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000002', 'c2000000-0000-0000-0000-000000000002', 'tcp-udp',
  'TCP と UDP', '信頼性のTCPと速度のUDP', 1, 18, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000002', 'markdown', '{"text": "# TCP と UDP\n\nトランスポート層の2大プロトコルである **TCP** と **UDP** は、アプリケーションの要件に応じて使い分けます。"}', 0),
('30000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## TCP（Transmission Control Protocol）\n\n**信頼性のある通信**を提供するコネクション型プロトコルです。\n\n### 3ウェイハンドシェイク（接続確立）\n1. クライアント → サーバー: **SYN**（接続要求）\n2. サーバー → クライアント: **SYN + ACK**（要求承認 + 応答）\n3. クライアント → サーバー: **ACK**（承認）\n\n### TCPの特徴\n- 順序保証: シーケンス番号でデータの順序を管理\n- 再送制御: ACKが返らないパケットを再送\n- フロー制御: ウィンドウサイズで送信速度を調整\n- 輻輳制御: ネットワーク混雑時に送信レートを抑制"}', 1),
('30000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## UDP（User Datagram Protocol）\n\n**軽量で高速**なコネクションレス型プロトコルです。\n\n- 接続確立のオーバーヘッドなし\n- 順序保証・再送なし（信頼性はアプリ側で担保）\n- ヘッダーが小さい（8バイト vs TCPの20バイト以上）\n\n**用途**: DNS、動画ストリーミング、オンラインゲーム、VoIP"}', 2),
('30000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## TCP vs UDP\n\n| | TCP | UDP |\n|---|---|---|\n| 接続 | コネクション型 | コネクションレス |\n| 信頼性 | あり（再送・順序保証） | なし |\n| 速度 | 遅い（オーバーヘッド大） | 速い |\n| ヘッダーサイズ | 20バイト以上 | 8バイト |\n| 用途 | Web、メール、ファイル転送 | DNS、ストリーミング、ゲーム |"}', 3),
('30000000-0000-0000-0000-000000000002', 'code', '{"language": "python", "code": "# TCP サーバー（簡易例）\nimport socket\n\nserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  # TCP\nserver.bind((\"localhost\", 8888))\nserver.listen(1)\nconn, addr = server.accept()\ndata = conn.recv(1024)\nconn.send(b\"Hello from TCP server\")\nconn.close()\n\n# UDP サーバー（簡易例）\nserver = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)   # UDP\nserver.bind((\"localhost\", 9999))\ndata, addr = server.recvfrom(1024)\nserver.sendto(b\"Hello from UDP server\", addr)", "runnable": false}', 4);

-- ===== Lessons: アプリケーション層 =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000003', 'c2000000-0000-0000-0000-000000000003', 'http-protocol',
  'HTTPプロトコル', 'Webの基盤となるプロトコル', 1, 15, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000003', 'markdown', '{"text": "# HTTPプロトコル\n\nHTTP（HyperText Transfer Protocol）は Web の基盤となるアプリケーション層プロトコルです。\n\nクライアント（ブラウザ）がリクエストを送り、サーバーがレスポンスを返す**リクエスト・レスポンス型**の通信モデルです。"}', 0),
('30000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## HTTPメソッド\n\n| メソッド | 用途 | べき等性 |\n|---|---|---|\n| GET | リソースの取得 | Yes |\n| POST | リソースの作成 | No |\n| PUT | リソースの置換 | Yes |\n| PATCH | リソースの部分更新 | No |\n| DELETE | リソースの削除 | Yes |\n| HEAD | ヘッダーのみ取得 | Yes |\n| OPTIONS | 対応メソッドの確認 | Yes |"}', 1),
('30000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## ステータスコード\n\n| 範囲 | 分類 | 例 |\n|---|---|---|\n| 1xx | 情報 | 100 Continue |\n| 2xx | 成功 | 200 OK, 201 Created, 204 No Content |\n| 3xx | リダイレクト | 301 Moved Permanently, 304 Not Modified |\n| 4xx | クライアントエラー | 400 Bad Request, 401 Unauthorized, 404 Not Found |\n| 5xx | サーバーエラー | 500 Internal Server Error, 503 Service Unavailable |"}', 2),
('30000000-0000-0000-0000-000000000003', 'code', '{"language": "bash", "code": "# HTTP リクエストの例\n$ curl -v https://api.example.com/users\n\n> GET /users HTTP/2\n> Host: api.example.com\n> Accept: application/json\n\n< HTTP/2 200\n< Content-Type: application/json\n< Cache-Control: max-age=3600\n\n[{\"id\": 1, \"name\": \"Alice\"}, ...]", "runnable": false}', 3),
('30000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## HTTP/1.1 → HTTP/2 → HTTP/3\n\n| バージョン | 特徴 |\n|---|---|\n| HTTP/1.1 | Keep-Alive、パイプライン、チャンク転送 |\n| HTTP/2 | バイナリフレーム、多重化、ヘッダー圧縮、サーバープッシュ |\n| HTTP/3 | QUIC（UDP上）、接続確立の高速化、HoLブロッキング解消 |"}', 4);

-- Lesson: DNS
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000004', 'c2000000-0000-0000-0000-000000000003', 'dns',
  'DNS（ドメインネームシステム）', 'ドメイン名からIPアドレスへの名前解決', 1, 12, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000004', 'markdown', '{"text": "# DNS（Domain Name System）\n\nDNSは**ドメイン名**（例: www.example.com）を**IPアドレス**（例: 93.184.216.34）に変換する分散データベースシステムです。\n\nインターネットの「電話帳」とも呼ばれます。"}', 0),
('30000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## 名前解決の流れ\n\n1. ブラウザが `www.example.com` にアクセス\n2. **ローカルキャッシュ**を確認（ブラウザ → OS）\n3. キャッシュになければ**再帰リゾルバ**（ISPのDNSサーバー）に問い合わせ\n4. リゾルバが**ルートDNSサーバー**に問い合わせ → `.com` のTLDサーバーを案内\n5. **TLDサーバー**に問い合わせ → `example.com` の権威サーバーを案内\n6. **権威DNSサーバー**が `www.example.com` の IP アドレスを返答\n7. 結果がキャッシュされ、ブラウザに返される"}', 1),
('30000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## DNSレコードの種類\n\n| レコード | 用途 | 例 |\n|---|---|---|\n| A | ドメイン → IPv4 | example.com → 93.184.216.34 |\n| AAAA | ドメイン → IPv6 | example.com → 2606:2800:... |\n| CNAME | エイリアス | www.example.com → example.com |\n| MX | メールサーバー | example.com → mail.example.com |\n| NS | ネームサーバー | example.com → ns1.example.com |\n| TXT | テキスト情報 | SPF, DKIM 認証情報 |"}', 2),
('30000000-0000-0000-0000-000000000004', 'code', '{"language": "bash", "code": "# DNS の確認\n$ nslookup example.com\nName:    example.com\nAddress: 93.184.216.34\n\n$ dig example.com +short\n93.184.216.34\n\n# 詳細な問い合わせ\n$ dig example.com ANY\n;; ANSWER SECTION:\nexample.com.  86400  IN  A     93.184.216.34\nexample.com.  86400  IN  AAAA  2606:2800:21f:cb07:6820:80da:af6b:8b2c\nexample.com.  86400  IN  MX    0 .\nexample.com.  86400  IN  NS    a.iana-servers.net.", "runnable": false}', 3),
('30000000-0000-0000-0000-000000000004', 'callout', '{"type": "info", "text": "DNSは主にUDPポート53を使用します。応答が512バイトを超える場合はTCPにフォールバックします。"}', 4);

-- ===== Lessons: ネットワーク層 =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000005', 'c2000000-0000-0000-0000-000000000004', 'ip-and-subnetting',
  'IPアドレスとサブネット', 'ネットワーク層のアドレッシング', 1, 15, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000005', 'markdown', '{"text": "# IPアドレスとサブネット\n\nIPアドレスはネットワーク上の各デバイスを識別するための論理的なアドレスです。"}', 0),
('30000000-0000-0000-0000-000000000005', 'markdown', '{"text": "## IPv4\n\n32ビット、ドット区切り10進表記（例: 192.168.1.100）\n\n### プライベートIPアドレス\n- 10.0.0.0/8（クラスA: 約1677万アドレス）\n- 172.16.0.0/12（クラスB: 約104万アドレス）\n- 192.168.0.0/16（クラスC: 約6.5万アドレス）\n\n### サブネットマスク\nネットワーク部とホスト部を区別するためのマスク。\n\n例: 192.168.1.0/24\n- サブネットマスク: 255.255.255.0\n- ネットワーク部: 192.168.1（先頭24ビット）\n- ホスト部: .0〜.255（末尾8ビット → 254台収容）\n- ネットワークアドレス: 192.168.1.0\n- ブロードキャストアドレス: 192.168.1.255"}', 1),
('30000000-0000-0000-0000-000000000005', 'callout', '{"type": "info", "text": "IPv4 のアドレス枯渇問題に対処するため、NAT（ネットワークアドレス変換）やIPv6（128ビット）が使われています。"}', 2),
('30000000-0000-0000-0000-000000000005', 'markdown', '{"text": "## ルーティング\n\nルーターはパケットの宛先IPアドレスに基づいて、次に転送すべきルーターを決定します。\n\n- **静的ルーティング**: 手動でルートテーブルを設定\n- **動的ルーティング**: プロトコル（OSPF、BGP等）でルートを自動学習\n\n### BGP（Border Gateway Protocol）\nインターネットのバックボーンを構成するルーティングプロトコル。AS（自律システム）間の経路交換を担当します。"}', 3);

-- ===== Lessons: セキュリティ =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000006', 'c2000000-0000-0000-0000-000000000005', 'tls-https',
  'TLS と HTTPS', '安全な通信の仕組み', 2, 15, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000006', 'markdown', '{"text": "# TLS と HTTPS\n\n**TLS（Transport Layer Security）**は、通信の暗号化・認証・完全性を提供するプロトコルです。\n\n**HTTPS** = HTTP + TLS（ポート443）"}', 0),
('30000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## TLSハンドシェイク（TLS 1.3）\n\n1. **Client Hello**: クライアントが対応する暗号スイートとランダム値を送信\n2. **Server Hello**: サーバーが暗号スイートを選択し、証明書を送信\n3. **鍵交換**: ECDHE等で共有秘密鍵を生成\n4. **Finished**: 双方が暗号化通信を開始\n\nTLS 1.3 では 1-RTT（1往復）で接続が確立します（1.2では2-RTT）。"}', 1),
('30000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## 暗号の種類\n\n| 種類 | 説明 | 例 |\n|---|---|---|\n| 共通鍵暗号 | 同じ鍵で暗号化・復号 | AES-256-GCM |\n| 公開鍵暗号 | 公開鍵で暗号化、秘密鍵で復号 | RSA, ECDSA |\n| ハッシュ | 一方向関数（復元不可） | SHA-256 |\n| 鍵交換 | 安全に共通鍵を共有 | ECDHE |\n\nTLSは鍵交換で共通鍵を安全に共有し、以降は高速な共通鍵暗号で通信します。"}', 2),
('30000000-0000-0000-0000-000000000006', 'callout', '{"type": "warning", "text": "証明書は認証局（CA）が発行します。Let''s Encrypt により、無料で HTTPS 化が可能になりました。証明書の期限切れに注意しましょう。"}', 3);
