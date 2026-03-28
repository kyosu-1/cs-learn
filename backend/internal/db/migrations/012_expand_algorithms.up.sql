-- New categories for Algorithms & Data Structures
INSERT INTO categories (id, topic_id, slug, title, description, sort_order) VALUES
('c0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000001', 'dynamic-programming', '動的計画法', 'メモ化、タブレーション、最適部分構造', 6),
('c0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000001', 'hash-tables', 'ハッシュテーブル', 'ハッシュ関数、衝突解決、計算量', 7),
('c0000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000001', 'heaps', 'ヒープ', '優先度付きキュー、ヒープソート', 8);

-- ===== Lessons: 動的計画法 =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000010', 'c0000000-0000-0000-0000-000000000006', 'dp-introduction',
  '動的計画法入門', '重複する部分問題を効率的に解く手法', 2, 20, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000010', 'markdown', '{"text": "# 動的計画法（Dynamic Programming）\n\n動的計画法（DP）は、**重複する部分問題**を持つ問題を効率的に解く手法です。\n\n一度計算した結果を保存（メモ化）し、同じ計算を繰り返さないことで計算量を大幅に削減します。"}', 0),
('10000000-0000-0000-0000-000000000010', 'callout', '{"type": "info", "text": "DPが適用できる条件: (1) 最適部分構造（部分問題の最適解から全体の最適解を構築可能）、(2) 重複する部分問題（同じ部分問題が何度も出現）"}', 1),
('10000000-0000-0000-0000-000000000010', 'markdown', '{"text": "## フィボナッチ数列で理解するDP\n\n### 再帰（非効率）: O(2^n)\n同じ値を何度も計算してしまう。\n\n### メモ化再帰（トップダウン）: O(n)\n計算済みの結果をキャッシュ。\n\n### タブレーション（ボトムアップ）: O(n)\n小さい問題から順に解を構築。"}', 2),
('10000000-0000-0000-0000-000000000010', 'code', '{"language": "python", "code": "# 再帰（O(2^n) — 非効率）\ndef fib_naive(n):\n    if n <= 1: return n\n    return fib_naive(n-1) + fib_naive(n-2)\n\n# メモ化再帰（トップダウン DP）\ndef fib_memo(n, memo={}):\n    if n <= 1: return n\n    if n in memo: return memo[n]\n    memo[n] = fib_memo(n-1, memo) + fib_memo(n-2, memo)\n    return memo[n]\n\n# タブレーション（ボトムアップ DP）\ndef fib_tab(n):\n    if n <= 1: return n\n    dp = [0] * (n + 1)\n    dp[1] = 1\n    for i in range(2, n + 1):\n        dp[i] = dp[i-1] + dp[i-2]\n    return dp[n]\n\n# 空間最適化: O(1)\ndef fib_opt(n):\n    if n <= 1: return n\n    a, b = 0, 1\n    for _ in range(2, n + 1):\n        a, b = b, a + b\n    return b\n\nprint(fib_tab(50))  # 12586269025（瞬時に計算可能）", "runnable": false}', 3),
('10000000-0000-0000-0000-000000000010', 'markdown', '{"text": "## 代表的なDP問題\n\n| 問題 | 説明 | 計算量 |\n|---|---|---|\n| ナップサック問題 | 重さ制限内で価値最大化 | O(nW) |\n| 最長共通部分列（LCS） | 2つの文字列の共通部分列 | O(nm) |\n| 編集距離 | 文字列の変換最小コスト | O(nm) |\n| コイン問題 | 最小枚数で金額を構成 | O(nS) |\n| 最長増加部分列（LIS） | 単調増加の最長部分列 | O(n log n) |"}', 4);

-- Lesson: ナップサック問題
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000011', 'c0000000-0000-0000-0000-000000000006', 'knapsack',
  'ナップサック問題', 'DPの代表的な最適化問題', 3, 15, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000011', 'markdown', '{"text": "# ナップサック問題\n\n**0-1ナップサック問題**: 重さの制限があるナップサックに、各アイテムを入れるか入れないかを決めて、合計価値を最大化する。\n\n各アイテムは1つしか選べない（0か1）。"}', 0),
('10000000-0000-0000-0000-000000000011', 'code', '{"language": "python", "code": "def knapsack(weights, values, capacity):\n    n = len(weights)\n    # dp[i][w] = i番目までのアイテムで容量wの時の最大価値\n    dp = [[0] * (capacity + 1) for _ in range(n + 1)]\n    \n    for i in range(1, n + 1):\n        for w in range(capacity + 1):\n            dp[i][w] = dp[i-1][w]  # アイテムiを入れない\n            if weights[i-1] <= w:\n                # アイテムiを入れた場合と比較\n                dp[i][w] = max(dp[i][w],\n                               dp[i-1][w - weights[i-1]] + values[i-1])\n    \n    return dp[n][capacity]\n\nweights = [2, 3, 4, 5]\nvalues  = [3, 4, 5, 6]\ncapacity = 8\nprint(knapsack(weights, values, capacity))  # 10", "runnable": false}', 1),
('10000000-0000-0000-0000-000000000011', 'callout', '{"type": "tip", "text": "空間計算量は1次元配列で O(W) に最適化できます。逆順にループすることで前の行の値を保持します。"}', 2);

