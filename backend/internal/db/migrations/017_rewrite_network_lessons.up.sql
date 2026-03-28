-- Delete old network lessons
DELETE FROM lesson_blocks WHERE lesson_id IN (
  '30000000-0000-0000-0000-000000000001',
  '30000000-0000-0000-0000-000000000002',
  '30000000-0000-0000-0000-000000000003',
  '30000000-0000-0000-0000-000000000004',
  '30000000-0000-0000-0000-000000000005',
  '30000000-0000-0000-0000-000000000006'
);
DELETE FROM lessons WHERE id IN (
  '30000000-0000-0000-0000-000000000001',
  '30000000-0000-0000-0000-000000000002',
  '30000000-0000-0000-0000-000000000003',
  '30000000-0000-0000-0000-000000000004',
  '30000000-0000-0000-0000-000000000005',
  '30000000-0000-0000-0000-000000000006'
);

-- ============================================================
-- OSI Model: 初級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000001', 'c2000000-0000-0000-0000-000000000001', 'osi-model',
  'OSI参照モデルとTCP/IP', '7層モデルの各層の責務、カプセル化、TCP/IPとの対応。', 1, 20, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000001', 'markdown', '{"text": "# OSI参照モデルとTCP/IP\n\n## OSI参照モデル\n\nISO が策定した通信プロトコルの設計指針で、通信を**7つの層**に分離します。各層は下位層のサービスを利用し、上位層にサービスを提供します。\n\n| 層 | 名称 | PDU | 責務 | プロトコル例 |\n|---|---|---|---|---|\n| 7 | アプリケーション | データ | ユーザー向けサービス | HTTP, SMTP, DNS, FTP |\n| 6 | プレゼンテーション | データ | データ表現の変換・暗号化 | TLS/SSL, JPEG, ASCII |\n| 5 | セッション | データ | 通信セッションの管理 | RPC, NetBIOS |\n| 4 | トランスポート | セグメント | エンドツーエンドの信頼性 | TCP, UDP |\n| 3 | ネットワーク | パケット | 論理アドレッシング・ルーティング | IP, ICMP, ARP |\n| 2 | データリンク | フレーム | 物理アドレッシング・誤り検出 | Ethernet, Wi-Fi, PPP |\n| 1 | 物理 | ビット | 電気/光信号の伝送 | RS-232, USB, 光ファイバ |\n\n**PDU（Protocol Data Unit）**: 各層でのデータの単位名称。"}', 0),

('30000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## カプセル化と非カプセル化\n\n### 送信側（カプセル化）\n\n```\nアプリデータ\n→ [TCPヘッダ | アプリデータ]                    ← セグメント\n→ [IPヘッダ | TCPヘッダ | アプリデータ]           ← パケット\n→ [Ethヘッダ | IPヘッダ | TCPヘッダ | アプリデータ | FCS] ← フレーム\n```\n\n各層が自層のヘッダーを**先頭に付加**します。受信側は逆順にヘッダーを剥がして上位層に渡します。\n\nこのレイヤリングにより、HTTP は TCP の実装詳細を知る必要がなく、TCP は IP の詳細を知る必要がありません。**関心の分離**がネットワーク設計の基本原則です。"}', 1),

('30000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## TCP/IPモデルとの対応\n\n実際のインターネットは OSI ではなく **TCP/IP モデル**（4層）で動作しています。OSI は理論的参照モデルとして用語と概念の整理に使われます。\n\n| TCP/IP層 | OSI対応 | 主要プロトコル |\n|---|---|---|\n| アプリケーション | 層5〜7 | HTTP, DNS, SMTP, SSH |\n| トランスポート | 層4 | TCP, UDP |\n| インターネット | 層3 | IP, ICMP, ARP |\n| ネットワークアクセス | 層1〜2 | Ethernet, Wi-Fi |\n\n## なぜ層に分けるのか\n\n1. **モジュール性**: 各層を独立に設計・実装・テスト可能\n2. **相互運用性**: 同じ層のプロトコルを交換可能（有線↔無線の切り替え等）\n3. **標準化**: 各層のインターフェースを標準化し、異なるベンダーの機器が通信可能\n\n**学習のポイント**: 各層の責務と PDU の名称。カプセル化がレイヤー間の独立性を保証する仕組み。OSI と TCP/IP の対応関係。実務では「L3スイッチ」「L7ロードバランサー」のように層番号で機器の機能を表現します。"}', 2);

