-- Delete old lessons
DELETE FROM lesson_blocks WHERE lesson_id IN (
  '10000000-0000-0000-0000-000000000010',
  '10000000-0000-0000-0000-000000000011',
  '10000000-0000-0000-0000-000000000012',
  '10000000-0000-0000-0000-000000000013',
  '10000000-0000-0000-0000-000000000014'
);
DELETE FROM lessons WHERE id IN (
  '10000000-0000-0000-0000-000000000010',
  '10000000-0000-0000-0000-000000000011',
  '10000000-0000-0000-0000-000000000012',
  '10000000-0000-0000-0000-000000000013',
  '10000000-0000-0000-0000-000000000014'
);

-- ============================================================
-- Dynamic Programming: 中級 (difficulty_level=2)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000010', 'c0000000-0000-0000-0000-000000000006', 'dp-introduction',
  '動的計画法入門', '最適部分構造と重複部分問題。メモ化とタブレーションの設計手法。状態遷移の定式化。', 2, 30, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000010', 'markdown', '{"text": "# 動的計画法（Dynamic Programming）\n\n動的計画法（DP）は、Richard Bellman が1950年代に提唱した最適化手法で、以下の2条件を満たす問題に適用できます:\n\n1. **最適部分構造**: 問題の最適解が部分問題の最適解から構成できる\n2. **重複する部分問題**: 同じ部分問題が再帰の過程で繰り返し出現する\n\nDPの本質は**状態と遷移の定式化**です。「何を状態として定義するか」「どのように状態間を遷移するか」を明確にすることが設計の核心です。"}', 0),

('10000000-0000-0000-0000-000000000010', 'markdown', '{"text": "## 2つのアプローチ\n\n### トップダウン（メモ化再帰）\n\n再帰で問題を分解し、計算済みの結果をキャッシュ（メモ化）する。\n\n- 利点: 必要な部分問題のみ計算（すべての状態を埋めない場合に有利）\n- 欠点: 再帰のスタックオーバーヘッド、深い再帰でスタックオーバーフロー\n\n### ボトムアップ（タブレーション）\n\n小さい部分問題から順にテーブルを埋めていく反復的手法。\n\n- 利点: 再帰のオーバーヘッドなし、空間最適化がしやすい\n- 欠点: すべての状態を埋める（不要な計算が含まれる場合がある）\n\n両者は同じ計算量だが、実装の特性が異なる。"}', 1),

('10000000-0000-0000-0000-000000000010', 'markdown', '{"text": "## 例題1: フィボナッチ数列\n\n### 状態定義\n\n`dp[i]` = i 番目のフィボナッチ数\n\n### 遷移式\n\n`dp[i] = dp[i-1] + dp[i-2]`（i ≥ 2）\n\n### 基底\n\n`dp[0] = 0, dp[1] = 1`\n\n素朴な再帰では同じ値を指数的に再計算するため O(2ⁿ)。DPで O(n) に改善。さらに「直前の2値だけ保持」で空間 O(1) に最適化できます。"}', 2),

('10000000-0000-0000-0000-000000000010', 'code', '{"language": "python", "code": "# 素朴な再帰: O(2^n) — 指数時間\ndef fib_naive(n: int) -> int:\n    if n <= 1: return n\n    return fib_naive(n - 1) + fib_naive(n - 2)\n\n# メモ化再帰（トップダウン）: O(n) 時間、O(n) 空間\nfrom functools import lru_cache\n\n@lru_cache(maxsize=None)\ndef fib_memo(n: int) -> int:\n    if n <= 1: return n\n    return fib_memo(n - 1) + fib_memo(n - 2)\n\n# タブレーション（ボトムアップ）: O(n) 時間、O(n) 空間\ndef fib_tab(n: int) -> int:\n    if n <= 1: return n\n    dp = [0] * (n + 1)\n    dp[1] = 1\n    for i in range(2, n + 1):\n        dp[i] = dp[i - 1] + dp[i - 2]\n    return dp[n]\n\n# 空間最適化: O(n) 時間、O(1) 空間\ndef fib_opt(n: int) -> int:\n    if n <= 1: return n\n    a, b = 0, 1\n    for _ in range(2, n + 1):\n        a, b = b, a + b\n    return b\n\nassert fib_opt(50) == 12586269025", "runnable": false}', 3),

