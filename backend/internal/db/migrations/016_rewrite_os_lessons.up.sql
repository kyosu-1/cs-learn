-- Delete old OS lessons
DELETE FROM lesson_blocks WHERE lesson_id IN (
  '20000000-0000-0000-0000-000000000001',
  '20000000-0000-0000-0000-000000000002',
  '20000000-0000-0000-0000-000000000003',
  '20000000-0000-0000-0000-000000000004',
  '20000000-0000-0000-0000-000000000005',
  '20000000-0000-0000-0000-000000000006',
  '20000000-0000-0000-0000-000000000007',
  '20000000-0000-0000-0000-000000000008'
);
DELETE FROM lessons WHERE id IN (
  '20000000-0000-0000-0000-000000000001',
  '20000000-0000-0000-0000-000000000002',
  '20000000-0000-0000-0000-000000000003',
  '20000000-0000-0000-0000-000000000004',
  '20000000-0000-0000-0000-000000000005',
  '20000000-0000-0000-0000-000000000006',
  '20000000-0000-0000-0000-000000000007',
  '20000000-0000-0000-0000-000000000008'
);

-- ============================================================
-- Process & Thread: 初級→中級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000001', 'process-and-thread',
  'プロセスとスレッド', 'PCB、状態遷移モデル、コンテキストスイッチのコスト、ユーザースレッドとカーネルスレッド。', 2, 25, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000001', 'markdown', '{"text": "# プロセスとスレッド\n\n## プロセスとは\n\nプロセスは**実行中のプログラムのインスタンス**です。プログラム（ディスク上の静的な実行ファイル）とプロセス（メモリ上で実行中の動的な実体）は明確に区別されます。\n\nOS はプロセスごとに**PCB（Process Control Block）**を管理します:\n\n| PCB の内容 | 説明 |\n|---|---|\n| PID | プロセスの一意識別子 |\n| プロセス状態 | new, ready, running, waiting, terminated |\n| プログラムカウンタ | 次に実行する命令のアドレス |\n| CPU レジスタ | 汎用レジスタ、スタックポインタ等の保存値 |\n| メモリ管理情報 | ページテーブルのベースアドレス、セグメント情報 |\n| I/O 情報 | オープンしているファイルディスクリプタのリスト |\n| スケジューリング情報 | 優先度、使用CPU時間 |"}', 0),

('20000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## プロセスの状態遷移\n\n```\n            admit           dispatch\n  [New] ──────→ [Ready] ──────→ [Running]\n                  ↑                │\n                  │  I/O完了       │ I/O要求\n                  │                ↓\n                  └──────── [Waiting]\n                                   \n  [Running] ──→ [Terminated]  (exit)\n  [Running] ──→ [Ready]       (タイムアウト/プリエンプション)\n```\n\n**コンテキストスイッチ**: Running プロセスを切り替える際に発生。現プロセスの CPU 状態を PCB に保存し、次プロセスの CPU 状態を PCB から復元します。\n\nコンテキストスイッチのコスト:\n- レジスタの保存/復元: 数マイクロ秒\n- TLB のフラッシュ: ページテーブルが異なるため\n- キャッシュのコールドスタート: 切り替え後はキャッシュミスが増加\n\n合計で **数マイクロ秒〜数十マイクロ秒**。頻繁なスイッチはオーバーヘッドになります。"}', 1),

('20000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## スレッド\n\nスレッドはプロセス内の**軽量な実行単位**です。同一プロセス内のスレッドは以下を**共有**します:\n\n- コード領域、データ領域、ヒープ\n- オープンファイル、シグナルハンドラ\n\n各スレッドが**独自に持つ**もの:\n\n- スタック（関数のローカル変数、戻りアドレス）\n- プログラムカウンタ\n- レジスタの値\n- スレッド固有データ（TLS: Thread-Local Storage）\n\n### ユーザースレッド vs カーネルスレッド\n\n| | ユーザースレッド | カーネルスレッド |\n|---|---|---|\n| 管理主体 | ユーザー空間のライブラリ | OS カーネル |\n| 切り替えコスト | 低い（カーネル介入不要） | 高い（システムコール） |\n| マルチコア利用 | 不可（1カーネルスレッドに多対1） | 可能 |\n| ブロッキングI/O | 全スレッドがブロック | 当該スレッドのみ |\n\n現代の OS では **1:1 モデル**（ユーザースレッド1つにカーネルスレッド1つ）が主流です（Linux の NPTL、Windows のスレッド）。Go の goroutine は M:N モデル（多対多）を採用しています。"}', 2),

('20000000-0000-0000-0000-000000000001', 'code', '{"language": "c", "code": "// POSIX スレッド (pthreads) による並行処理\n#include <pthread.h>\n#include <stdio.h>\n\nvoid *worker(void *arg) {\n    int id = *(int *)arg;\n    printf(\"Thread %d: pid=%d, tid=%lu\\n\", id, getpid(), pthread_self());\n    return NULL;\n}\n\nint main() {\n    pthread_t threads[4];\n    int ids[4];\n    \n    for (int i = 0; i < 4; i++) {\n        ids[i] = i;\n        // pthread_create: カーネルスレッドを生成\n        pthread_create(&threads[i], NULL, worker, &ids[i]);\n    }\n    \n    for (int i = 0; i < 4; i++) {\n        pthread_join(threads[i], NULL);  // 終了を待機\n    }\n    \n    return 0;\n    // 全スレッドが同じ PID を持つことに注目\n}", "runnable": false}', 3),

