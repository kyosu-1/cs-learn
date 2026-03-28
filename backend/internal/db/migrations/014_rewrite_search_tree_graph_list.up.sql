-- Delete old lessons: binary search, binary tree, graph BFS/DFS, linked list
DELETE FROM lesson_blocks WHERE lesson_id IN (
  '10000000-0000-0000-0000-000000000004',
  '10000000-0000-0000-0000-000000000005',
  '10000000-0000-0000-0000-000000000006',
  '10000000-0000-0000-0000-000000000007'
);
DELETE FROM lessons WHERE id IN (
  '10000000-0000-0000-0000-000000000004',
  '10000000-0000-0000-0000-000000000005',
  '10000000-0000-0000-0000-000000000006',
  '10000000-0000-0000-0000-000000000007'
);

-- ============================================================
-- Binary Search: 初級→中級 (difficulty_level=2)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000004', 'c0000000-0000-0000-0000-000000000002', 'binary-search',
  '二分探索', 'ソート済み配列上の対数時間探索。ループ不変条件、off-by-oneエラーの回避、応用パターン。', 2, 25, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000004', 'markdown', '{"text": "# 二分探索（Binary Search）\n\n二分探索は**ソート済み配列**に対して、探索範囲を毎回半分に絞ることで O(log n) の計算量を実現するアルゴリズムです。\n\n一見シンプルですが、正しく実装することは意外に難しく、Jon Bentley は「プロのプログラマでも正しい二分探索を書ける人は10%しかいない」と述べています。off-by-one エラーを防ぐには、**ループ不変条件**を明確にすることが不可欠です。"}', 0),

('10000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## アルゴリズムと正当性\n\n### ループ不変条件\n\n「目的の値が配列中に存在するならば、A[lo..hi] の範囲内にある」\n\n- **初期条件**: lo=0, hi=n-1 で全範囲を含む。成立。\n- **維持**: A[mid] と目的値を比較し、A[mid] < target なら lo=mid+1（左半分には存在しない）、A[mid] > target なら hi=mid-1（右半分には存在しない）。不変条件は維持される。\n- **終了**: lo > hi になったとき、探索範囲が空。目的値は存在しない。\n\n### 計算量\n\n各反復で探索範囲が半分になるため、最大反復回数は $\\lfloor\\log_2 n\\rfloor + 1$ 回。\n\n$$T(n) = T(n/2) + O(1) = O(\\log n)$$"}', 1),

('10000000-0000-0000-0000-000000000004', 'code', '{"language": "python", "code": "def binary_search(arr: list[int], target: int) -> int:\n    \"\"\"target のインデックスを返す。存在しなければ -1。\"\"\"\n    lo, hi = 0, len(arr) - 1\n    \n    # 不変条件: target が存在するなら arr[lo..hi] 内にある\n    while lo <= hi:\n        mid = lo + (hi - lo) // 2  # オーバーフロー防止\n        if arr[mid] == target:\n            return mid\n        elif arr[mid] < target:\n            lo = mid + 1\n        else:\n            hi = mid - 1\n    \n    return -1\n\n# 注意: mid = (lo + hi) // 2 は lo+hi が整数の上限を超える可能性がある\n# C/C++/Java では lo + (hi - lo) / 2 を使うべき（Python は多倍長整数なので問題ない）", "runnable": false}', 2),

('10000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## 応用: lower_bound と upper_bound\n\n二分探索の真の威力は「値の検索」よりも「条件を満たす境界の発見」にあります。\n\n- **lower_bound(x)**: x 以上の最初の位置（C++ STL の `lower_bound`）\n- **upper_bound(x)**: x より大きい最初の位置\n\nこれらは「述語（predicate）に基づく二分探索」の特殊ケースです。"}', 3),