-- ===== Lessons: ハッシュテーブル =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000012', 'c0000000-0000-0000-0000-000000000007', 'hash-table-basics',
  'ハッシュテーブルの基礎', '平均O(1)のデータ構造', 1, 15, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000012', 'markdown', '{"text": "# ハッシュテーブル\n\nハッシュテーブル（辞書、マップ）はキーと値のペアを格納するデータ構造です。\n\n**ハッシュ関数**でキーを配列のインデックスに変換し、平均 O(1) で検索・挿入・削除を実現します。"}', 0),
('10000000-0000-0000-0000-000000000012', 'callout', '{"type": "info", "text": "Python の dict、Java の HashMap、Go の map、JavaScript の Object/Map はすべてハッシュテーブルベースです。"}', 1),
('10000000-0000-0000-0000-000000000012', 'markdown', '{"text": "## ハッシュ衝突の解決\n\n異なるキーが同じインデックスにマッピングされることを**衝突（collision）**と呼びます。\n\n### チェイニング法\n各バケットを連結リストにして衝突要素を繋げる。\n- 実装が簡単\n- 最悪 O(n)（全要素が同じバケットに集中）\n\n### オープンアドレス法\n衝突時に別の空きスロットを探す。\n- **線形探索**: 次のスロットを順に探す\n- **二次探索**: i², 2i² のように間隔を広げる\n- **ダブルハッシュ**: 別のハッシュ関数で間隔を決定"}', 2),
('10000000-0000-0000-0000-000000000012', 'code', '{"language": "python", "code": "# 簡易ハッシュテーブルの実装\nclass HashTable:\n    def __init__(self, size=16):\n        self.size = size\n        self.buckets = [[] for _ in range(size)]  # チェイニング法\n    \n    def _hash(self, key):\n        return hash(key) % self.size\n    \n    def put(self, key, value):\n        idx = self._hash(key)\n        for i, (k, v) in enumerate(self.buckets[idx]):\n            if k == key:\n                self.buckets[idx][i] = (key, value)  # 更新\n                return\n        self.buckets[idx].append((key, value))  # 新規追加\n    \n    def get(self, key):\n        idx = self._hash(key)\n        for k, v in self.buckets[idx]:\n            if k == key:\n                return v\n        raise KeyError(key)\n    \n    def delete(self, key):\n        idx = self._hash(key)\n        self.buckets[idx] = [(k, v) for k, v in self.buckets[idx] if k != key]", "runnable": false}', 3),
('10000000-0000-0000-0000-000000000012', 'markdown', '{"text": "## 計算量\n\n| 操作 | 平均 | 最悪 |\n|---|---|---|\n| 検索 | O(1) | O(n) |\n| 挿入 | O(1) | O(n) |\n| 削除 | O(1) | O(n) |\n\n負荷率（load factor = 要素数/バケット数）が一定以上になるとリサイズ（rehash）を行い、性能を維持します。"}', 4);

-- ===== Lessons: ヒープ =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000013', 'c0000000-0000-0000-0000-000000000008', 'heap-basics',
  'ヒープと優先度付きキュー', '最小値/最大値を効率的に取得するデータ構造', 2, 15, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000013', 'markdown', '{"text": "# ヒープと優先度付きキュー\n\n**ヒープ**は完全二分木の一種で、以下の性質を満たします:\n\n- **最小ヒープ**: 親ノード ≤ 子ノード（ルートが最小値）\n- **最大ヒープ**: 親ノード ≥ 子ノード（ルートが最大値）\n\nヒープは**優先度付きキュー**の効率的な実装として使われます。"}', 0),