('20000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## まとめ\n\n| 特性 | プロセス | スレッド |\n|---|---|---|\n| メモリ空間 | 独立（仮想アドレス空間） | 共有（同一プロセス内） |\n| 生成コスト | 高い（PCB作成、ページテーブル複製） | 低い（スタック割り当てのみ） |\n| コンテキストスイッチ | 高い（TLBフラッシュ含む） | 低い（同一アドレス空間） |\n| 障害の影響範囲 | プロセス内に限定 | 同一プロセス内の全スレッドに波及 |\n| 通信 | IPC（パイプ、ソケット、共有メモリ） | 共有変数（要排他制御） |\n\n**学習のポイント**: PCB がプロセスの全状態を保持する構造体であること。コンテキストスイッチのコストが TLB・キャッシュに波及すること。スレッドモデル（1:1, M:N）の設計上のトレードオフ。"}', 4);

-- ============================================================
-- fork & exec: 中級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000001', 'fork-and-exec',
  'fork と exec', 'UNIX のプロセス生成モデル。CoW最適化、ゾンビプロセス、シェルの仕組み。', 2, 20, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000002', 'markdown', '{"text": "# fork と exec\n\nUNIX系 OS では、新プロセスの生成を **fork()** と **exec()** の2段階で行います。\n\n## fork()\n\n呼び出したプロセス（親）の**ほぼ完全なコピー**（子）を生成するシステムコール。\n\n- 親プロセス: fork() は**子の PID** を返す\n- 子プロセス: fork() は **0** を返す\n- エラー時: **-1** を返す\n\n子は親の PCB、メモリ空間、ファイルディスクリプタをコピーとして受け取ります。fork 直後は親子で同じプログラムの同じ地点から実行が分岐します。\n\n## exec()\n\n現在のプロセスのメモリ空間を**新しいプログラムで完全に置き換える**システムコール。PID は変わりません。\n\nfork + exec の組み合わせにより、「現在のプロセスを壊さずに新しいプログラムを実行」できます。これがシェルのコマンド実行の仕組みです。"}', 0),

('20000000-0000-0000-0000-000000000002', 'code', '{"language": "c", "code": "#include <stdio.h>\n#include <stdlib.h>\n#include <unistd.h>\n#include <sys/wait.h>\n\n// シェルのコマンド実行を簡略化した例\nint main() {\n    printf(\"Shell PID: %d\\n\", getpid());\n    \n    pid_t pid = fork();\n    \n    if (pid < 0) {\n        perror(\"fork failed\");\n        exit(1);\n    } else if (pid == 0) {\n        // 子プロセス: 新しいプログラムに置き換え\n        printf(\"Child PID: %d, executing ls...\\n\", getpid());\n        execlp(\"ls\", \"ls\", \"-la\", NULL);\n        // exec が成功すると以下は実行されない\n        perror(\"exec failed\");\n        exit(1);\n    } else {\n        // 親プロセス: 子の終了を待機\n        int status;\n        waitpid(pid, &status, 0);\n        \n        if (WIFEXITED(status)) {\n            printf(\"Child exited with code %d\\n\", WEXITSTATUS(status));\n        }\n    }\n    return 0;\n}", "runnable": false}', 1),

('20000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## Copy-on-Write (CoW)\n\nfork() は論理的にはメモリ全体をコピーしますが、物理的には **Copy-on-Write** で最適化されています:\n\n1. fork 直後: 親子で**同じ物理ページを共有**（読み取り専用に設定）\n2. どちらかが書き込みを行うと: **ページフォールト**が発生し、該当ページだけをコピー\n3. exec() をすぐ呼ぶ場合: ページコピーはほぼ発生しない\n\nこの最適化により、fork() のコストは生成するメモリ量ではなく**ページテーブルのコピーコスト**に抑えられます。\n\n## ゾンビプロセスと孤児プロセス\n\n| 状態 | 原因 | 問題 | 対策 |\n|---|---|---|---|\n| ゾンビ | 子が終了したが親が wait() していない | PCB がカーネルに残り続ける | 親で wait()/waitpid() を呼ぶ |\n| 孤児 | 親が先に終了した | init/systemd が養親になる | 自動的に回収される |\n\nゾンビが大量に溜まるとPIDテーブルが枯渇し、新しいプロセスを生成できなくなります。サーバーでは SIGCHLD シグナルのハンドラで非同期に回収するのが一般的です。"}', 2),