-- ============================================================
-- TCP/UDP: 中級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000002', 'c2000000-0000-0000-0000-000000000002', 'tcp-udp',
  'TCP と UDP', '3ウェイハンドシェイク、フロー制御、輻輳制御、UDPの設計判断。', 2, 30, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000002', 'markdown', '{"text": "# TCP と UDP\n\nトランスポート層の2大プロトコル。**TCP** は信頼性を、**UDP** は速度と単純さを提供します。\n\n## TCP（Transmission Control Protocol）\n\n### 3ウェイハンドシェイク\n\n接続確立の手順:\n\n```\nClient                    Server\n  |--- SYN (seq=x) -------->|\n  |<-- SYN+ACK (seq=y, ack=x+1) ---|\n  |--- ACK (ack=y+1) ------>|\n```\n\nなぜ3回なのか: 双方がシーケンス番号を交換し確認するために最低3回の通信が必要。2回では、サーバーのシーケンス番号がクライアントに確認されない。\n\n### 4ウェイハンドシェイク（切断）\n\n```\nClient                    Server\n  |--- FIN ---------------->|  (Clientが送信終了)\n  |<-- ACK ----------------|  (Server確認)\n  |<-- FIN ----------------|  (Serverが送信終了)\n  |--- ACK ---------------->|  (Client確認)\n```\n\n双方が独立に接続を閉じるため4回。半二重のクローズ（half-close）が可能。"}', 0),

('30000000-0000-0000-0000-000000000002', 'markdown', '{"text": "### シーケンス番号と確認応答\n\nTCP は各バイトにシーケンス番号を割り当て、受信側は ACK で「次に期待するバイト番号」を通知します。\n\n- **累積ACK**: 「ここまで受信した」を示す（欠けたセグメントがあると先に進めない）\n- **再送タイマー**: ACK が返らなければ再送。タイムアウト値は RTT の測定値から動的に計算\n- **Fast Retransmit**: 同じ ACK が3回重複（3 duplicate ACK）で、タイムアウトを待たず再送\n\n### フロー制御（Flow Control）\n\n受信側の処理能力に合わせて送信速度を調整。受信側は **rwnd（受信ウィンドウサイズ）**を ACK に含めて通知。送信側は rwnd を超えてデータを送らない。\n\n### 輻輳制御（Congestion Control）\n\nネットワークの混雑度に応じて送信速度を調整。TCP の輻輳制御は **AIMD（Additive Increase Multiplicative Decrease）**が基本:\n\n- **スロースタート**: cwnd を1 MSS から開始し、ACK ごとに指数的に増加\n- **輻輳回避**: cwnd が閾値（ssthresh）に達したら線形に増加\n- **輻輳検出**: パケットロスを検出したら cwnd を半減（Multiplicative Decrease）\n\n現代の TCP は CUBIC（Linux デフォルト）や BBR（Google）など高度なアルゴリズムを使用。"}', 1),

('30000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## UDP（User Datagram Protocol）\n\n**コネクションレス**で**最小限**のトランスポートプロトコル。\n\n### UDP ヘッダー（8バイト）\n\n```\n| 送信元ポート (16) | 宛先ポート (16) |\n| データ長 (16)     | チェックサム (16) |\n```\n\nTCP ヘッダー（20〜60バイト）と比較して極めてコンパクト。\n\n### UDP を選ぶべき場面\n\n| ユースケース | 理由 |\n|---|---|\n| DNS | 小さな要求/応答で接続確立のオーバーヘッドが不要 |\n| 動画/音声ストリーミング | 多少のパケットロスより遅延の最小化が重要 |\n| オンラインゲーム | リアルタイム性が必須。古い状態の再送は無意味 |\n| IoTセンサーデータ | 軽量さが重要。信頼性はアプリ層で対応 |\n\n### QUIC（HTTP/3）\n\nUDP 上に TCP の機能（信頼性、順序保証、輻輳制御）を**ユーザー空間**で実装したプロトコル。TCP の Head-of-Line ブロッキングを解消し、0-RTT 接続再開をサポート。"}', 2),

