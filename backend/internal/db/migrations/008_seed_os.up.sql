-- Topic: Operating Systems
INSERT INTO topics (id, slug, title, description, icon_name, sort_order, is_published)
VALUES (
  'a0000000-0000-0000-0000-000000000002',
  'operating-systems',
  'オペレーティングシステム',
  'プロセス管理、メモリ管理、ファイルシステム、同期・排他制御など OS の基礎を学びます',
  'settings',
  2,
  true
);

-- Categories
INSERT INTO categories (id, topic_id, slug, title, description, sort_order) VALUES
('c1000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'process-management', 'プロセス管理', 'プロセスとスレッド、生成と終了、状態遷移', 1),
('c1000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000002', 'scheduling', 'スケジューリング', 'CPU スケジューリングアルゴリズム', 2),
('c1000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000002', 'memory-management', 'メモリ管理', '仮想メモリ、ページング、セグメンテーション', 3),
('c1000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000002', 'synchronization', '同期・排他制御', 'ミューテックス、セマフォ、デッドロック', 4),
('c1000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000002', 'file-systems', 'ファイルシステム', 'ファイル管理、ディレクトリ構造、I/O', 5);

-- ===== Lessons: プロセス管理 =====

-- Lesson: プロセスとスレッド
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000001', 'process-and-thread',
  'プロセスとスレッド', 'OS の実行単位であるプロセスとスレッドの違いを理解する', 1, 15, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000001', 'markdown', '{"text": "# プロセスとスレッド\n\nOS はプログラムを**プロセス**という単位で管理します。プロセスは実行中のプログラムのインスタンスであり、独自のメモリ空間を持ちます。\n\n**スレッド**はプロセス内の実行単位で、同じプロセス内のスレッドはメモリ空間を共有します。"}', 0),
('20000000-0000-0000-0000-000000000001', 'callout', '{"type": "info", "text": "プロセス = 独立したメモリ空間 + 1つ以上のスレッド。スレッド = プロセス内の軽量な実行単位（メモリ共有）。"}', 1),
('20000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## プロセスの構成要素\n\n各プロセスは以下の情報を持ちます:\n\n- **PID（プロセスID）**: 一意の識別子\n- **メモリ空間**: テキスト（コード）、データ、ヒープ、スタック\n- **PCB（プロセス制御ブロック）**: レジスタ状態、スケジューリング情報\n- **ファイルディスクリプタ**: 開いているファイルやソケット"}', 2),
('20000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## プロセスの状態遷移\n\nプロセスは以下の状態を遷移します:\n\n- **New（生成）**: プロセスが作成された直後\n- **Ready（実行可能）**: CPU の割り当てを待っている\n- **Running（実行中）**: CPU 上で命令を実行中\n- **Waiting（待機）**: I/O 完了などのイベントを待機中\n- **Terminated（終了）**: 実行が完了した"}', 3),
('20000000-0000-0000-0000-000000000001', 'code', '{"language": "python", "code": "import os\nimport threading\n\n# プロセスID の確認\nprint(f\"PID: {os.getpid()}\")\nprint(f\"Parent PID: {os.getppid()}\")\n\n# スレッドの作成\ndef worker(name):\n    print(f\"Thread {name}: PID={os.getpid()}, TID={threading.current_thread().name}\")\n\nt1 = threading.Thread(target=worker, args=(\"A\",))\nt2 = threading.Thread(target=worker, args=(\"B\",))\nt1.start()\nt2.start()\nt1.join()\nt2.join()\n# 同じ PID で異なるスレッドが実行される", "runnable": false}', 4),
('20000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## プロセス vs スレッド\n\n| | プロセス | スレッド |\n|---|---|---|\n| メモリ空間 | 独立 | 共有 |\n| 生成コスト | 高い | 低い |\n| コンテキストスイッチ | 遅い | 速い |\n| 障害の影響 | 他プロセスに影響なし | 同一プロセス内で波及 |\n| 通信方法 | IPC（パイプ、ソケット等） | 共有メモリ（直接アクセス） |"}', 5),
('20000000-0000-0000-0000-000000000001', 'callout', '{"type": "tip", "text": "Web サーバーの Nginx はマルチプロセス、Node.js はシングルプロセス・イベントループ、Java サーバーはマルチスレッドが一般的です。用途に応じて使い分けます。"}', 6);

-- Lesson: fork と exec
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000001', 'fork-and-exec',
  'fork と exec', 'UNIX系OSのプロセス生成メカニズム', 2, 12, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000002', 'markdown', '{"text": "# fork と exec\n\nUNIX系OSでは、新しいプロセスは **fork()** と **exec()** の2段階で生成されます。\n\n- **fork()**: 現在のプロセスのコピー（子プロセス）を作成\n- **exec()**: プロセスのメモリ内容を新しいプログラムで置き換え"}', 0),
('20000000-0000-0000-0000-000000000002', 'callout', '{"type": "info", "text": "fork() は「自分自身のコピーを作る」、exec() は「別のプログラムに変身する」と覚えましょう。"}', 1),
('20000000-0000-0000-0000-000000000002', 'code', '{"language": "c", "code": "#include <stdio.h>\n#include <unistd.h>\n#include <sys/wait.h>\n\nint main() {\n    pid_t pid = fork();\n    \n    if (pid == 0) {\n        // 子プロセス\n        printf(\"Child: PID=%d\\n\", getpid());\n        execl(\"/bin/ls\", \"ls\", \"-l\", NULL);  // ls -l に変身\n        // exec が成功すると、ここには到達しない\n    } else if (pid > 0) {\n        // 親プロセス\n        printf(\"Parent: PID=%d, Child=%d\\n\", getpid(), pid);\n        wait(NULL);  // 子プロセスの終了を待機\n        printf(\"Child finished\\n\");\n    }\n    return 0;\n}", "runnable": false}', 2),
('20000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## Copy-on-Write (CoW)\n\nfork() は一見コストが高そうですが、現代の OS は **Copy-on-Write** で最適化しています。\n\n- fork 直後は親子でメモリページを共有\n- どちらかが書き込みを行った時点で初めてページがコピーされる\n- exec() をすぐ呼ぶ場合、ほとんどコピーは発生しない\n\nこれにより、fork + exec のパターンは非常に効率的です。"}', 3),
('20000000-0000-0000-0000-000000000002', 'callout', '{"type": "warning", "text": "fork() の戻り値は親プロセスでは子の PID、子プロセスでは 0 です。この違いで親子を区別します。"}', 4);

-- ===== Lessons: スケジューリング =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000002', 'cpu-scheduling',
  'CPUスケジューリング', 'プロセスへのCPU割り当てアルゴリズム', 2, 18, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000003', 'markdown', '{"text": "# CPUスケジューリング\n\nCPUスケジューリングは、実行可能なプロセスの中からどれにCPUを割り当てるかを決定する仕組みです。\n\nスケジューラの目標:\n- **スループット**: 単位時間あたりの完了プロセス数の最大化\n- **応答時間**: ユーザーの操作に対する応答の高速化\n- **公平性**: すべてのプロセスに適切にCPUを配分"}', 0),
('20000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## 主要なスケジューリングアルゴリズム\n\n### FCFS（First Come, First Served）\n到着順に処理。シンプルだが、長いジョブが短いジョブをブロックする（**コンボイ効果**）。\n\n### SJF（Shortest Job First）\n実行時間が最も短いプロセスを優先。平均待ち時間を最小化するが、実行時間の正確な予測が必要。\n\n### Round Robin（ラウンドロビン）\n各プロセスに**タイムクォンタム**（時間の割り当て量）を与え、順番に実行。タイムクォンタムが短すぎるとコンテキストスイッチのオーバーヘッドが増大。\n\n### Priority Scheduling（優先度スケジューリング）\n優先度の高いプロセスを先に実行。**飢餓（Starvation）**問題が発生する可能性があり、**エージング**で対策。"}', 1),
('20000000-0000-0000-0000-000000000003', 'callout', '{"type": "info", "text": "Linux はCFS（Completely Fair Scheduler）を採用しており、仮想実行時間に基づいて公平にCPUを分配します。"}', 2),
('20000000-0000-0000-0000-000000000003', 'code', '{"language": "python", "code": "# Round Robin シミュレーション\ndef round_robin(processes, quantum):\n    \"\"\"processes: [(name, burst_time), ...]\"\"\"\n    queue = [(name, burst) for name, burst in processes]\n    time = 0\n    log = []\n    \n    while queue:\n        name, remaining = queue.pop(0)\n        run_time = min(quantum, remaining)\n        time += run_time\n        remaining -= run_time\n        log.append(f\"t={time-run_time}-{time}: {name} (残り {remaining})\")\n        \n        if remaining > 0:\n            queue.append((name, remaining))\n        else:\n            log.append(f\"  → {name} 完了 (t={time})\")\n    \n    return log\n\nresult = round_robin([(\"P1\", 10), (\"P2\", 4), (\"P3\", 6)], quantum=3)\nfor line in result:\n    print(line)\n# t=0-3: P1 (残り 7)\n# t=3-6: P2 (残り 1)\n# t=6-9: P3 (残り 3)\n# t=9-12: P1 (残り 4)\n# t=12-13: P2 (残り 0) → P2 完了\n# ...", "runnable": false}', 3),
('20000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## アルゴリズム比較\n\n| アルゴリズム | プリエンプティブ | 利点 | 欠点 |\n|---|---|---|---|\n| FCFS | No | シンプル | コンボイ効果 |\n| SJF | 両方可 | 平均待ち時間最小 | 実行時間予測が必要 |\n| Round Robin | Yes | 応答性が良い | クォンタム選択が重要 |\n| Priority | 両方可 | 重要タスク優先 | 飢餓問題 |"}', 4);

-- ===== Lessons: メモリ管理 =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000003', 'virtual-memory',
  '仮想メモリ', '物理メモリの限界を超える仕組み', 2, 20, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000004', 'markdown', '{"text": "# 仮想メモリ\n\n仮想メモリは、各プロセスに**独立した連続的なメモリ空間**があるかのように見せる仕組みです。\n\n物理メモリ（RAM）が不足しても、ディスクを一時的な記憶領域として利用し、実際に必要なデータだけを物理メモリに配置します。"}', 0),
('20000000-0000-0000-0000-000000000004', 'callout', '{"type": "info", "text": "仮想メモリにより、4GBの物理メモリしかないマシンでも、各プロセスが64ビットの広大なアドレス空間を利用できます。"}', 1),
('20000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## ページングの仕組み\n\n仮想メモリは**ページング**で実現されます:\n\n1. 仮想アドレス空間を固定サイズの**ページ**（通常4KB）に分割\n2. 物理メモリを同じサイズの**フレーム**に分割\n3. **ページテーブル**でページからフレームへのマッピングを管理\n4. 必要なページだけを物理メモリに載せる（**デマンドページング**）"}', 2),
('20000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## ページフォールト\n\nプロセスがアクセスしたページが物理メモリにない場合、**ページフォールト**が発生します:\n\n1. CPU がページテーブルを参照 → 物理メモリにない\n2. ページフォールト割り込み発生\n3. OS がディスクから該当ページを読み込み\n4. ページテーブルを更新\n5. 中断した命令を再実行\n\nページフォールトはディスクI/Oを伴うため非常に遅い（RAM アクセスの約10万倍）。"}', 3),
('20000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## ページ置換アルゴリズム\n\n物理メモリが満杯の場合、どのページを追い出すかを決める必要があります:\n\n- **FIFO**: 最も古いページを追い出す。実装が簡単だがベラディの異常が発生しうる\n- **LRU（Least Recently Used）**: 最も長く使われていないページを追い出す。実用的だが実装コスト大\n- **Clock（近似LRU）**: 参照ビットを使った効率的な近似。Linux等で実用\n- **OPT（最適）**: 将来最も長く使われないページを追い出す。理論上最適だが実装不可能（比較用ベンチマーク）"}', 4),
('20000000-0000-0000-0000-000000000004', 'callout', '{"type": "tip", "text": "TLB（Translation Lookaside Buffer）はページテーブルのキャッシュです。TLB ヒット率が高いほどメモリアクセスが高速化します。"}', 5);

-- Lesson: メモリ配置
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000005', 'c1000000-0000-0000-0000-000000000003', 'memory-layout',
  'プロセスのメモリ配置', 'テキスト・データ・ヒープ・スタック領域', 1, 12, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000005', 'markdown', '{"text": "# プロセスのメモリ配置\n\nプロセスのメモリ空間は以下の領域に分かれています（下位アドレスから上位へ）:\n\n- **テキスト領域**: 実行可能なマシンコード（読み取り専用）\n- **データ領域**: 初期化済みグローバル変数・静的変数\n- **BSS領域**: 未初期化のグローバル変数（ゼロ初期化）\n- **ヒープ**: 動的に確保されるメモリ（malloc / new）、上方向に成長\n- **スタック**: 関数の引数、局所変数、戻りアドレス、下方向に成長"}', 0),
('20000000-0000-0000-0000-000000000005', 'code', '{"language": "c", "code": "#include <stdio.h>\n#include <stdlib.h>\n\nint global_init = 42;       // データ領域\nint global_uninit;           // BSS領域\n\nint main() {\n    int local = 10;          // スタック\n    int *heap = malloc(100); // ヒープ\n    \n    printf(\"Code:   %p\\n\", (void*)main);\n    printf(\"Data:   %p\\n\", (void*)&global_init);\n    printf(\"BSS:    %p\\n\", (void*)&global_uninit);\n    printf(\"Heap:   %p\\n\", (void*)heap);\n    printf(\"Stack:  %p\\n\", (void*)&local);\n    \n    free(heap);\n    return 0;\n}", "runnable": false}', 1),
('20000000-0000-0000-0000-000000000005', 'callout', '{"type": "warning", "text": "ヒープとスタックが衝突するとメモリ不足になります。スタックオーバーフロー（再帰が深すぎる）やヒープ枯渇（メモリリーク）に注意しましょう。"}', 2);

-- ===== Lessons: 同期・排他制御 =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000006', 'c1000000-0000-0000-0000-000000000004', 'mutex-and-semaphore',
  'ミューテックスとセマフォ', '排他制御の基本メカニズム', 2, 18, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000006', 'markdown', '{"text": "# ミューテックスとセマフォ\n\n複数のスレッドやプロセスが共有リソースに同時アクセスすると、**競合状態（Race Condition）**が発生します。\n\nこれを防ぐための仕組みが**排他制御**であり、代表的なものがミューテックスとセマフォです。"}', 0),
('20000000-0000-0000-0000-000000000006', 'callout', '{"type": "info", "text": "クリティカルセクション = 共有リソースにアクセスするコード領域。同時に1つのスレッドだけが実行できるようにする必要があります。"}', 1),
('20000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## ミューテックス（Mutex）\n\n**相互排除（Mutual Exclusion）**を実現するロック機構です。\n\n- ロックを取得したスレッドだけがクリティカルセクションに入れる\n- 他のスレッドはロック解放まで待機\n- ロックを取得したスレッドが解放する（所有権あり）\n\n## セマフォ（Semaphore）\n\n**カウンタ**ベースの同期機構です。\n\n- カウンタが0より大きければ進入可能（カウンタをデクリメント）\n- カウンタが0なら待機\n- バイナリセマフォ（0 or 1）はミューテックスに似ている\n- カウンティングセマフォ（N）は同時にN個のアクセスを許可"}', 2),
('20000000-0000-0000-0000-000000000006', 'code', '{"language": "python", "code": "import threading\n\ncounter = 0\nlock = threading.Lock()\n\ndef increment():\n    global counter\n    for _ in range(100000):\n        lock.acquire()    # ロック取得\n        counter += 1      # クリティカルセクション\n        lock.release()    # ロック解放\n\n# with 文を使うとより安全\ndef increment_safe():\n    global counter\n    for _ in range(100000):\n        with lock:         # 自動的に acquire/release\n            counter += 1\n\nt1 = threading.Thread(target=increment_safe)\nt2 = threading.Thread(target=increment_safe)\nt1.start(); t2.start()\nt1.join(); t2.join()\nprint(f\"Counter: {counter}\")  # 200000（ロックなしだと不定値）", "runnable": false}', 3),
('20000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## ミューテックス vs セマフォ\n\n| | ミューテックス | セマフォ |\n|---|---|---|\n| 同時アクセス数 | 1 | N（カウンタ値） |\n| 所有権 | あり（ロック者が解放） | なし（誰でも signal 可） |\n| 用途 | 排他制御 | リソース数の管理 |\n| 例 | トイレの鍵 | 駐車場の空き台数 |"}', 4);

-- Lesson: デッドロック
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000007', 'c1000000-0000-0000-0000-000000000004', 'deadlock',
  'デッドロック', '並行処理の罠と対策', 3, 15, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000007', 'markdown', '{"text": "# デッドロック\n\nデッドロックは、2つ以上のプロセス/スレッドが**互いに相手が持つリソースを待ち続けて永遠に進めなくなる**状態です。"}', 0),
('20000000-0000-0000-0000-000000000007', 'markdown', '{"text": "## デッドロックの4条件（Coffman条件）\n\n以下の4つが**同時に**成立するとデッドロックが発生します:\n\n1. **相互排除**: リソースは同時に1つのプロセスのみ使用可能\n2. **保持と待機**: リソースを保持したまま他のリソースを要求\n3. **横取り不可**: 他プロセスが保持するリソースを強制的に奪えない\n4. **循環待ち**: プロセス間でリソースの循環的な待ちが存在"}', 1),
('20000000-0000-0000-0000-000000000007', 'code', '{"language": "python", "code": "import threading\n\nlock_a = threading.Lock()\nlock_b = threading.Lock()\n\ndef thread_1():\n    with lock_a:                # A を取得\n        print(\"T1: got A\")\n        with lock_b:            # B を待つ → デッドロック!\n            print(\"T1: got B\")\n\ndef thread_2():\n    with lock_b:                # B を取得\n        print(\"T2: got B\")\n        with lock_a:            # A を待つ → デッドロック!\n            print(\"T2: got A\")\n\n# 解決策: ロック順序を統一する\ndef thread_1_fixed():\n    with lock_a:                # 常に A → B の順\n        with lock_b:\n            print(\"T1: got A and B\")\n\ndef thread_2_fixed():\n    with lock_a:                # 常に A → B の順\n        with lock_b:\n            print(\"T2: got A and B\")", "runnable": false}', 2),
('20000000-0000-0000-0000-000000000007', 'markdown', '{"text": "## デッドロックの対策\n\n| 戦略 | 方法 | 実用性 |\n|---|---|---|\n| **予防** | 4条件のいずれかを破る（例: ロック順序の統一） | 高い |\n| **回避** | 銀行家のアルゴリズムで安全性を事前チェック | 理論的 |\n| **検出と回復** | 待ちグラフで循環を検出し、プロセスを強制終了 | DB で採用 |\n| **無視** | 発生頻度が低ければ対処しない（鴕鳥アルゴリズム） | 多くの OS |"}', 3),
('20000000-0000-0000-0000-000000000007', 'callout', '{"type": "tip", "text": "実務では「ロック順序の統一」が最も効果的なデッドロック予防策です。全てのスレッドが同じ順序でロックを取得すれば循環待ちは発生しません。"}', 4);

-- ===== Lessons: ファイルシステム =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000008', 'c1000000-0000-0000-0000-000000000005', 'filesystem-basics',
  'ファイルシステムの基礎', 'ファイルの管理構造とディスク上のデータ配置', 1, 15, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000008', 'markdown', '{"text": "# ファイルシステムの基礎\n\nファイルシステムは、ディスク上のデータを**ファイル**と**ディレクトリ**として体系的に管理する仕組みです。\n\nOS はファイルシステムを通じて、アプリケーションに統一的なデータアクセスのインターフェースを提供します。"}', 0),
('20000000-0000-0000-0000-000000000008', 'markdown', '{"text": "## inode（UNIX系ファイルシステム）\n\n**inode** はファイルのメタデータを格納するデータ構造です:\n\n- ファイルサイズ\n- 所有者・グループ\n- パーミッション（rwx）\n- タイムスタンプ（作成・更新・アクセス）\n- データブロックへのポインタ\n\n重要: **ファイル名は inode には含まれません**。ファイル名はディレクトリエントリが管理します。"}', 1),
('20000000-0000-0000-0000-000000000008', 'code', '{"language": "bash", "code": "# inode 情報の確認\n$ ls -i file.txt\n1234567 file.txt\n\n$ stat file.txt\n  File: file.txt\n  Size: 1024      Blocks: 8    IO Block: 4096   regular file\n  Inode: 1234567  Links: 1\n  Access: (0644/-rw-r--r--)  Uid: (1000/user)  Gid: (1000/user)\n  Access: 2024-01-15 10:30:00\n  Modify: 2024-01-15 09:00:00\n\n# ハードリンク（同じ inode を指す別名）\n$ ln file.txt hardlink.txt\n$ ls -i file.txt hardlink.txt\n1234567 file.txt\n1234567 hardlink.txt  # 同じ inode!", "runnable": false}', 2),
('20000000-0000-0000-0000-000000000008', 'markdown', '{"text": "## 代表的なファイルシステム\n\n| FS | OS | 特徴 |\n|---|---|---|\n| ext4 | Linux | ジャーナリング、最大16TB |\n| XFS | Linux | 大規模ファイル向け、並列I/O |\n| Btrfs | Linux | CoW、スナップショット、自己修復 |\n| APFS | macOS/iOS | 暗号化、スナップショット、SSD最適化 |\n| NTFS | Windows | ACL、暗号化、圧縮 |"}', 3),
('20000000-0000-0000-0000-000000000008', 'callout', '{"type": "tip", "text": "ジャーナリングファイルシステムは、書き込み操作をログ（ジャーナル）に先行記録することで、停電やクラッシュ時のデータ整合性を保護します。"}', 4);