('20000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## なぜ fork + exec の2段階なのか\n\nWindows の CreateProcess() のように、1回のシステムコールで新プロセスを作る設計もあり得ます。UNIX が2段階に分けた理由:\n\n1. **fork と exec の間で準備ができる**: ファイルディスクリプタのリダイレクト、環境変数の設定、権限の変更\n2. **fork だけで使える**: 親と同じ処理を並列に行うワーカープロセスの生成\n3. **exec だけで使える**: 現在のプロセスを別のプログラムに置き換え\n\nシェルのパイプ `ls | grep foo` は、fork → パイプの設定 → exec の流れで実現されています。\n\n**学習のポイント**: fork の戻り値による親子の区別、CoW がなぜ効率的か、ゾンビプロセスの原因と対策、fork+exec の設計思想。"}', 3);

-- ============================================================
-- CPU Scheduling: 中級→上級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000002', 'cpu-scheduling',
  'CPUスケジューリング', 'FCFS/SJF/RR/Priority の計算量と特性。プリエンプション、飢餓、CFS。', 2, 30, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000003', 'markdown', '{"text": "# CPUスケジューリング\n\nCPUスケジューリングは、Ready キューにあるプロセスの中から次に CPU を割り当てるプロセスを選択する仕組みです。\n\n## 評価指標\n\n| 指標 | 定義 | 目標 |\n|---|---|---|\n| **CPU利用率** | CPUが稼働している時間の割合 | 最大化 |\n| **スループット** | 単位時間あたりの完了プロセス数 | 最大化 |\n| **ターンアラウンドタイム** | 投入から完了までの時間 | 最小化 |\n| **待ち時間** | Readyキューで待機した合計時間 | 最小化 |\n| **応答時間** | 投入から最初の応答までの時間 | 最小化（対話型で重要） |\n\nこれらの指標は互いにトレードオフの関係にあり、すべてを同時に最適化することはできません。"}', 0),

('20000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## 主要アルゴリズム\n\n### FCFS（First Come, First Served）\n\n到着順に処理。非プリエンプティブ。\n\n- 利点: 実装が最も単純（FIFOキュー）\n- 欠点: **コンボイ効果** — CPU バウンドの長いジョブが後続の短いジョブをブロック\n- 平均待ち時間: プロセスの到着順に大きく依存\n\n### SJF（Shortest Job First）\n\n推定実行時間が最短のプロセスを優先。\n\n- **最適性**: 与えられたプロセス集合に対して平均待ち時間を**最小化**することが証明されている\n- 欠点: 実行時間を事前に正確に予測できない。**指数移動平均**で過去の実行時間から推定:\n  $\\tau_{n+1} = \\alpha \\cdot t_n + (1 - \\alpha) \\cdot \\tau_n$（α は直近の実行時間の重み、一般に 0.5）\n- プリエンプティブ版（SRTF: Shortest Remaining Time First）はさらに効率的\n\n### Round Robin\n\n各プロセスに固定長のタイムクォンタム q を割り当て、順番に実行。\n\n- q が大きすぎる → FCFS と同じ\n- q が小さすぎる → コンテキストスイッチのオーバーヘッドが支配的\n- 経験則: q はCPUバーストの80%をカバーする程度が良い（一般に 10〜100ms）\n- 応答時間に優れるが、ターンアラウンドタイムは SJF に劣る\n\n### 優先度スケジューリング\n\n各プロセスに優先度を割り当て、高優先度を先に実行。\n\n- **飢餓（Starvation）**: 低優先度プロセスが永遠に実行されない\n- **エージング**: 待ち時間に応じて優先度を徐々に上げることで飢餓を防止"}', 1),

('20000000-0000-0000-0000-000000000003', 'code', '{"language": "python", "code": "from dataclasses import dataclass\n\n@dataclass\nclass Process:\n    name: str\n    arrival: int\n    burst: int\n\ndef fcfs(processes: list[Process]) -> dict[str, dict]:\n    \"\"\"FCFS: 到着順に処理。待ち時間とターンアラウンドタイムを計算。\"\"\"\n    procs = sorted(processes, key=lambda p: p.arrival)\n    time = 0\n    results = {}\n    for p in procs:\n        time = max(time, p.arrival)  # アイドル時間\n        wait = time - p.arrival\n        time += p.burst\n        turnaround = time - p.arrival\n        results[p.name] = {\"wait\": wait, \"turnaround\": turnaround}\n    return results\n\ndef round_robin(processes: list[Process], quantum: int) -> dict[str, dict]:\n    \"\"\"Round Robin: タイムクォンタム q で順番に実行。\"\"\"\n    remaining = {p.name: p.burst for p in processes}\n    queue = [p.name for p in sorted(processes, key=lambda p: p.arrival)]\n    time, results = 0, {}\n    \n    while queue:\n        name = queue.pop(0)\n        run = min(quantum, remaining[name])\n        time += run\n        remaining[name] -= run\n        \n        if remaining[name] == 0:\n            p = next(p for p in processes if p.name == name)\n            results[name] = {\n                \"turnaround\": time - p.arrival,\n                \"wait\": time - p.arrival - p.burst,\n            }\n        else:\n            queue.append(name)\n    \n    return results\n\n# 例\nprocs = [Process(\"P1\", 0, 10), Process(\"P2\", 0, 4), Process(\"P3\", 0, 6)]\nprint(\"FCFS:\", fcfs(procs))\nprint(\"RR(q=3):\", round_robin(procs, 3))", "runnable": false}', 2),