('10000000-0000-0000-0000-000000000010', 'markdown', '{"text": "## 例題2: 0-1ナップサック問題\n\n重さの制限 W のナップサックに n 個のアイテム（重さ wᵢ、価値 vᵢ）を入れ、価値を最大化する。\n\n### 状態定義\n\n`dp[i][w]` = アイテム 1..i を考慮し、容量 w のときの最大価値\n\n### 遷移式\n\n`dp[i][w] = max(dp[i-1][w], dp[i-1][w - wᵢ] + vᵢ)`（wᵢ ≤ w の場合）\n\n左の項: アイテム i を入れない。右の項: アイテム i を入れる。\n\n### 計算量\n\n時間: O(nW)、空間: O(nW) → O(W) に最適化可能（1次元DP、逆順ループ）\n\n注意: W が非常に大きい場合、この計算量は**疑似多項式時間**と呼ばれます（入力サイズの多項式ではなく、入力値の多項式）。ナップサック問題はNP困難です。"}', 4),

('10000000-0000-0000-0000-000000000010', 'code', '{"language": "python", "code": "def knapsack(weights: list[int], values: list[int], capacity: int) -> int:\n    \"\"\"0-1ナップサック: 空間最適化版 O(nW) 時間、O(W) 空間\"\"\"\n    dp = [0] * (capacity + 1)\n    \n    for w, v in zip(weights, values):\n        # 逆順にループすることで、各アイテムが1回だけ使われることを保証\n        for c in range(capacity, w - 1, -1):\n            dp[c] = max(dp[c], dp[c - w] + v)\n    \n    return dp[capacity]\n\nassert knapsack([2, 3, 4, 5], [3, 4, 5, 6], 8) == 10", "runnable": false}', 5),

('10000000-0000-0000-0000-000000000010', 'markdown', '{"text": "## DP問題の解法フレームワーク\n\n1. **状態を定義する**: 何をインデックスとし、何を値とするか\n2. **遷移式を立てる**: 状態間の関係を数式で表現\n3. **基底条件を定める**: 再帰の終了条件\n4. **計算順序を決める**: 依存関係に従った順序でテーブルを埋める\n5. **空間を最適化する**: 必要な過去の状態だけを保持\n\n## 代表的なDP問題\n\n| 問題 | 状態 | 計算量 |\n|---|---|---|\n| 最長共通部分列（LCS） | dp[i][j] = X[0..i], Y[0..j] の LCS 長 | O(nm) |\n| 編集距離（Levenshtein） | dp[i][j] = X[0..i] → Y[0..j] の最小操作数 | O(nm) |\n| コイン問題 | dp[i] = 金額 i を作る最小コイン数 | O(nS) |\n| 最長増加部分列（LIS） | 二分探索併用 | O(n log n) |\n| 区間DP（行列連鎖乗算） | dp[i][j] = A_i...A_j の最小乗算回数 | O(n³) |"}', 6),

('10000000-0000-0000-0000-000000000010', 'callout', '{"type": "tip", "text": "DP問題で詰まったら: (1) 小さな例を手で解く、(2) 再帰的な関係を見つける、(3) 状態の次元を増やしてみる。「何を覚えておけば最適な判断ができるか」がDP状態設計の指針です。"}', 7);

-- ============================================================
-- Hash Table: 中級 (difficulty_level=2)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000012', 'c0000000-0000-0000-0000-000000000007', 'hash-table-basics',
  'ハッシュテーブル', 'ハッシュ関数の設計、衝突解決、償却計算量、リハッシュ。', 2, 25, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000012', 'markdown', '{"text": "# ハッシュテーブル\n\nハッシュテーブルはキーと値のペアを格納し、**平均 O(1)** で検索・挿入・削除を実現するデータ構造です。\n\n内部的には配列（バケット配列）とハッシュ関数で構成されます。ハッシュ関数がキーを配列のインデックスに変換し、直接アクセスを可能にします。"}', 0),

('10000000-0000-0000-0000-000000000012', 'markdown', '{"text": "## ハッシュ関数の要件\n\n良いハッシュ関数は以下を満たします:\n\n1. **決定的**: 同じキーは常に同じハッシュ値\n2. **均一分布**: ハッシュ値がバケット全体に均等に分散\n3. **高速**: O(1) で計算可能\n\n### 整数のハッシュ\n\n除算法: `h(k) = k mod m`。m は素数が望ましい（2のべき乗だとビットパターンに偏る）。\n\n乗算法: `h(k) = ⌊m × (k × A mod 1)⌋`（A ≈ 0.6180339887 = (√5-1)/2）。m の選択に依存しない。\n\n### 文字列のハッシュ\n\n多項式ハッシュ: `h(s) = (s[0]×pⁿ⁻¹ + s[1]×pⁿ⁻² + ... + s[n-1]) mod m`\n\nPython の `hash()` や Java の `hashCode()` はこの変種を使用。"}', 1),