('10000000-0000-0000-0000-000000000004', 'code', '{"language": "python", "code": "def lower_bound(arr: list[int], target: int) -> int:\n    \"\"\"target 以上の最初のインデックスを返す（挿入位置）\"\"\"\n    lo, hi = 0, len(arr)\n    # 不変条件: arr[0..lo-1] < target <= arr[hi..n-1]\n    while lo < hi:\n        mid = lo + (hi - lo) // 2\n        if arr[mid] < target:\n            lo = mid + 1\n        else:\n            hi = mid\n    return lo\n\ndef upper_bound(arr: list[int], target: int) -> int:\n    \"\"\"target より大きい最初のインデックスを返す\"\"\"\n    lo, hi = 0, len(arr)\n    while lo < hi:\n        mid = lo + (hi - lo) // 2\n        if arr[mid] <= target:\n            lo = mid + 1\n        else:\n            hi = mid\n    return lo\n\n# target の出現回数 = upper_bound - lower_bound\narr = [1, 2, 2, 2, 3, 4, 5]\nassert lower_bound(arr, 2) == 1\nassert upper_bound(arr, 2) == 4\nassert upper_bound(arr, 2) - lower_bound(arr, 2) == 3  # 2は3回出現", "runnable": false}', 4),

('10000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## 応用: 答えの二分探索\n\n「条件 f(x) を満たす最小の x を求めよ」という最適化問題で、f(x) が単調（ある x₀ 以上で常に true）なら、答えの空間に対して二分探索を適用できます。\n\n例:\n- 「N日以内に全荷物を運べる最小のトラック積載量は？」\n- 「K個以下に分割できる最大の部分和の最小値は？」\n\nこのパターンは競技プログラミングで頻出し、実務でも負荷分散やスケジューリングの最適化に応用されます。"}', 5),

('10000000-0000-0000-0000-000000000004', 'callout', '{"type": "warning", "text": "二分探索のよくあるバグ: (1) lo <= hi vs lo < hi の混同、(2) mid の計算でのオーバーフロー、(3) lo/hi の更新で mid±1 を忘れて無限ループ。ループ不変条件を書き出してから実装しましょう。"}', 6),

('10000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## まとめ\n\n| 特性 | 値 |\n|---|---|\n| 計算量 | O(log n) |\n| 空間計算量 | O(1)（反復版）、O(log n)（再帰版） |\n| 前提条件 | 配列がソート済み |\n| 比較回数 | 最大 ⌊log₂n⌋ + 1 回 |\n\n**学習のポイント**: ループ不変条件の設定と維持が正しい実装の鍵。lower_bound/upper_bound の汎用パターン。答えの二分探索による最適化問題への応用。"}', 7);

-- ============================================================
-- Binary Tree: 初級→中級 (difficulty_level=2)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000005', 'c0000000-0000-0000-0000-000000000003', 'binary-tree-basics',
  '二分木と二分探索木', '木構造の基本、走査アルゴリズム、BSTの操作と計算量。', 2, 30, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000005', 'markdown', '{"text": "# 二分木と二分探索木\n\n## 二分木（Binary Tree）\n\n二分木は各ノードが**最大2つの子**（左の子、右の子）を持つ木構造です。配列やリストが「線形」なデータ構造であるのに対し、木は「階層的」な構造を表現します。\n\n### 用語\n\n- **ルート**: 木の最上位ノード（親を持たない唯一のノード）\n- **葉（リーフ）**: 子を持たないノード\n- **深さ（depth）**: ルートからそのノードまでの辺の数\n- **高さ（height）**: ノードから葉までの最長経路の辺の数。木の高さ = ルートの高さ\n- **完全二分木**: すべての葉が同じ深さにある二分木。ノード数 n のとき高さ = ⌊log₂n⌋\n\n### 性質\n\n- 高さ h の二分木のノード数: 最小 h+1（退化木）、最大 2^(h+1)-1（完全二分木）\n- n ノードの二分木の高さ: 最小 ⌊log₂n⌋、最大 n-1"}', 0),

('10000000-0000-0000-0000-000000000005', 'markdown', '{"text": "## 走査アルゴリズム\n\n### 深さ優先走査（DFS）\n\n| 走査方法 | 順序 | 用途 |\n|---|---|---|\n| 前順（Preorder） | **根** → 左 → 右 | 木のシリアライズ（復元可能な表現）|\n| 中順（Inorder） | 左 → **根** → 右 | BSTでソート順の列挙 |\n| 後順（Postorder） | 左 → 右 → **根** | 部分木のメモリ解放、式の評価 |\n\n### 幅優先走査（BFS / Level-order）\n\nキューを使い、レベル（深さ）順にノードを訪問。最短経路問題やレベル単位の集計に使用。\n\n### 計算量\n\nすべての走査は各ノードを1回ずつ訪問するため **O(n)**。空間計算量はDFSが O(h)（再帰スタック）、BFSが O(w)（最大幅）。"}', 1),