('20000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## Linux の CFS（Completely Fair Scheduler）\n\nLinux 2.6.23以降で採用。赤黒木を使った O(log n) スケジューラ。\n\n### 仕組み\n\n1. 各プロセスに**仮想実行時間（vruntime）**を割り当て\n2. vruntime が最小のプロセスを次に実行（赤黒木の最左ノード）\n3. CPU を使うと vruntime が増加。優先度が低いプロセスは vruntime の増加が速い\n4. 結果的に、全プロセスの vruntime がほぼ均等になる → 公平\n\n### タイムスライスの決定\n\n固定のタイムクォンタムではなく、プロセス数と優先度（nice 値）に基づいて動的に計算:\n\n$\\text{timeslice} = \\frac{\\text{sched\\_latency}}{\\text{nr\\_running}} \\times \\frac{\\text{weight}}{\\text{total\\_weight}}$\n\n## まとめ\n\n| アルゴリズム | プリエンプティブ | 平均待ち時間 | 飢餓 | 実装の複雑さ |\n|---|---|---|---|---|\n| FCFS | No | 大きい（コンボイ効果） | なし | O(1) |\n| SJF/SRTF | 両方 | **最小（証明済み）** | あり | O(n) |\n| Round Robin | Yes | 中程度 | なし | O(1) |\n| Priority | 両方 | 優先度依存 | あり（要エージング） | O(n) |\n| CFS | Yes | 公平 | なし | O(log n) |\n\n**学習のポイント**: SJF の最適性の証明（交換論法）、RR のタイムクォンタムの選択基準、飢餓問題とエージング、CFS の vruntime による公平性の実現。"}', 3);

-- ============================================================
-- Virtual Memory: 中級→上級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000003', 'virtual-memory',
  '仮想メモリ', 'ページング、多段ページテーブル、TLB、ページ置換アルゴリズムの厳密な比較。', 3, 30, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000004', 'markdown', '{"text": "# 仮想メモリ\n\n仮想メモリは、各プロセスに**独立した連続的なアドレス空間**を提供する抽象化機構です。3つの主要な目的があります:\n\n1. **保護**: プロセス間のメモリを隔離し、他プロセスのメモリへの不正アクセスを防止\n2. **抽象化**: 物理メモリの断片化をプロセスから隠蔽し、連続したアドレス空間を提供\n3. **効率**: 物理メモリより大きなアドレス空間の利用、デマンドページングによる遅延割り当て\n\n## アドレス変換\n\n仮想アドレス → 物理アドレスの変換は **MMU（Memory Management Unit）**がハードウェアで実行します。\n\n仮想アドレスの構造（ページサイズ 4KB = 2¹² の場合）:\n\n```\n| ページ番号 (上位ビット) | オフセット (下位12ビット) |\n```\n\nページ番号でページテーブルを索引 → フレーム番号を取得 → フレーム番号 + オフセット = 物理アドレス"}', 0),

('20000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## 多段ページテーブル\n\n64ビットアドレス空間ではページテーブルが巨大になる問題があります。\n\n例: 48ビット仮想アドレス、4KBページの場合:\n- ページテーブルエントリ数: 2³⁶ ≈ 687億個\n- 各エントリ8バイトなら: 512GB（1プロセスあたり!）\n\n**多段ページテーブル**で解決:\n\n- 4段ページテーブル（x86-64）: 各段 9ビット × 4段 + 12ビットオフセット = 48ビット\n- 使用していないページの中間テーブルは割り当てない → 実使用量は数MB程度\n- Linux 5.x以降は5段ページテーブルで57ビットアドレス空間をサポート\n\n## TLB（Translation Lookaside Buffer）\n\nページテーブル参照はメモリアクセスを伴うため遅い。TLB はページテーブルの**キャッシュ**です。\n\n- 一般的なサイズ: 64〜1024エントリ\n- ヒット率: 通常 99%以上（局所性の原理による）\n- TLB ミスの場合: ハードウェアまたはOS がページテーブルを参照\n- コンテキストスイッチ時: TLB をフラッシュ（ASID を使えば回避可能）\n\n**実効メモリアクセス時間の計算**:\n\n$t_{eff} = h \\cdot t_{mem} + (1-h) \\cdot (t_{page\\_walk} + t_{mem})$\n\nh=TLBヒット率、t_mem=メモリアクセス時間、t_page_walk=ページテーブル参照時間"}', 1),