('10000000-0000-0000-0000-000000000012', 'markdown', '{"text": "## 衝突解決\n\n### チェイニング法（Separate Chaining）\n\n各バケットを連結リスト（または平衡BST）にして衝突要素を格納。\n\n- 負荷率 α = n/m（要素数/バケット数）\n- 検索の期待計算量: O(1 + α)\n- Java 8+ の HashMap: α > 8 で連結リストを赤黒木に変換（最悪 O(log n)）\n\n### オープンアドレス法（Open Addressing）\n\n衝突時に**探査列**に従って空きスロットを探す。\n\n| 手法 | 探査列 | 問題点 |\n|---|---|---|\n| 線形探査 | h(k)+1, h(k)+2, ... | 一次クラスタリング |\n| 二次探査 | h(k)+1², h(k)+2², ... | 二次クラスタリング |\n| ダブルハッシュ | h₁(k)+i×h₂(k) | クラスタリング回避 |\n\nPython の `dict` はオープンアドレス法（ランダム探査の変種）を使用。"}', 2),

('10000000-0000-0000-0000-000000000012', 'code', '{"language": "python", "code": "class HashMap:\n    \"\"\"チェイニング法によるハッシュテーブル実装\"\"\"\n    \n    def __init__(self, capacity: int = 16, load_factor: float = 0.75):\n        self._capacity = capacity\n        self._load_factor = load_factor\n        self._size = 0\n        self._buckets: list[list[tuple]] = [[] for _ in range(capacity)]\n    \n    def _hash(self, key) -> int:\n        return hash(key) % self._capacity\n    \n    def put(self, key, value) -> None:\n        if self._size / self._capacity >= self._load_factor:\n            self._resize()  # リハッシュ\n        \n        idx = self._hash(key)\n        for i, (k, v) in enumerate(self._buckets[idx]):\n            if k == key:\n                self._buckets[idx][i] = (key, value)  # 上書き\n                return\n        self._buckets[idx].append((key, value))\n        self._size += 1\n    \n    def get(self, key):\n        idx = self._hash(key)\n        for k, v in self._buckets[idx]:\n            if k == key:\n                return v\n        raise KeyError(key)\n    \n    def _resize(self) -> None:\n        \"\"\"容量を2倍にしてリハッシュ: O(n) 償却 O(1)\"\"\"\n        old_buckets = self._buckets\n        self._capacity *= 2\n        self._buckets = [[] for _ in range(self._capacity)]\n        self._size = 0\n        for bucket in old_buckets:\n            for key, value in bucket:\n                self.put(key, value)", "runnable": false}', 3),

('10000000-0000-0000-0000-000000000012', 'markdown', '{"text": "## 償却計算量とリハッシュ\n\nリハッシュは O(n) かかりますが、発生頻度が低い（n が倍になるごとに1回）ため、挿入の**償却計算量は O(1)** です。\n\n動的配列の拡張と同じ議論: n 回の挿入の合計コストは O(n + n/2 + n/4 + ...) = O(2n) = O(n)。1回あたり O(1)。\n\n## まとめ\n\n| 操作 | 平均 | 最悪 |\n|---|---|---|\n| 検索 | O(1) | O(n) |\n| 挿入 | O(1) 償却 | O(n) |\n| 削除 | O(1) | O(n) |\n\n**学習のポイント**: ハッシュ関数の均一性が性能を決める。衝突解決の2大手法の特性。負荷率の管理とリハッシュの償却分析。実装言語ごとの内部実装の違い。"}', 4);

-- ============================================================
-- Heap: 中級 (difficulty_level=2)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000013', 'c0000000-0000-0000-0000-000000000008', 'heap-basics',
  'ヒープと優先度付きキュー', '完全二分木の配列表現。heapify、ヒープソート、Top-K問題。', 2, 25, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000013', 'markdown', '{"text": "# ヒープと優先度付きキュー\n\n**ヒープ**は以下のヒープ条件を満たす完全二分木です:\n\n- **最小ヒープ**: 任意のノード x について、x.val ≤ x.children.val\n- **最大ヒープ**: 任意のノード x について、x.val ≥ x.children.val\n\nヒープは**優先度付きキュー**（最小/最大値の取得と削除が高速なデータ構造）の標準的な実装です。\n\n### 配列による表現\n\n完全二分木は配列で効率的に表現できます（インデックス0始まり）:\n\n- 親: `(i - 1) // 2`\n- 左の子: `2i + 1`\n- 右の子: `2i + 2`\n\nポインタが不要でキャッシュ効率が良い。"}', 0),