('10000000-0000-0000-0000-000000000013', 'callout', '{"type": "info", "text": "計算量: 挿入 O(log n)、最小/最大値の取得 O(1)、最小/最大値の削除 O(log n)"}', 1),
('10000000-0000-0000-0000-000000000013', 'code', '{"language": "python", "code": "import heapq\n\n# Python の heapq は最小ヒープ\nnums = [5, 3, 8, 1, 9, 2]\nheapq.heapify(nums)          # O(n) でヒープ化\nprint(nums)                   # [1, 3, 2, 5, 9, 8]\n\nheapq.heappush(nums, 0)       # 挿入: O(log n)\nprint(heapq.heappop(nums))    # 最小値を取り出し: 0\nprint(heapq.heappop(nums))    # 次の最小値: 1\n\n# Top-K 問題: 配列から上位K個の要素を取得\ndef top_k(arr, k):\n    return heapq.nlargest(k, arr)\n\nprint(top_k([3, 1, 4, 1, 5, 9, 2, 6], 3))  # [9, 6, 5]", "runnable": false}', 2),
('10000000-0000-0000-0000-000000000013', 'markdown', '{"text": "## ヒープの応用\n\n| 応用 | 説明 |\n|---|---|\n| 優先度付きキュー | タスクスケジューリング、イベント処理 |\n| ヒープソート | O(n log n)、インプレース、不安定 |\n| ダイクストラ法 | 最短経路問題での効率的な頂点選択 |\n| Top-K 問題 | 大規模データから上位K件を効率的に抽出 |\n| 中央値の計算 | 最大ヒープ + 最小ヒープで O(log n) |"}', 3);

-- Lesson: ダイクストラ法（グラフカテゴリに追加）
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000014', 'c0000000-0000-0000-0000-000000000004', 'dijkstra',
  'ダイクストラ法', '重み付きグラフの最短経路アルゴリズム', 3, 18, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000014', 'markdown', '{"text": "# ダイクストラ法\n\nダイクストラ法は**非負の重み**を持つグラフにおいて、単一始点からすべての頂点への最短経路を求めるアルゴリズムです。\n\n貪欲法に基づき、まだ確定していない頂点の中から最短距離の頂点を選んで確定していきます。"}', 0),
('10000000-0000-0000-0000-000000000014', 'callout', '{"type": "info", "text": "計算量: 優先度付きキュー（ヒープ）使用時 O((V + E) log V)。負の重みがある場合はベルマンフォード法を使用。"}', 1),
('10000000-0000-0000-0000-000000000014', 'code', '{"language": "python", "code": "import heapq\n\ndef dijkstra(graph, start):\n    \"\"\"graph: {node: [(neighbor, weight), ...]}\"\"\"\n    dist = {node: float(\"inf\") for node in graph}\n    dist[start] = 0\n    pq = [(0, start)]  # (距離, ノード)\n    \n    while pq:\n        d, u = heapq.heappop(pq)\n        if d > dist[u]:\n            continue  # すでにより短い経路が見つかっている\n        \n        for v, weight in graph[u]:\n            new_dist = dist[u] + weight\n            if new_dist < dist[v]:\n                dist[v] = new_dist\n                heapq.heappush(pq, (new_dist, v))\n    \n    return dist\n\ngraph = {\n    \"A\": [(\"B\", 4), (\"C\", 2)],\n    \"B\": [(\"A\", 4), (\"D\", 3), (\"E\", 1)],\n    \"C\": [(\"A\", 2), (\"D\", 5)],\n    \"D\": [(\"B\", 3), (\"C\", 5), (\"E\", 2)],\n    \"E\": [(\"B\", 1), (\"D\", 2)],\n}\n\nresult = dijkstra(graph, \"A\")\n# {A: 0, B: 4, C: 2, D: 7, E: 5}", "runnable": false}', 2),
('10000000-0000-0000-0000-000000000014', 'markdown', '{"text": "## 最短経路アルゴリズムの比較\n\n| アルゴリズム | 負の重み | 計算量 | 用途 |\n|---|---|---|---|\n| BFS | 重みなしのみ | O(V+E) | 重みなし最短経路 |\n| ダイクストラ | 非負のみ | O((V+E)log V) | 重み付き最短経路 |\n| ベルマンフォード | 対応 | O(VE) | 負の重み、負閉路検出 |\n| ワーシャルフロイド | 対応 | O(V³) | 全頂点間最短経路 |"}', 3);

-- ===== Quizzes for new categories =====

-- Quiz: 動的計画法
INSERT INTO quizzes (id, category_id, title, difficulty_level, is_published)
VALUES ('d0000000-0000-0000-0000-000000000005', 'c0000000-0000-0000-0000-000000000006',
  '動的計画法クイズ', 2, true);

INSERT INTO questions (id, quiz_id, question_type, prompt, options, correct_answer, explanation, sort_order, points) VALUES
('ee000000-0000-0000-0000-000000000020', 'd0000000-0000-0000-0000-000000000005',
  'multiple_choice', '動的計画法が適用できる条件として正しい組み合わせは？',
  '[{"id":"a","text":"最適部分構造と重複する部分問題"},{"id":"b","text":"貪欲選択性質と最適部分構造"},{"id":"c","text":"分割統治と重複しない部分問題"},{"id":"d","text":"探索空間の縮小と枝刈り"}]',
  '{"answer":"a"}',
  'DPは「最適部分構造」（部分問題の最適解から全体の最適解を構築可能）と「重複する部分問題」（同じ部分問題が何度も出現）の2条件が必要です。',
  1, 10),