('20000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## デマンドページングとページフォールト\n\n**デマンドページング**: ページが実際にアクセスされるまで物理メモリに割り当てない。\n\n### ページフォールトの処理フロー\n\n1. CPU がページテーブル参照 → Valid ビットが 0（物理メモリにない）\n2. **ページフォールト例外**発生 → OS のハンドラに制御移行\n3. ディスク上のページ位置を特定（スワップ領域 or ファイル）\n4. 空きフレームがなければ**ページ置換**を実行\n5. ディスクからページを読み込み（数ms — メモリアクセスの約10万倍）\n6. ページテーブルを更新（Valid=1、フレーム番号を設定）\n7. 中断した命令を**再実行**\n\n### ページフォールトの影響\n\nディスク I/O（〜10ms）を伴うため:\n\n$t_{eff} = (1-p) \\cdot t_{mem} + p \\cdot t_{page\\_fault}$\n\np=ページフォールト率。p=0.001（0.1%）でもメモリアクセスが約100倍に遅くなります。"}', 2),

('20000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## ページ置換アルゴリズム\n\n物理メモリが満杯のとき、どのページを追い出すかを決定するアルゴリズム。\n\n| アルゴリズム | 方針 | ページフォールト数 | 実装コスト |\n|---|---|---|---|\n| **OPT** | 将来最も長く使われないページ | 最少（理論的最適） | 実装不可能（比較基準） |\n| **FIFO** | 最も古くロードされたページ | 多い、Beladyの異常あり | O(1) |\n| **LRU** | 最も長く参照されていないページ | OPTに近い | 厳密実装は高コスト |\n| **Clock (Second Chance)** | 参照ビットを使った近似LRU | LRUに近い | O(1) 償却 |\n\n### Beladyの異常\n\nFIFOでは、物理フレーム数を増やしてもページフォールトが**増加**する場合がある（直感に反する）。LRU にはこの異常はありません（スタックアルゴリズムであるため）。\n\n### Clock アルゴリズム（Linux で実用）\n\n1. 各ページに参照ビット（R）を持つ\n2. 円環上にポインタを持ち、順に確認:\n   - R=1 → R=0 にリセットして次へ（second chance）\n   - R=0 → このページを置換対象に選択\n3. アクティブなページは R が繰り返し 1 にセットされるため生き残る\n\n**学習のポイント**: 多段ページテーブルの必要性（空間効率）、TLBの役割と実効アクセス時間の計算、ページフォールトのコスト見積もり、各置換アルゴリズムの特性とBelady異常の理解。"}', 3);

-- ============================================================
-- Memory Layout: 初級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000005', 'c1000000-0000-0000-0000-000000000003', 'memory-layout',
  'プロセスのメモリ配置', 'テキスト・データ・BSS・ヒープ・スタック。スタックオーバーフローとヒープ断片化。', 1, 15, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000005', 'markdown', '{"text": "# プロセスのメモリ配置\n\nプロセスの仮想アドレス空間は以下の領域に分かれています（低アドレス → 高アドレス）:\n\n| 領域 | 内容 | 成長方向 |\n|---|---|---|\n| **テキスト（コード）** | 実行可能な機械語命令。読み取り専用。 | 固定 |\n| **データ** | 初期化済みグローバル変数・静的変数 | 固定 |\n| **BSS** | 未初期化グローバル変数（OS がゼロ初期化） | 固定 |\n| **ヒープ** | 動的メモリ割り当て（malloc/new） | ↑ 上方向 |\n| **（空き領域）** | ヒープとスタックの間の未マップ領域 | |\n| **スタック** | 関数の引数、ローカル変数、戻りアドレス | ↓ 下方向 |\n| **カーネル空間** | OS のコードとデータ（ユーザーモードでアクセス不可） | 固定 |\n\nヒープは上方向に、スタックは下方向に成長します。両者が衝突するとメモリ不足です。"}', 0),

('20000000-0000-0000-0000-000000000005', 'code', '{"language": "c", "code": "#include <stdio.h>\n#include <stdlib.h>\n\nint global_init = 42;        // データ領域\nint global_uninit;            // BSS領域（ゼロ初期化）\nconst int constant = 100;     // テキスト領域（読み取り専用）\n\nvoid func() {\n    static int static_var = 5;  // データ領域（関数ローカルだが静的）\n    int local = 10;             // スタック\n    int *heap = malloc(sizeof(int) * 100);  // ヒープ\n    \n    printf(\"Text:    %p\\n\", (void*)func);\n    printf(\"Data:    %p\\n\", (void*)&global_init);\n    printf(\"BSS:     %p\\n\", (void*)&global_uninit);\n    printf(\"Static:  %p\\n\", (void*)&static_var);\n    printf(\"Heap:    %p\\n\", (void*)heap);\n    printf(\"Stack:   %p\\n\", (void*)&local);\n    // アドレスの大小関係で各領域の配置を確認できる\n    \n    free(heap);  // ヒープは手動解放が必要\n}\n\nint main() {\n    func();\n    return 0;\n}", "runnable": false}', 1),