('10000000-0000-0000-0000-000000000013', 'markdown', '{"text": "## 基本操作\n\n### push（挿入）: O(log n)\n\n1. 配列の末尾に要素を追加\n2. **sift-up（上方修正）**: 親と比較し、ヒープ条件を満たすまで交換\n\n### pop（最小/最大値の削除）: O(log n)\n\n1. ルート（最小/最大値）を取り出す\n2. 末尾の要素をルートに移動\n3. **sift-down（下方修正）**: 子と比較し、ヒープ条件を満たすまで交換\n\n### heapify（配列のヒープ化）: O(n)\n\n全要素を一つずつ挿入すると O(n log n) だが、ボトムアップに sift-down を適用すると **O(n)**。\n\n証明: 高さ h のノードは最大 ⌈n/2^(h+1)⌉ 個。各ノードの sift-down コストは O(h)。\n\n$$\\sum_{h=0}^{\\log n} \\lceil n/2^{h+1} \\rceil \\cdot O(h) = O\\left(n \\sum_{h=0}^{\\infty} h/2^h\\right) = O(n)$$"}', 1),

('10000000-0000-0000-0000-000000000013', 'code', '{"language": "python", "code": "import heapq\n\n# Python の heapq は最小ヒープ\nnums = [5, 3, 8, 1, 9, 2, 7]\nheapq.heapify(nums)             # O(n) でヒープ化\n\nheapq.heappush(nums, 0)          # O(log n)\nprint(heapq.heappop(nums))       # 0 (最小値) O(log n)\nprint(heapq.heappop(nums))       # 1\n\n# 最大ヒープが必要な場合: 値を反転\nmax_heap = []\nfor x in [5, 3, 8, 1, 9]:\n    heapq.heappush(max_heap, -x)\nprint(-heapq.heappop(max_heap))  # 9 (最大値)\n\n# Top-K: 配列から上位K個を O(n log k) で取得\ndef top_k(arr: list[int], k: int) -> list[int]:\n    \"\"\"最小ヒープをサイズkに維持: O(n log k)\"\"\"\n    heap = []\n    for x in arr:\n        heapq.heappush(heap, x)\n        if len(heap) > k:\n            heapq.heappop(heap)  # 最小を捨てる\n    return sorted(heap, reverse=True)\n\nassert top_k([3, 1, 4, 1, 5, 9, 2, 6, 5], 3) == [9, 6, 5]", "runnable": false}', 2),

('10000000-0000-0000-0000-000000000013', 'markdown', '{"text": "## ヒープソート\n\nヒープを利用した O(n log n) のインプレースソート:\n\n1. 配列を最大ヒープに変換: O(n)\n2. ルート（最大値）を末尾と交換し、ヒープサイズを1減らして sift-down: O(log n) × n回\n\n合計: **O(n log n)**、空間: **O(1)**（インプレース）。\n\n不安定ソートだが、最悪でも O(n log n) を保証（クイックソートの O(n²) 最悪ケースがない）。\n\n## 計算量まとめ\n\n| 操作 | 計算量 |\n|---|---|\n| 最小/最大値の参照 | O(1) |\n| 挿入（push） | O(log n) |\n| 削除（pop） | O(log n) |\n| heapify | O(n) |\n| Top-K | O(n log k) |\n\n**学習のポイント**: 完全二分木の配列表現の効率性、sift-up/sift-down の正当性、heapify の O(n) の証明（非自明）、Top-K問題でのヒープサイズ制限テクニック。"}', 3);

-- ============================================================
-- Dijkstra: 上級 (difficulty_level=3)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000014', 'c0000000-0000-0000-0000-000000000004', 'dijkstra',
  'ダイクストラ法', '非負重みグラフの最短経路。貪欲法の正当性証明、ヒープ最適化、実装の注意点。', 3, 25, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000014', 'markdown', '{"text": "# ダイクストラ法（Dijkstra''s Algorithm）\n\nEdsger W. Dijkstra が1956年に考案。**非負の辺重み**を持つグラフにおいて、単一始点から全頂点への最短経路を求める貪欲法アルゴリズムです。\n\n## アルゴリズム\n\n1. 始点 s の距離を 0、他の全頂点の距離を ∞ に初期化\n2. 未確定頂点のうち最小距離の頂点 u を選択（貪欲選択）\n3. u を確定し、u の全隣接頂点 v に対して**緩和（relaxation）**を試みる:\n   - `if dist[u] + w(u,v) < dist[v]: dist[v] = dist[u] + w(u,v)`\n4. 全頂点が確定するまで繰り返す"}', 0),