('30000000-0000-0000-0000-000000000002', 'code', '{"language": "python", "code": "import socket\n\n# --- TCP サーバー ---\ndef tcp_server():\n    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:  # SOCK_STREAM = TCP\n        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)\n        s.bind((\"localhost\", 8888))\n        s.listen(5)  # バックログ: 保留中の接続要求の最大数\n        \n        conn, addr = s.accept()  # 3ウェイハンドシェイク完了後に返る\n        with conn:\n            data = conn.recv(4096)  # 最大4096バイト受信\n            conn.sendall(b\"ACK: \" + data)  # 全データ送信を保証\n\n# --- UDP サーバー ---\ndef udp_server():\n    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:   # SOCK_DGRAM = UDP\n        s.bind((\"localhost\", 9999))\n        # 接続確立なし — 即座にデータ受信可能\n        data, addr = s.recvfrom(4096)\n        s.sendto(b\"ACK: \" + data, addr)  # 送信先アドレスを明示\n\n# TCP: connect → send → recv → close (ストリーム指向)\n# UDP: sendto → recvfrom (データグラム指向、コネクションレス)", "runnable": false}', 3),

('30000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## TCP vs UDP まとめ\n\n| | TCP | UDP |\n|---|---|---|\n| 接続 | コネクション型（3ウェイHS） | コネクションレス |\n| 信頼性 | 順序保証、再送、重複排除 | なし |\n| フロー制御 | あり（rwnd） | なし |\n| 輻輳制御 | あり（AIMD, CUBIC, BBR） | なし |\n| ヘッダーサイズ | 20〜60バイト | 8バイト |\n| 遅延 | 接続確立に1 RTT | なし |\n| 用途 | Web、メール、ファイル転送 | DNS、ストリーミング、ゲーム |\n\n**学習のポイント**: 3ウェイハンドシェイクが「なぜ3回か」の理由。フロー制御（受信側の能力制限）と輻輳制御（ネットワークの能力制限）の区別。UDP が「信頼性がない」のではなく「信頼性をアプリ層に委ねる」設計判断であること。QUIC が TCP の問題をどう解決したか。"}', 4);

-- ============================================================
-- HTTP: 中級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000003', 'c2000000-0000-0000-0000-000000000003', 'http-protocol',
  'HTTPプロトコル', 'リクエスト/レスポンス構造、メソッドのべき等性、キャッシュ、HTTP/2/3の改善。', 2, 25, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000003', 'markdown', '{"text": "# HTTPプロトコル\n\nHTTP（HyperText Transfer Protocol）は Web の基盤となるアプリケーション層プロトコルで、**リクエスト-レスポンス**モデルで動作します。\n\n## リクエストの構造\n\n```\nGET /api/users?page=1 HTTP/1.1    ← リクエストライン（メソッド、パス、バージョン）\nHost: api.example.com              ← 必須ヘッダー\nAccept: application/json\nAuthorization: Bearer eyJhbG...\n                                   ← 空行\n（ボディ — GETでは通常なし）\n```\n\n## レスポンスの構造\n\n```\nHTTP/1.1 200 OK                    ← ステータスライン\nContent-Type: application/json\nCache-Control: max-age=3600\nContent-Length: 256\n                                   ← 空行\n{\"users\": [{\"id\": 1, ...}]}        ← ボディ\n```"}', 0),