('20000000-0000-0000-0000-000000000005', 'markdown', '{"text": "## よくある問題\n\n### スタックオーバーフロー\n\n再帰が深すぎる、または巨大な配列をローカル変数に確保した場合。スタックサイズは通常 1〜8MB に制限されています（`ulimit -s` で確認可能）。\n\n### ヒープの問題\n\n- **メモリリーク**: 確保したメモリを解放し忘れ。GC のない言語（C/C++）で頻発\n- **ダングリングポインタ**: 解放済みメモリへのアクセス → 未定義動作\n- **断片化**: 小さな確保/解放の繰り返しで連続した空き領域が減少\n\n### バッファオーバーフロー\n\nスタック上のバッファを超えて書き込み → 戻りアドレスの上書き → 攻撃者によるコード実行。対策: スタックカナリア、ASLR（アドレス空間配置ランダム化）、DEP/NX ビット。\n\n**学習のポイント**: 各領域に何が格納されるか、static変数の配置、ヒープとスタックの成長方向、バッファオーバーフローがなぜセキュリティ上危険か。"}', 2);

-- ============================================================
-- Mutex & Semaphore: 中級→上級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000006', 'c1000000-0000-0000-0000-000000000004', 'mutex-and-semaphore',
  'ミューテックスとセマフォ', '競合状態の定義、臨界区間の3条件、ミューテックス/セマフォの意味論の違い。', 2, 25, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000006', 'markdown', '{"text": "# ミューテックスとセマフォ\n\n## 競合状態（Race Condition）\n\n複数のスレッドが共有データに同時アクセスし、結果が**実行順序に依存**する状態。\n\n例: 2スレッドが `counter++` を実行。この操作は機械語レベルでは3ステップ:\n\n1. レジスタにcounterの値をロード\n2. レジスタの値をインクリメント\n3. レジスタの値をcounterに書き戻す\n\n2スレッドが同時にステップ1を実行すると、2回インクリメントしても結果が1しか増えない。\n\n## 臨界区間問題の3条件\n\n正しい排他制御は以下の3条件を満たす必要があります:\n\n1. **相互排除（Mutual Exclusion）**: 同時に1つのスレッドのみが臨界区間に入れる\n2. **進行（Progress）**: 臨界区間に入ろうとするスレッドがいて、かつ臨界区間が空いている場合、有限時間内にどのスレッドが入るか決定される\n3. **有限待機（Bounded Waiting）**: 各スレッドが臨界区間に入るまでの待ち時間に上限がある（飢餓しない）"}', 0),

('20000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## ミューテックス（Mutex）\n\n**所有権のあるバイナリロック**です。\n\n- `lock()`: ロックを取得。すでに取得済みなら待機\n- `unlock()`: ロックを解放。**ロックを取得したスレッドのみが解放可能**\n\n所有権が意味するもの:\n- 再帰ミューテックス: 同一スレッドが複数回ロック可能（ロックカウントで管理）\n- 優先度逆転の防止: 優先度継承プロトコル（低優先度のロック保持者の優先度を一時的に引き上げる）\n\n## セマフォ（Semaphore）\n\nDijkstra が提案した**カウンタベースの同期プリミティブ**。\n\n- `wait()`（P操作）: カウンタ > 0 ならデクリメントして進行。0 なら待機\n- `signal()`（V操作）: カウンタをインクリメント。待機中スレッドがあれば起こす\n- **所有権なし**: wait と signal を異なるスレッドが呼べる\n\n| 種類 | カウンタ初期値 | 用途 |\n|---|---|---|\n| バイナリセマフォ | 1 | 排他制御（ミューテックスに類似） |\n| カウンティングセマフォ | N | リソースプール管理（DBコネクション等） |"}', 1),

('20000000-0000-0000-0000-000000000006', 'code', '{"language": "python", "code": "import threading\n\n# 競合状態のデモ\ncounter = 0\n\ndef unsafe_increment(n: int):\n    global counter\n    for _ in range(n):\n        counter += 1  # アトミックではない!\n\n# ミューテックスで保護\nlock = threading.Lock()\n\ndef safe_increment(n: int):\n    global counter\n    for _ in range(n):\n        with lock:       # acquire + release を自動管理\n            counter += 1\n\n# セマフォによるリソース管理\ndb_pool = threading.Semaphore(5)  # 最大5接続\n\ndef query_db(query_id: int):\n    with db_pool:  # カウンタ > 0 なら進入、0 なら待機\n        print(f\"Query {query_id}: acquired connection\")\n        import time; time.sleep(0.1)  # DB処理をシミュレート\n        print(f\"Query {query_id}: released connection\")\n\n# 10クエリが同時に来ても、最大5つしか同時実行されない\nthreads = [threading.Thread(target=query_db, args=(i,)) for i in range(10)]\nfor t in threads: t.start()\nfor t in threads: t.join()", "runnable": false}', 2),

('20000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## ミューテックス vs セマフォ — 意味論の違い\n\n| | ミューテックス | セマフォ |\n|---|---|---|\n| 目的 | 排他制御（1つのリソースの保護） | 同期・リソースカウント |\n| 所有権 | あり（取得者のみ解放可） | なし（誰でも signal 可） |\n| 再帰 | 可能（再帰ミューテックス） | 不可 |\n| 優先度逆転対策 | 優先度継承プロトコル | なし |\n| 典型的用途 | 共有変数の保護 | 生産者-消費者問題、コネクションプール |\n\n**重要な区別**: ミューテックスは「鍵」（所有者が解錠する）、セマフォは「許可証のカウンタ」（誰でも返却可能）。この違いを混同するとバグの原因になります。\n\n**学習のポイント**: 競合状態が機械語レベルの非アトミック性から生じること。臨界区間の3条件の意味。ミューテックスとセマフォの意味論の違い（所有権）。生産者-消費者問題におけるセマフォの適用。"}', 3);