('10000000-0000-0000-0000-000000000005', 'code', '{"language": "python", "code": "from collections import deque\nfrom typing import Optional\n\nclass TreeNode:\n    def __init__(self, val: int, left: Optional[\"TreeNode\"] = None, right: Optional[\"TreeNode\"] = None):\n        self.val = val\n        self.left = left\n        self.right = right\n\ndef inorder(node: Optional[TreeNode]) -> list[int]:\n    \"\"\"中順走査: 左→根→右。BSTではソート順を出力。\"\"\"\n    if node is None:\n        return []\n    return inorder(node.left) + [node.val] + inorder(node.right)\n\ndef preorder(node: Optional[TreeNode]) -> list[int]:\n    \"\"\"前順走査: 根→左→右\"\"\"\n    if node is None:\n        return []\n    return [node.val] + preorder(node.left) + preorder(node.right)\n\ndef level_order(root: Optional[TreeNode]) -> list[list[int]]:\n    \"\"\"レベル順走査（BFS）: レベルごとにグループ化\"\"\"\n    if root is None:\n        return []\n    result, queue = [], deque([root])\n    while queue:\n        level = []\n        for _ in range(len(queue)):  # 現在のレベルの全ノードを処理\n            node = queue.popleft()\n            level.append(node.val)\n            if node.left:  queue.append(node.left)\n            if node.right: queue.append(node.right)\n        result.append(level)\n    return result", "runnable": false}', 2),

('10000000-0000-0000-0000-000000000005', 'markdown', '{"text": "## 二分探索木（BST: Binary Search Tree）\n\nBSTは以下の**BST条件**を満たす二分木です:\n\n> 任意のノード x について、左部分木のすべてのノードの値 < x.val < 右部分木のすべてのノードの値\n\nこの条件により、中順走査がソート順を出力します。\n\n### BST操作の計算量\n\n| 操作 | 平均 | 最悪（退化木） |\n|---|---|---|\n| 検索 | O(log n) | O(n) |\n| 挿入 | O(log n) | O(n) |\n| 削除 | O(log n) | O(n) |\n| 最小/最大値 | O(log n) | O(n) |\n\n最悪ケースはソート済みデータを順に挿入した場合で、木が連結リストに退化します（高さ = n-1）。\n\nこの問題を解決するのが**平衡二分探索木**（AVL木、赤黒木）で、高さを O(log n) に保証します。"}', 3),

('10000000-0000-0000-0000-000000000005', 'code', '{"language": "python", "code": "def bst_search(root: Optional[TreeNode], target: int) -> Optional[TreeNode]:\n    \"\"\"BST上の検索: O(h)\"\"\"\n    if root is None or root.val == target:\n        return root\n    if target < root.val:\n        return bst_search(root.left, target)\n    return bst_search(root.right, target)\n\ndef bst_insert(root: Optional[TreeNode], val: int) -> TreeNode:\n    \"\"\"BST への挿入: O(h)。新しいルートを返す。\"\"\"\n    if root is None:\n        return TreeNode(val)\n    if val < root.val:\n        root.left = bst_insert(root.left, val)\n    elif val > root.val:\n        root.right = bst_insert(root.right, val)\n    return root\n\ndef bst_delete(root: Optional[TreeNode], val: int) -> Optional[TreeNode]:\n    \"\"\"BST からの削除: O(h)。3つのケースを処理。\"\"\"\n    if root is None:\n        return None\n    if val < root.val:\n        root.left = bst_delete(root.left, val)\n    elif val > root.val:\n        root.right = bst_delete(root.right, val)\n    else:\n        # ケース1,2: 子が0個または1個\n        if root.left is None:  return root.right\n        if root.right is None: return root.left\n        # ケース3: 子が2個 → 右部分木の最小値（中順後続）で置換\n        successor = root.right\n        while successor.left:\n            successor = successor.left\n        root.val = successor.val\n        root.right = bst_delete(root.right, successor.val)\n    return root", "runnable": false}', 4),