('30000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## HTTPメソッドと意味論\n\n| メソッド | 意味 | 安全 | べき等 | ボディ |\n|---|---|---|---|---|\n| GET | リソース取得 | Yes | Yes | No |\n| HEAD | ヘッダーのみ取得 | Yes | Yes | No |\n| POST | リソース作成・処理実行 | No | **No** | Yes |\n| PUT | リソース全体の置換 | No | Yes | Yes |\n| PATCH | リソースの部分更新 | No | No | Yes |\n| DELETE | リソース削除 | No | Yes | No |\n| OPTIONS | 対応メソッドの確認 | Yes | Yes | No |\n\n### 安全（Safe）とべき等（Idempotent）\n\n- **安全**: サーバーの状態を変更しない。GET は安全、POST は安全でない。\n- **べき等**: 同じリクエストを何度実行しても結果が同じ。PUT（同じデータで上書き）はべき等、POST（毎回新しいリソース作成）はべき等でない。\n\nこの区別は**リトライの安全性**に直結します。ネットワーク障害時、べき等なリクエストは安全にリトライ可能。\n\n## ステータスコード\n\n| 範囲 | 分類 | 重要なコード |\n|---|---|---|\n| 2xx | 成功 | 200 OK, 201 Created, 204 No Content |\n| 3xx | リダイレクト | 301 Moved Permanently, 304 Not Modified |\n| 4xx | クライアントエラー | 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 429 Too Many Requests |\n| 5xx | サーバーエラー | 500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable |"}', 1),

('30000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## HTTPキャッシュ\n\n### Cache-Control ヘッダー\n\n| ディレクティブ | 意味 |\n|---|---|\n| `max-age=3600` | 3600秒間キャッシュ有効 |\n| `no-cache` | キャッシュ可能だが、使用前にサーバーに検証必要 |\n| `no-store` | キャッシュ禁止（機密データ向け） |\n| `private` | ブラウザのみキャッシュ可能（CDN不可） |\n| `public` | CDN等の共有キャッシュも可能 |\n\n### 条件付きリクエスト\n\n- `ETag` + `If-None-Match`: コンテンツのハッシュで変更を検出\n- `Last-Modified` + `If-Modified-Since`: 更新日時で変更を検出\n- 変更なし → 304 Not Modified（ボディ転送なし）\n\n## HTTP/1.1 → HTTP/2 → HTTP/3\n\n| | HTTP/1.1 | HTTP/2 | HTTP/3 |\n|---|---|---|---|\n| プロトコル | テキスト | バイナリフレーム | QUIC (UDP上) |\n| 多重化 | なし（パイプライン非推奨） | ストリーム多重化 | ストリーム多重化 |\n| HoLブロッキング | リクエストレベル | TCP レベルで残存 | **解消** |\n| ヘッダー圧縮 | なし | HPACK | QPACK |\n| 接続確立 | TCP HS + TLS HS | 同左 | **0-1 RTT** |\n| サーバープッシュ | なし | あり | あり |\n\n**学習のポイント**: メソッドのべき等性がリトライ戦略に与える影響。キャッシュ制御の各ディレクティブの使い分け。HTTP/2 の多重化がなぜ重要か（1つのTCP接続で並列リクエスト）。HTTP/3 が TCP の HoL ブロッキングをどう解消したか。"}', 2);

-- ============================================================
-- DNS: 初級→中級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000004', 'c2000000-0000-0000-0000-000000000003', 'dns',
  'DNS', '再帰/反復クエリ、DNSレコードの種類、キャッシュとTTL、セキュリティ（DNSSEC）。', 2, 20, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000004', 'markdown', '{"text": "# DNS（Domain Name System）\n\nDNS はドメイン名を IP アドレスに変換する**階層的分散データベース**です。\n\n## 名前解決の流れ（再帰クエリ）\n\nブラウザが `www.example.com` にアクセスする場合:\n\n1. **ブラウザキャッシュ** → **OS キャッシュ**（`/etc/hosts`）を確認\n2. キャッシュになければ**スタブリゾルバ**が**再帰リゾルバ**（ISP or 8.8.8.8）に問い合わせ\n3. 再帰リゾルバが**ルートDNS**に問い合わせ → `.com` の TLD サーバーを回答\n4. **TLDサーバー**に問い合わせ → `example.com` の権威サーバーを回答\n5. **権威DNSサーバー**に問い合わせ → `www.example.com = 93.184.216.34` を回答\n6. 再帰リゾルバがキャッシュし、クライアントに返答\n\n### 再帰クエリ vs 反復クエリ\n\n- **再帰**: クライアントは再帰リゾルバに1回問い合わせるだけ。リゾルバが代わりに全段階を解決\n- **反復**: 各DNSサーバーは「次に聞くべきサーバー」を返すだけ。再帰リゾルバが反復的に辿る\n\n実際の構成: クライアント→再帰リゾルバ（再帰クエリ）、再帰リゾルバ→各DNSサーバー（反復クエリ）"}', 0),