-- ============================================================
-- Deadlock: 上級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000007', 'c1000000-0000-0000-0000-000000000004', 'deadlock',
  'デッドロック', 'Coffman条件、資源割当グラフ、銀行家のアルゴリズム、実務での対策。', 3, 25, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000007', 'markdown', '{"text": "# デッドロック\n\nデッドロックは、2つ以上のプロセスが**互いに相手が保持するリソースを待ち続けて永遠に進行しない**状態です。\n\n## Coffman の4条件（必要十分条件）\n\nデッドロックは以下の4条件が**すべて同時に**成立したときに発生します:\n\n1. **相互排除**: 少なくとも1つのリソースが排他的に使用される\n2. **保持と待機**: プロセスがリソースを保持したまま、追加のリソースを要求\n3. **横取り不可（No Preemption）**: リソースはプロセスが自発的に解放するまで奪えない\n4. **循環待ち**: プロセスの循環的な待ちチェーンが存在\n\n## 資源割当グラフ（Resource Allocation Graph）\n\n- 頂点: プロセス（丸）とリソース（四角）\n- 要求辺: P → R（P が R を要求中）\n- 割当辺: R → P（R が P に割り当て済み）\n- **グラフにサイクルがある = デッドロックの可能性**（リソースのインスタンスが1つなら必要十分条件）"}', 0),

('20000000-0000-0000-0000-000000000007', 'code', '{"language": "python", "code": "import threading\nimport time\n\n# デッドロックの発生例\nlock_a = threading.Lock()\nlock_b = threading.Lock()\n\ndef thread_1():\n    with lock_a:\n        print(\"T1: acquired A\")\n        time.sleep(0.01)  # 相手がロックBを取る時間を与える\n        with lock_b:       # ここでT2がlock_bを保持 → デッドロック\n            print(\"T1: acquired B\")\n\ndef thread_2():\n    with lock_b:\n        print(\"T2: acquired B\")\n        time.sleep(0.01)\n        with lock_a:       # ここでT1がlock_aを保持 → デッドロック\n            print(\"T2: acquired A\")\n\n# 解決策1: ロック順序の統一（循環待ちの破壊）\ndef thread_1_fixed():\n    with lock_a:          # 常に A → B の順\n        with lock_b:\n            print(\"T1: acquired A and B\")\n\ndef thread_2_fixed():\n    with lock_a:          # 常に A → B の順（BではなくAを先に取得）\n        with lock_b:\n            print(\"T2: acquired A and B\")\n\n# 解決策2: タイムアウト付きロック\ndef thread_with_timeout():\n    if lock_a.acquire(timeout=1.0):\n        try:\n            if lock_b.acquire(timeout=1.0):\n                try:\n                    print(\"acquired both\")\n                finally:\n                    lock_b.release()\n            else:\n                print(\"timeout on B, retrying...\")\n        finally:\n            lock_a.release()", "runnable": false}', 1),

('20000000-0000-0000-0000-000000000007', 'markdown', '{"text": "## デッドロック対策の4戦略\n\n### 1. 予防（Prevention）\n\nCoffman条件のいずれかを**構造的に破壊**:\n\n- **循環待ちの破壊**: 全リソースに全順序を定義し、順序通りにのみ要求 → 最も実用的\n- **保持と待機の破壊**: 必要な全リソースを一括要求（利用効率が下がる）\n- **横取り不可の破壊**: リソースを強制回収（プリンタ等では困難）\n\n### 2. 回避（Avoidance）\n\n**銀行家のアルゴリズム**（Dijkstra）: 各要求時に「安全状態」かをチェック。\n\n- 安全状態: すべてのプロセスが完了可能な実行順序（安全列）が存在\n- 要求を受理すると安全状態を維持できない場合、要求を拒否\n- 計算量: O(n²m)（n=プロセス数、m=リソース種類数）。実用上はオーバーヘッドが大きい\n\n### 3. 検出と回復（Detection and Recovery）\n\n- 定期的に資源割当グラフのサイクルを検出\n- 検出時: プロセスの強制終了、リソースの横取り、ロールバック\n- データベースで広く採用（トランザクションのロールバック）\n\n### 4. 無視（Ostrich Algorithm）\n\nデッドロックの発生頻度が十分低ければ対処しない。発生時は再起動。多くの汎用OSが採用。\n\n## 実務での対策\n\n| 場面 | 手法 |\n|---|---|\n| アプリケーション | ロック順序の統一、タイムアウト付きロック |\n| データベース | デッドロック検出 + トランザクションロールバック |\n| 分散システム | リース（有効期限付きロック）、楽観的並行制御 |\n\n**学習のポイント**: Coffman条件の各条件がなぜ必要か。資源割当グラフとサイクル検出。銀行家のアルゴリズムの安全状態の定義。実務ではロック順序統一が最も費用対効果が高い。"}', 2);