('10000000-0000-0000-0000-000000000005', 'callout', '{"type": "info", "text": "実務では生のBSTを使うことは少なく、言語標準ライブラリの平衡BST（C++ std::map = 赤黒木、Java TreeMap = 赤黒木）を利用します。BSTの理解はこれらの内部動作を理解する基盤となります。"}', 5),

('10000000-0000-0000-0000-000000000005', 'markdown', '{"text": "## まとめ\n\n| 特性 | 値 |\n|---|---|\n| 走査の計算量 | O(n)（全走査方法共通） |\n| BST検索/挿入/削除 | 平均 O(log n)、最悪 O(n) |\n| 平衡BST（AVL/赤黒木） | 全操作 O(log n) 保証 |\n\n**学習のポイント**: 走査の再帰構造（部分木に対する帰納的処理）、BST条件と中順走査の関係、削除の3ケース（子0個/1個/2個）、退化と平衡化の必要性。"}', 6);

-- ============================================================
-- Graph BFS/DFS: 中級 (difficulty_level=2)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000006', 'c0000000-0000-0000-0000-000000000004', 'graph-bfs-dfs',
  'グラフ探索: BFS と DFS', 'グラフの表現方法、BFS/DFSの正当性と計算量、応用問題。', 2, 30, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000006', 'markdown', '{"text": "# グラフ探索: BFS と DFS\n\n## グラフの基礎\n\nグラフ G = (V, E) は頂点集合 V と辺集合 E からなるデータ構造です。\n\n### グラフの表現\n\n| 表現 | 空間 | 辺の存在判定 | 隣接頂点の列挙 | 適する場面 |\n|---|---|---|---|---|\n| 隣接行列 | O(V²) | O(1) | O(V) | 密グラフ、辺の存在判定が頻繁 |\n| 隣接リスト | O(V+E) | O(degree) | O(degree) | 疎グラフ（実用上ほとんどこちら） |\n\n実世界のグラフの多くは疎（E << V²）であるため、隣接リストが標準的です。"}', 0),

('10000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## BFS（幅優先探索）\n\n**キュー**を使い、始点から近い順に全頂点を訪問します。\n\n### 性質\n\n- BFS で発見された各頂点への経路は、**辺数が最小の経路（最短経路）**である\n- 計算量: **O(V + E)**（各頂点と各辺を1回ずつ処理）\n\n### 正当性（最短経路の証明スケッチ）\n\nBFS は距離 0, 1, 2, ... の頂点を順に発見する。距離 d の頂点をすべて発見してから距離 d+1 の頂点を発見する（キューのFIFO性質による）。したがって、各頂点は最短距離で最初に発見される。"}', 1),

('10000000-0000-0000-0000-000000000006', 'code', '{"language": "python", "code": "from collections import deque\n\ndef bfs(graph: dict[str, list[str]], start: str) -> dict[str, int]:\n    \"\"\"BFS: 始点から各頂点への最短距離（辺数）を返す\"\"\"\n    dist = {start: 0}\n    queue = deque([start])\n    \n    while queue:\n        u = queue.popleft()\n        for v in graph[u]:\n            if v not in dist:       # 未訪問\n                dist[v] = dist[u] + 1\n                queue.append(v)\n    \n    return dist\n\n# 最短経路の復元にはparent辞書を併用\ndef bfs_with_path(graph, start, goal):\n    parent = {start: None}\n    queue = deque([start])\n    while queue:\n        u = queue.popleft()\n        if u == goal:\n            # 経路を復元\n            path = []\n            while u is not None:\n                path.append(u)\n                u = parent[u]\n            return path[::-1]\n        for v in graph[u]:\n            if v not in parent:\n                parent[v] = u\n                queue.append(v)\n    return None  # 到達不能", "runnable": false}', 2),