('30000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## DNSレコードの種類\n\n| レコード | 意味 | 例 |\n|---|---|---|\n| **A** | ドメイン → IPv4 | `example.com → 93.184.216.34` |\n| **AAAA** | ドメイン → IPv6 | `example.com → 2606:2800:...` |\n| **CNAME** | エイリアス（別名） | `www.example.com → example.com` |\n| **MX** | メール配送先（優先度付き） | `example.com → 10 mail.example.com` |\n| **NS** | 権威ネームサーバー | `example.com → ns1.example.com` |\n| **TXT** | テキスト情報 | SPF, DKIM, ドメイン検証 |\n| **SOA** | ゾーンの権威情報 | シリアル番号、更新間隔 |\n| **PTR** | 逆引き（IP → ドメイン） | `34.216.184.93 → example.com` |\n| **SRV** | サービスの場所（ポート含む） | `_sip._tcp → 5060 sip.example.com` |\n\n## TTL（Time To Live）\n\n各レコードに設定されるキャッシュ有効期間（秒）。\n\n- 長い TTL（86400秒=1日）: DNS クエリ減少、変更の反映が遅い\n- 短い TTL（60秒）: 変更が即座に反映、DNS 負荷増加\n- DNS 切り替え（サーバー移行等）前に TTL を短くしておくのが定石"}', 1),

('30000000-0000-0000-0000-000000000004', 'code', '{"language": "bash", "code": "# A レコードの問い合わせ\n$ dig example.com A +short\n93.184.216.34\n\n# 詳細な応答（権威セクション、追加セクション含む）\n$ dig example.com A\n;; ANSWER SECTION:\nexample.com.  86400  IN  A  93.184.216.34\n\n# MX レコード（メールサーバー）\n$ dig example.com MX +short\n10 mail.example.com.\n\n# 名前解決の経路を追跡（ルートから反復クエリ）\n$ dig +trace example.com\n.                      518400 IN NS a.root-servers.net.\ncom.                   172800 IN NS a.gtld-servers.net.\nexample.com.            86400 IN NS a.iana-servers.net.\nexample.com.            86400 IN A  93.184.216.34\n\n# 逆引き\n$ dig -x 93.184.216.34 +short", "runnable": false}', 2),

('30000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## DNSのセキュリティ\n\n### 脅威\n\n- **DNSキャッシュポイズニング**: 偽のDNS応答をキャッシュに注入し、ユーザーを偽サイトに誘導\n- **DNS増幅攻撃**: 小さなクエリで大きな応答を生成させ、DDoS に利用\n\n### 対策\n\n| 技術 | 目的 |\n|---|---|\n| **DNSSEC** | 応答の電子署名による改ざん検出 |\n| **DoH（DNS over HTTPS）** | DNS クエリを HTTPS で暗号化（盗聴防止） |\n| **DoT（DNS over TLS）** | DNS クエリを TLS で暗号化 |\n\n**学習のポイント**: DNS が階層的分散システムである理由（単一サーバーでは世界中のクエリに対応不可能）。再帰/反復クエリの役割分担。TTL によるキャッシュ戦略。CNAME と A レコードの使い分け。"}', 3);