-- ============================================================
-- File System: 中級
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('20000000-0000-0000-0000-000000000008', 'c1000000-0000-0000-0000-000000000005', 'filesystem-basics',
  'ファイルシステム', 'inode、ディレクトリ構造、ジャーナリング、VFS。', 2, 25, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000008', 'markdown', '{"text": "# ファイルシステム\n\nファイルシステムは、ディスク上のバイト列を**ファイル**と**ディレクトリ**として構造化して管理する仕組みです。\n\n## ファイルの実装: inode（UNIX系）\n\n**inode**（index node）はファイルのメタデータとデータブロックへのポインタを格納する構造体です:\n\n| フィールド | 内容 |\n|---|---|\n| ファイル種別 | 通常ファイル、ディレクトリ、シンボリックリンク、デバイス等 |\n| パーミッション | owner/group/others × read/write/execute |\n| 所有者・グループ | UID, GID |\n| サイズ | バイト数 |\n| タイムスタンプ | atime（最終アクセス）、mtime（最終変更）、ctime（メタデータ変更） |\n| リンク数 | この inode を参照するディレクトリエントリの数 |\n| データブロックポインタ | 直接ポインタ12個 + 間接ポインタ（1段/2段/3段） |\n\n**重要**: ファイル名は inode に含まれません。ファイル名はディレクトリエントリ（inode番号とファイル名の対）が管理します。\n\n### データブロックの参照（ext4 の場合）\n\n- 直接ポインタ × 12: 12 × 4KB = 48KB\n- 1段間接: 1024個のポインタ → 4MB\n- 2段間接: 1024² → 4GB\n- 3段間接: 1024³ → 4TB\n\n（実際の ext4 はエクステントベースで、連続ブロックを効率的に管理）"}', 0),

('20000000-0000-0000-0000-000000000008', 'markdown', '{"text": "## ディレクトリ\n\nディレクトリは特殊なファイルで、中身は **(ファイル名, inode番号)** の対のリストです。\n\n### ハードリンクとシンボリックリンク\n\n| | ハードリンク | シンボリックリンク |\n|---|---|---|\n| 実体 | 同じ inode への別名 | パス名を格納する独立ファイル |\n| inode | 同一 | 異なる |\n| ファイルシステム跨ぎ | 不可 | 可能 |\n| 元ファイル削除 | リンク数が0になるまでデータ残存 | リンク切れ（dangling link） |\n| ディレクトリへのリンク | 不可（ループ防止） | 可能 |"}', 1),

('20000000-0000-0000-0000-000000000008', 'code', '{"language": "bash", "code": "# inode の確認\n$ ls -li\n1234567 -rw-r--r-- 2 user group 1024 Jan 15 10:00 file.txt\n1234567 -rw-r--r-- 2 user group 1024 Jan 15 10:00 hardlink.txt\n#       ↑ 同じinode  ↑ リンク数=2\n\n# ディスク使用量の確認\n$ df -h          # ファイルシステムの使用状況\n$ du -sh ./      # ディレクトリのサイズ\n\n# inode 使用状況の確認\n$ df -i          # 空きinode数\n# 小さなファイルが大量にあるとinode枯渇が起きる\n\n# ファイルシステムの作成とマウント\n$ mkfs.ext4 /dev/sdb1          # ext4 で初期化\n$ mount /dev/sdb1 /mnt/data    # マウント", "runnable": false}', 2),

('20000000-0000-0000-0000-000000000008', 'markdown', '{"text": "## ジャーナリングとデータ整合性\n\nファイル書き込み中にクラッシュすると、データとメタデータの不整合が発生します。\n\n**ジャーナリング**: 変更を実際に適用する前に、**ジャーナル（ログ）に変更内容を先行記録**（Write-Ahead Logging）。\n\n1. 変更内容をジャーナルに書き込み\n2. 実際のデータ/メタデータを更新\n3. ジャーナルから該当エントリを削除\n\nクラッシュ後の復旧: ジャーナルを再生（replay）して未完了の操作を完了または取り消し。fsck の実行時間が大幅に短縮。\n\n| モード | 対象 | 性能 | 安全性 |\n|---|---|---|---|\n| journal | データ+メタデータ | 遅い | 最も安全 |\n| ordered（デフォルト） | メタデータのみ（データ先行書込み） | 中 | 実用的 |\n| writeback | メタデータのみ | 速い | データ消失リスクあり |\n\n## VFS（Virtual File System）\n\nLinux カーネルは**VFS**という抽象化層を持ち、異なるファイルシステム（ext4, XFS, NFS, procfs 等）を統一的なインターフェース（open, read, write, close）で操作できます。新しいファイルシステムのサポートは VFS のインターフェースを実装するだけで追加可能です。\n\n**学習のポイント**: inode がメタデータとブロックポインタを分離する設計。ファイル名はディレクトリが管理する点。ハードリンクとシンボリックリンクの本質的違い。ジャーナリングによるクラッシュ整合性の保証。"}', 3);