('10000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## DFS（深さ優先探索）\n\n**スタック**（または再帰）を使い、一方向に可能な限り深く進んでからバックトラックします。\n\n### 性質\n\n- 計算量: **O(V + E)**\n- 最短経路は保証しない\n- **発見時刻と完了時刻**を記録すると、辺の分類（木辺、後退辺、前進辺、交差辺）が可能\n\n### DFS の応用\n\n| 応用 | 説明 |\n|---|---|\n| 連結成分 | 無向グラフの連結成分の数え上げ |\n| 閉路検出 | 後退辺の存在 = 閉路の存在 |\n| トポロジカルソート | DAGの頂点を依存関係順に並べる（完了時刻の降順） |\n| 強連結成分 | 有向グラフの SCC 分解（Tarjan, Kosaraju） |"}', 3),

('10000000-0000-0000-0000-000000000006', 'code', '{"language": "python", "code": "def dfs_iterative(graph: dict[str, list[str]], start: str) -> list[str]:\n    \"\"\"反復的DFS（明示的スタック）\"\"\"\n    visited = set()\n    stack = [start]\n    order = []\n    \n    while stack:\n        u = stack.pop()\n        if u in visited:\n            continue\n        visited.add(u)\n        order.append(u)\n        # 逆順にpushすると辞書順で訪問（オプション）\n        for v in reversed(graph[u]):\n            if v not in visited:\n                stack.append(v)\n    \n    return order\n\ndef topological_sort(graph: dict[str, list[str]]) -> list[str]:\n    \"\"\"DFS ベースのトポロジカルソート（DAG前提）\"\"\"\n    visited = set()\n    order = []\n    \n    def dfs(u: str):\n        visited.add(u)\n        for v in graph[u]:\n            if v not in visited:\n                dfs(v)\n        order.append(u)  # 完了時にスタックに積む\n    \n    for u in graph:\n        if u not in visited:\n            dfs(u)\n    \n    return order[::-1]  # 完了時刻の降順 = トポロジカル順", "runnable": false}', 4),

('10000000-0000-0000-0000-000000000006', 'callout', '{"type": "info", "text": "BFS は「最短距離」が必要な問題に、DFS は「到達可能性」「閉路検出」「トポロジカルソート」に使います。迷ったら問題の性質を確認: 最短経路が必要か？全探索が必要か？"}', 5),

('10000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## まとめ\n\n| | BFS | DFS |\n|---|---|---|\n| データ構造 | キュー（FIFO） | スタック/再帰（LIFO） |\n| 計算量 | O(V + E) | O(V + E) |\n| 最短経路 | 保証（重みなし） | 保証しない |\n| 空間 | O(V)（キューの最大幅） | O(V)（再帰の最大深さ） |\n| 主な応用 | 最短経路、レベル探索 | 閉路検出、トポロジカルソート、SCC |\n\n**学習のポイント**: グラフの表現方法の選択基準、BFS の最短経路保証の根拠、DFS の時刻記録と辺分類、トポロジカルソートの正当性。"}', 6);

-- ============================================================
-- Linked List: 初級 (difficulty_level=1)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000007', 'c0000000-0000-0000-0000-000000000005', 'linked-list-basics',
  '連結リスト', 'ポインタ操作の基礎。配列との比較、各操作の計算量、実用上の位置づけ。', 1, 20, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000007', 'markdown', '{"text": "# 連結リスト（Linked List）\n\n連結リストは各要素（ノード）が**データ**と**次のノードへのポインタ（参照）**を持つデータ構造です。\n\n配列がメモリ上に連続して配置されるのに対し、連結リストの各ノードはメモリ上の任意の位置に存在し、ポインタで繋がれています。"}', 0),

('10000000-0000-0000-0000-000000000007', 'markdown', '{"text": "## 配列 vs 連結リスト\n\n| 操作 | 配列 | 連結リスト |\n|---|---|---|\n| インデックスアクセス | **O(1)** | O(n) |\n| 先頭への挿入 | O(n)（全要素シフト） | **O(1)** |\n| 末尾への挿入 | O(1)（償却、動的配列） | O(n)（末尾参照なし）/ O(1)（末尾参照あり） |\n| 中間への挿入 | O(n) | **O(1)**（位置が既知の場合） |\n| 削除 | O(n) | **O(1)**（位置が既知の場合） |\n| キャッシュ効率 | **高い**（連続メモリ） | 低い（ポインタ追跡） |\n| メモリオーバーヘッド | なし | ポインタ分（ノードあたり8バイト） |\n\n**重要**: 連結リストの O(1) 挿入/削除は「挿入/削除位置のノードへの参照を既に持っている」場合の計算量です。位置を探すのに O(n) かかる場合、全体は O(n) です。"}', 1),