-- ============================================================
-- IP & Subnetting: 中級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000005', 'c2000000-0000-0000-0000-000000000004', 'ip-and-subnetting',
  'IPアドレスとサブネット', 'CIDR表記、サブネット計算、NAT、ルーティングの基礎。', 2, 25, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000005', 'markdown', '{"text": "# IPアドレスとサブネット\n\n## IPv4 アドレス\n\n32ビット、ドット区切り10進表記。各オクテットは0〜255。\n\n### CIDR（Classless Inter-Domain Routing）表記\n\n`192.168.1.0/24` の `/24` は上位24ビットがネットワーク部であることを示します。\n\n```\n192.168.1.0/24\n= 11000000.10101000.00000001.00000000\n  |------- ネットワーク部 -------|-ホスト部-|\n  (24ビット)                     (8ビット)\n```\n\n| CIDR | サブネットマスク | ホスト数 | 用途 |\n|---|---|---|---|\n| /32 | 255.255.255.255 | 1 | ホストルート |\n| /24 | 255.255.255.0 | 254 | 一般的なLAN |\n| /16 | 255.255.0.0 | 65,534 | 大規模ネットワーク |\n| /8 | 255.0.0.0 | 16,777,214 | クラスA相当 |\n\nホスト数 = 2^(32-prefix) - 2（ネットワークアドレスとブロードキャストアドレスを除く）"}', 0),

('30000000-0000-0000-0000-000000000005', 'markdown', '{"text": "## プライベートアドレスとNAT\n\n### RFC 1918 プライベートアドレス\n\n| 範囲 | CIDR | アドレス数 |\n|---|---|---|\n| 10.0.0.0 〜 10.255.255.255 | 10.0.0.0/8 | 約1678万 |\n| 172.16.0.0 〜 172.31.255.255 | 172.16.0.0/12 | 約104万 |\n| 192.168.0.0 〜 192.168.255.255 | 192.168.0.0/16 | 約6.5万 |\n\n### NAT（Network Address Translation）\n\nプライベートIPをグローバルIPに変換してインターネットに接続。IPv4アドレス枯渇の延命策。\n\n**NAPT（PAT）**: ポート番号も変換し、1つのグローバルIPで複数のホストが通信。家庭のルーターはほぼすべてNAPTを使用。\n\n### IPv6\n\n128ビット。2^128 ≈ 3.4×10^38 個のアドレス。NAT が不要になり、エンドツーエンド通信が復活。表記例: `2001:0db8:85a3::8a2e:0370:7334`"}', 1),

('30000000-0000-0000-0000-000000000005', 'markdown', '{"text": "## ルーティング\n\nルーターはパケットの宛先IPアドレスに基づいて**ルーティングテーブル**を参照し、次のホップ（転送先）を決定します。\n\n### 最長一致（Longest Prefix Match）\n\n複数のルートが該当する場合、**最もプレフィックスが長い**（最も具体的な）ルートを選択。\n\n### ルーティングプロトコル\n\n| プロトコル | 種別 | アルゴリズム | 用途 |\n|---|---|---|---|\n| RIP | 距離ベクトル | ベルマンフォード | 小規模ネットワーク |\n| OSPF | リンク状態 | ダイクストラ | 企業内ネットワーク（AS内） |\n| BGP | パスベクトル | ポリシーベース | **インターネットのバックボーン（AS間）** |\n\nBGP は約90万のルートを管理し、インターネット全体の経路制御を担う最も重要なプロトコルです。\n\n**学習のポイント**: CIDR のサブネット計算（ホスト数 = 2^(32-prefix) - 2）。NAT がエンドツーエンド通信を破壊する副作用。最長一致ルーティングの仕組み。OSPF と BGP の適用範囲の違い（AS内 vs AS間）。"}', 2);