('10000000-0000-0000-0000-000000000014', 'markdown', '{"text": "## 正当性の証明（概略）\n\n**主張**: ダイクストラ法が頂点 u を確定したとき、dist[u] は s から u への最短距離である。\n\n**帰納法による証明**:\n\n- 基底: dist[s] = 0 は明らかに最短。\n- 帰納段階: k 番目に確定される頂点 u について、dist[u] が最短でないと仮定する。すると s から u への真の最短経路上に、まだ未確定の頂点 x が存在する。しかし、辺の重みが非負であるため dist[x] ≥ dist[u]（u が最小距離で選ばれたから）。よって s→...→x→...→u の経路長 ≥ dist[x] ≥ dist[u] となり、dist[u] が最短でないという仮定に矛盾。\n\n**重要**: この証明は**辺の重みが非負**であることに依存します。負の重みがあると、未確定頂点を経由することで距離が減少する可能性があり、貪欲選択が成立しません。"}', 1),

('10000000-0000-0000-0000-000000000014', 'code', '{"language": "python", "code": "import heapq\n\ndef dijkstra(graph: dict[str, list[tuple[str, int]]], start: str) -> dict[str, int]:\n    \"\"\"\n    ダイクストラ法: O((V + E) log V) — 二分ヒープ使用\n    graph: {node: [(neighbor, weight), ...]}\n    \"\"\"\n    dist = {node: float(\"inf\") for node in graph}\n    dist[start] = 0\n    pq = [(0, start)]  # (距離, ノード) の最小ヒープ\n    \n    while pq:\n        d, u = heapq.heappop(pq)\n        \n        # 古いエントリをスキップ（lazy deletion）\n        if d > dist[u]:\n            continue\n        \n        for v, weight in graph[u]:\n            new_dist = dist[u] + weight\n            if new_dist < dist[v]:  # 緩和\n                dist[v] = new_dist\n                heapq.heappush(pq, (new_dist, v))\n    \n    return dist\n\n# 経路復元版\ndef dijkstra_with_path(graph, start, goal):\n    dist = {node: float(\"inf\") for node in graph}\n    dist[start] = 0\n    parent = {start: None}\n    pq = [(0, start)]\n    \n    while pq:\n        d, u = heapq.heappop(pq)\n        if d > dist[u]: continue\n        if u == goal: break\n        for v, w in graph[u]:\n            nd = dist[u] + w\n            if nd < dist[v]:\n                dist[v] = nd\n                parent[v] = u\n                heapq.heappush(pq, (nd, v))\n    \n    # 経路を復元\n    path, node = [], goal\n    while node is not None:\n        path.append(node)\n        node = parent.get(node)\n    return dist[goal], path[::-1]", "runnable": false}', 2),

('10000000-0000-0000-0000-000000000014', 'markdown', '{"text": "## 計算量\n\n| 実装 | 頂点選択 | 緩和 | 合計 |\n|---|---|---|---|\n| 線形探索 | O(V) × V回 | O(E) | **O(V² + E)** |\n| 二分ヒープ | O(log V) × V回 | O(log V) × E回 | **O((V+E) log V)** |\n| フィボナッチヒープ | O(log V) × V回 | O(1)償却 × E回 | **O(V log V + E)** |\n\n密グラフ（E ≈ V²）では線形探索版が効率的。疎グラフ（E ≈ V）では二分ヒープ版が最適。フィボナッチヒープは理論的に最速だが定数が大きく、実用上は二分ヒープが使われます。\n\n## 最短経路アルゴリズムの使い分け\n\n| アルゴリズム | 負の辺 | 計算量 | 用途 |\n|---|---|---|---|\n| BFS | 重みなし | O(V+E) | 重みなし最短経路 |\n| ダイクストラ | 非負のみ | O((V+E) log V) | 非負重み最短経路 |\n| Bellman-Ford | 対応 | O(VE) | 負の辺あり、負閉路検出 |\n| Floyd-Warshall | 対応 | O(V³) | 全点間最短経路 |\n| A* | 非負+ヒューリスティック | O((V+E) log V) | 目標指向探索（ナビ等） |\n\n**学習のポイント**: 貪欲法の正当性が非負重みに依存する理由、lazy deletion によるヒープ操作の簡略化、経路復元のための parent 配列、問題に応じたアルゴリズムの使い分け。"}', 3);