('10000000-0000-0000-0000-000000000007', 'code', '{"language": "python", "code": "from typing import Optional\n\nclass ListNode:\n    def __init__(self, val: int, next: Optional[\"ListNode\"] = None):\n        self.val = val\n        self.next = next\n    \n    def __repr__(self):\n        vals = []\n        node = self\n        while node:\n            vals.append(str(node.val))\n            node = node.next\n        return \" -> \".join(vals)\n\nclass SinglyLinkedList:\n    def __init__(self):\n        # 番兵ノード（sentinel/dummy head）を使うと\n        # 先頭操作の特殊ケースが不要になる\n        self.dummy = ListNode(0)\n        self._size = 0\n    \n    def prepend(self, val: int) -> None:\n        \"\"\"先頭に追加: O(1)\"\"\"\n        node = ListNode(val, self.dummy.next)\n        self.dummy.next = node\n        self._size += 1\n    \n    def delete(self, val: int) -> bool:\n        \"\"\"最初に見つかった val を削除: O(n)\"\"\"\n        prev = self.dummy\n        while prev.next:\n            if prev.next.val == val:\n                prev.next = prev.next.next\n                self._size -= 1\n                return True\n            prev = prev.next\n        return False\n    \n    def reverse(self) -> None:\n        \"\"\"リストの反転: O(n) 時間、O(1) 空間\"\"\"\n        prev, curr = None, self.dummy.next\n        while curr:\n            nxt = curr.next    # 次を保存\n            curr.next = prev   # ポインタを反転\n            prev = curr        # prevを進める\n            curr = nxt         # currを進める\n        self.dummy.next = prev\n    \n    @property\n    def head(self) -> Optional[ListNode]:\n        return self.dummy.next", "runnable": false}', 2),

('10000000-0000-0000-0000-000000000007', 'callout', '{"type": "tip", "text": "番兵ノード（dummy head）パターン: 先頭ノードの特殊処理を排除する定番テクニックです。dummy.next が実際の先頭を指します。挿入・削除で「先頭かどうか」の条件分岐が不要になり、コードが簡潔になります。"}', 3),

('10000000-0000-0000-0000-000000000007', 'markdown', '{"text": "## 連結リストの種類\n\n| 種類 | 構造 | 用途 |\n|---|---|---|\n| 単方向（Singly） | next のみ | スタック、キューの実装 |\n| 双方向（Doubly） | prev + next | LRUキャッシュ、ブラウザの戻る/進む |\n| 循環（Circular） | 末尾が先頭を指す | ラウンドロビン・スケジューリング |\n\n## 実用上の位置づけ\n\n現代のCPUではキャッシュ効率が性能を大きく左右します。連結リストはポインタ追跡によるキャッシュミスが多く、配列ベースの構造（`std::vector`, `ArrayList`）に実測性能で劣ることが多いです。\n\n連結リストが有利な場面:\n- **O(1) の先頭/中間挿入削除が必要**（LRUキャッシュ: HashMap + 双方向連結リスト）\n- **メモリの再配置を避けたい**（リアルタイムシステム）\n- **イテレータの無効化を避けたい**（C++ `std::list`）"}', 4),

('10000000-0000-0000-0000-000000000007', 'markdown', '{"text": "## 典型的な面接/試験問題\n\n| 問題 | テクニック |\n|---|---|\n| リストの反転 | 3ポインタ（prev, curr, next） |\n| 中央ノードの発見 | 速度の異なる2ポインタ（slow/fast） |\n| 閉路の検出 | Floyd の循環検出（tortoise and hare） |\n| 2つのソート済みリストのマージ | 再帰またはダミーヘッド |\n| 末尾からK番目のノード | 2ポインタ（K個先行） |\n\n**学習のポイント**: ポインタ操作の正確さ（1つの代入ミスでリストが破壊される）、番兵ノードによるコードの簡素化、配列との計算量・実測性能の違いの理解。"}', 5);