-- ============================================================
-- TLS/HTTPS: 中級→上級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('30000000-0000-0000-0000-000000000006', 'c2000000-0000-0000-0000-000000000005', 'tls-https',
  'TLS と HTTPS', 'TLS 1.3ハンドシェイク、証明書チェーン、暗号スイート、前方秘匿性。', 3, 25, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000006', 'markdown', '{"text": "# TLS と HTTPS\n\n**TLS（Transport Layer Security）**はトランスポート層の上で**機密性（暗号化）、完全性（改ざん検出）、認証（相手の確認）**を提供するプロトコルです。\n\nHTTPS = HTTP + TLS（ポート443）\n\n## TLS 1.3 ハンドシェイク（1-RTT）\n\n```\nClient                              Server\n  |                                    |\n  |--- ClientHello ------------------->|\n  |    (対応暗号スイート、鍵共有パラメータ)  |\n  |                                    |\n  |<-- ServerHello + 証明書 + Finished -|\n  |    (選択暗号スイート、鍵共有、署名)     |\n  |                                    |\n  |--- Finished ---------------------->|\n  |                                    |\n  |====== 暗号化通信開始 ===============|\n```\n\nTLS 1.2 では2-RTTだったハンドシェイクが **1-RTT** に短縮。さらに過去に接続したサーバーとは **0-RTT**（Pre-Shared Key）で即座に暗号化データを送信可能（ただしリプレイ攻撃のリスクあり）。"}', 0),

('30000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## 暗号技術の組み合わせ\n\nTLS は複数の暗号技術を組み合わせて使用します:\n\n| 目的 | 技術 | TLS 1.3 で使用 |\n|---|---|---|\n| **鍵交換** | ECDHE（楕円曲線ディフィー・ヘルマン） | X25519, P-256 |\n| **認証** | デジタル署名 | RSA-PSS, ECDSA, Ed25519 |\n| **暗号化** | AEAD（認証付き暗号） | AES-128-GCM, AES-256-GCM, ChaCha20-Poly1305 |\n| **ハッシュ** | 鍵導出、メッセージ認証 | SHA-256, SHA-384 |\n\n### なぜ共通鍵と公開鍵を併用するか\n\n1. 公開鍵暗号（RSA等）は計算コストが高い → データの暗号化には不向き\n2. ECDHE で**セッション鍵**（共通鍵）を安全に共有\n3. 以降の通信は高速な共通鍵暗号（AES-GCM等）で暗号化\n\n### 前方秘匿性（Forward Secrecy）\n\nECDHE では各接続ごとに一時的な鍵ペアを生成。サーバーの秘密鍵が将来漏洩しても、**過去の通信は復号できない**。TLS 1.3 では ECDHE が必須化され、前方秘匿性が常に保証されます。"}', 1),

('30000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## 証明書と PKI\n\n### 証明書チェーン\n\n```\nルートCA証明書（OS/ブラウザにプリインストール）\n  └── 中間CA証明書（ルートCAが署名）\n        └── サーバー証明書（中間CAが署名）\n```\n\nブラウザはこのチェーンを**ルートCAまで辿って**検証します。ルートCA を信頼 → 中間CA の署名を検証 → サーバー証明書の署名を検証。\n\n### 証明書に含まれる情報\n\n- サブジェクト（ドメイン名）: `CN=example.com` / SAN（Subject Alternative Name）\n- 公開鍵\n- 有効期限（現在は最長398日）\n- 発行者の署名\n\n### 証明書の種類\n\n| 種類 | 検証レベル | 費用 |\n|---|---|---|\n| DV（Domain Validation） | ドメインの所有権のみ | 無料（Let''s Encrypt） |\n| OV（Organization Validation） | 組織の実在確認 | 有料 |\n| EV（Extended Validation） | 厳格な組織審査 | 高額 |\n\n## よくある TLS の問題\n\n| 問題 | 原因 | 対策 |\n|---|---|---|\n| 証明書期限切れ | 更新忘れ | Let''s Encrypt + certbot 自動更新 |\n| 中間証明書の欠落 | サーバー設定ミス | fullchain.pem を使用 |\n| Mixed Content | HTTPS ページ内の HTTP リソース | 全リソースを HTTPS 化 |\n| 古い TLS バージョン | TLS 1.0/1.1 の使用 | TLS 1.2以上を強制 |\n\n**学習のポイント**: TLS 1.3 の 1-RTT が実現できる理由（鍵共有パラメータを ClientHello に含める）。前方秘匿性の重要性（一時鍵の利用）。証明書チェーンによる信頼の連鎖。AEAD が暗号化と完全性を同時に保証する仕組み。"}', 2);