('ee000000-0000-0000-0000-000000000021', 'd0000000-0000-0000-0000-000000000005',
  'multiple_choice', 'フィボナッチ数列の素朴な再帰の計算量は？',
  '[{"id":"a","text":"O(n)"},{"id":"b","text":"O(n log n)"},{"id":"c","text":"O(2^n)"},{"id":"d","text":"O(n²)"}]',
  '{"answer":"c"}',
  'メモ化なしの再帰では各呼び出しが2つに分岐するため、計算量は指数的 O(2^n) になります。DPで O(n) に改善できます。',
  2, 10),
('ee000000-0000-0000-0000-000000000022', 'd0000000-0000-0000-0000-000000000005',
  'fill_in_blank', '小さい問題から順に解を構築するDPのアプローチを___アップと呼ぶ。',
  NULL, '{"answers":["ボトム","ボトムアップ","bottom"]}',
  'ボトムアップ（タブレーション）は小さい問題から順に解を構築します。逆に大きい問題から再帰的に解くのがトップダウン（メモ化再帰）です。',
  3, 10);

-- Quiz: ハッシュテーブル
INSERT INTO quizzes (id, category_id, title, difficulty_level, is_published)
VALUES ('d0000000-0000-0000-0000-000000000006', 'c0000000-0000-0000-0000-000000000007',
  'ハッシュテーブルクイズ', 1, true);

INSERT INTO questions (id, quiz_id, question_type, prompt, options, correct_answer, explanation, sort_order, points) VALUES
('ee000000-0000-0000-0000-000000000023', 'd0000000-0000-0000-0000-000000000006',
  'multiple_choice', 'ハッシュテーブルの平均的な検索計算量は？',
  '[{"id":"a","text":"O(1)"},{"id":"b","text":"O(log n)"},{"id":"c","text":"O(n)"},{"id":"d","text":"O(n log n)"}]',
  '{"answer":"a"}',
  'ハッシュ関数で直接インデックスを計算するため、衝突がない場合は O(1) で検索できます。',
  1, 10),
('ee000000-0000-0000-0000-000000000024', 'd0000000-0000-0000-0000-000000000006',
  'multiple_choice', '各バケットを連結リストにして衝突を解決する方法は？',
  '[{"id":"a","text":"オープンアドレス法"},{"id":"b","text":"チェイニング法"},{"id":"c","text":"ダブルハッシュ法"},{"id":"d","text":"線形探索法"}]',
  '{"answer":"b"}',
  'チェイニング法（連鎖法）は各バケットを連結リストにして、衝突した要素を繋げます。',
  2, 10);

-- Quiz: ヒープ
INSERT INTO quizzes (id, category_id, title, difficulty_level, is_published)
VALUES ('d0000000-0000-0000-0000-000000000007', 'c0000000-0000-0000-0000-000000000008',
  'ヒープクイズ', 2, true);

INSERT INTO questions (id, quiz_id, question_type, prompt, options, correct_answer, explanation, sort_order, points) VALUES
('ee000000-0000-0000-0000-000000000025', 'd0000000-0000-0000-0000-000000000007',
  'multiple_choice', '最小ヒープのルートノードに格納されている値は？',
  '[{"id":"a","text":"最大値"},{"id":"b","text":"中央値"},{"id":"c","text":"最小値"},{"id":"d","text":"ランダムな値"}]',
  '{"answer":"c"}',
  '最小ヒープではすべての親ノードが子ノード以下の値を持つため、ルートが最小値になります。',
  1, 10),
('ee000000-0000-0000-0000-000000000026', 'd0000000-0000-0000-0000-000000000007',
  'multiple_choice', 'ヒープへの要素挿入の計算量は？',
  '[{"id":"a","text":"O(1)"},{"id":"b","text":"O(log n)"},{"id":"c","text":"O(n)"},{"id":"d","text":"O(n log n)"}]',
  '{"answer":"b"}',
  '要素は末尾に追加し、ヒープの性質が満たされるまで親と交換（bubble up）するため O(log n) です。',
  2, 10),
('ee000000-0000-0000-0000-000000000027', 'd0000000-0000-0000-0000-000000000007',
  'true_false', 'ダイクストラ法の効率的な実装には優先度付きキュー（ヒープ）が使われる。',
  '[{"id":"true","text":"正しい"},{"id":"false","text":"誤り"}]',
  '{"answer":true}',
  'ダイクストラ法では未確定頂点から最短距離のものを選ぶ操作が必要で、ヒープを使うことで O((V+E)log V) を達成できます。',
  3, 10);
