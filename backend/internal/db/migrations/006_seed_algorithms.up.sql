-- Topic: Algorithms & Data Structures
INSERT INTO topics (id, slug, title, description, icon_name, sort_order, is_published)
VALUES (
  'a0000000-0000-0000-0000-000000000001',
  'algorithms-data-structures',
  'アルゴリズム & データ構造',
  'ソート、探索、木構造、グラフなど基本的なアルゴリズムとデータ構造を学びます',
  'code',
  1,
  true
);

-- Categories
INSERT INTO categories (id, topic_id, slug, title, description, sort_order) VALUES
('c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'sorting', 'ソートアルゴリズム', 'バブルソート、マージソート、クイックソートなど', 1),
('c0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'searching', '探索アルゴリズム', '線形探索、二分探索、ハッシュ法', 2),
('c0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001', 'trees', '木構造', '二分木、BST、ヒープ、AVL木', 3),
('c0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000001', 'graphs', 'グラフアルゴリズム', 'BFS、DFS、ダイクストラ、最小全域木', 4),
('c0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000001', 'linked-lists', '連結リスト', '単方向、双方向、循環リスト', 5);

-- ===== Lessons: ソートアルゴリズム =====

-- Lesson 1: バブルソート
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('l0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 'bubble-sort',
  'バブルソート', '最も基本的なソートアルゴリズムを理解する', 1, 10, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('l0000000-0000-0000-0000-000000000001', 'markdown', '{"text": "# バブルソート\n\nバブルソート（Bubble Sort）は、隣り合う要素を比較して交換を繰り返すことでデータを整列するアルゴリズムです。\n\n最もシンプルなソートアルゴリズムの一つであり、アルゴリズム学習の出発点として最適です。"}', 0),
('l0000000-0000-0000-0000-000000000001', 'callout', '{"type": "info", "text": "計算量: 最悪 O(n²)、最良 O(n)（すでにソート済みの場合）、空間計算量: O(1)"}', 1),
('l0000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## アルゴリズムの仕組み\n\n1. 配列の先頭から隣り合う2つの要素を比較する\n2. 左の要素が右より大きければ交換する\n3. 配列の末尾まで繰り返す（1パス）\n4. 交換が発生しなくなるまでパスを繰り返す\n\n各パスで最大の要素が「泡（バブル）」のように末尾に浮かんでいくことから、この名前がつきました。"}', 2),
('l0000000-0000-0000-0000-000000000001', 'code', '{"language": "python", "code": "def bubble_sort(arr):\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(0, n - i - 1):\n            if arr[j] > arr[j + 1]:\n                arr[j], arr[j + 1] = arr[j + 1], arr[j]\n                swapped = True\n        if not swapped:\n            break\n    return arr\n\n# 例\nprint(bubble_sort([64, 34, 25, 12, 22, 11, 90]))\n# => [11, 12, 22, 25, 34, 64, 90]", "runnable": false}', 3),
('l0000000-0000-0000-0000-000000000001', 'code', '{"language": "go", "code": "func bubbleSort(arr []int) []int {\n\tn := len(arr)\n\tfor i := 0; i < n; i++ {\n\t\tswapped := false\n\t\tfor j := 0; j < n-i-1; j++ {\n\t\t\tif arr[j] > arr[j+1] {\n\t\t\t\tarr[j], arr[j+1] = arr[j+1], arr[j]\n\t\t\t\tswapped = true\n\t\t\t}\n\t\t}\n\t\tif !swapped {\n\t\t\tbreak\n\t\t}\n\t}\n\treturn arr\n}", "runnable": false}', 4),
('l0000000-0000-0000-0000-000000000001', 'callout', '{"type": "tip", "text": "最適化ポイント: swapped フラグにより、すでにソート済みの配列に対しては O(n) で完了します。"}', 5),
('l0000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## まとめ\n\nバブルソートは理解しやすいが、大規模データには非効率です。実用的にはマージソートやクイックソートが使われます。\n\n**使いどころ:**\n- 教育目的\n- ほぼソート済みの小さなデータ\n- 安定ソートが必要な場合"}', 6);

-- Lesson 2: マージソート
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('l0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000001', 'merge-sort',
  'マージソート', '分割統治法の代表的アルゴリズム', 2, 15, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('l0000000-0000-0000-0000-000000000002', 'markdown', '{"text": "# マージソート\n\nマージソート（Merge Sort）は**分割統治法（Divide and Conquer）**に基づくソートアルゴリズムです。\n\n配列を半分に分割し、それぞれを再帰的にソートしてからマージ（統合）します。"}', 0),
('l0000000-0000-0000-0000-000000000002', 'callout', '{"type": "info", "text": "計算量: すべてのケースで O(n log n)、空間計算量: O(n)"}', 1),
('l0000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## アルゴリズムの手順\n\n1. **分割（Divide）**: 配列を中央で2つに分割\n2. **統治（Conquer）**: 各半分を再帰的にマージソート\n3. **統合（Combine）**: ソート済みの2つの配列をマージ\n\n### マージの仕組み\n\n2つのソート済み配列から、先頭の小さい方を順に取り出して新しい配列に入れます。"}', 2),
('l0000000-0000-0000-0000-000000000002', 'code', '{"language": "python", "code": "def merge_sort(arr):\n    if len(arr) <= 1:\n        return arr\n    \n    mid = len(arr) // 2\n    left = merge_sort(arr[:mid])\n    right = merge_sort(arr[mid:])\n    \n    return merge(left, right)\n\ndef merge(left, right):\n    result = []\n    i = j = 0\n    \n    while i < len(left) and j < len(right):\n        if left[i] <= right[j]:\n            result.append(left[i])\n            i += 1\n        else:\n            result.append(right[j])\n            j += 1\n    \n    result.extend(left[i:])\n    result.extend(right[j:])\n    return result\n\nprint(merge_sort([38, 27, 43, 3, 9, 82, 10]))\n# => [3, 9, 10, 27, 38, 43, 82]", "runnable": false}', 3),
('l0000000-0000-0000-0000-000000000002', 'callout', '{"type": "warning", "text": "マージソートは追加のメモリ O(n) を必要とします。メモリ制約が厳しい場合はインプレースのソート（クイックソートなど）を検討しましょう。"}', 4),
('l0000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## バブルソートとの比較\n\n| | バブルソート | マージソート |\n|---|---|---|\n| 最悪計算量 | O(n²) | O(n log n) |\n| 安定性 | 安定 | 安定 |\n| 空間計算量 | O(1) | O(n) |\n| 実用性 | 教育用 | 実用的 |\n\nマージソートは大規模データで圧倒的に速く、安定ソートであるため実用的です。"}', 5);

-- Lesson 3: クイックソート
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('l0000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000001', 'quick-sort',
  'クイックソート', '実用で最も使われるソートアルゴリズム', 2, 15, 3, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('l0000000-0000-0000-0000-000000000003', 'markdown', '{"text": "# クイックソート\n\nクイックソート（Quick Sort）は、ピボット要素を基準にデータを分割する分割統治法アルゴリズムです。\n\n平均的に最も高速なソートアルゴリズムの一つで、多くのプログラミング言語の標準ライブラリで採用されています。"}', 0),
('l0000000-0000-0000-0000-000000000003', 'callout', '{"type": "info", "text": "計算量: 平均 O(n log n)、最悪 O(n²)、空間計算量: O(log n)（再帰スタック）"}', 1),
('l0000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## アルゴリズムの手順\n\n1. **ピボット選択**: 配列から基準となる要素（ピボット）を選ぶ\n2. **分割（Partition）**: ピボットより小さい要素を左に、大きい要素を右に配置\n3. **再帰**: 左右それぞれに対して再帰的にクイックソートを適用"}', 2),
('l0000000-0000-0000-0000-000000000003', 'code', '{"language": "python", "code": "def quick_sort(arr):\n    if len(arr) <= 1:\n        return arr\n    \n    pivot = arr[len(arr) // 2]\n    left = [x for x in arr if x < pivot]\n    middle = [x for x in arr if x == pivot]\n    right = [x for x in arr if x > pivot]\n    \n    return quick_sort(left) + middle + quick_sort(right)\n\nprint(quick_sort([3, 6, 8, 10, 1, 2, 1]))\n# => [1, 1, 2, 3, 6, 8, 10]", "runnable": false}', 3),
('l0000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## ピボット選択の重要性\n\nピボットの選び方が性能に大きく影響します:\n\n- **先頭要素**: ソート済みデータで最悪ケース O(n²) に\n- **中央要素**: バランスの良い分割になりやすい\n- **ランダム**: 最悪ケースを確率的に回避\n- **三値の中央値**: 先頭・中央・末尾の中央値を使用（実用的）"}', 4),
('l0000000-0000-0000-0000-000000000003', 'callout', '{"type": "tip", "text": "クイックソートはインプレースで実装可能で、キャッシュ効率が良いため、実測性能ではマージソートを上回ることが多いです。"}', 5);

-- ===== Lessons: 探索アルゴリズム =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('l0000000-0000-0000-0000-000000000004', 'c0000000-0000-0000-0000-000000000002', 'binary-search',
  '二分探索', '効率的な探索の基礎', 1, 10, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('l0000000-0000-0000-0000-000000000004', 'markdown', '{"text": "# 二分探索\n\n二分探索（Binary Search）は、**ソート済み配列**から目的の要素を効率的に見つけるアルゴリズムです。\n\n探索範囲を毎回半分に絞ることで、線形探索 O(n) に比べて O(log n) の計算量を実現します。"}', 0),
('l0000000-0000-0000-0000-000000000004', 'callout', '{"type": "info", "text": "計算量: O(log n)、前提条件: 配列がソート済みであること"}', 1),
('l0000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## アルゴリズムの手順\n\n1. 配列の中央要素を確認\n2. 目的値と一致すれば探索終了\n3. 目的値が中央値より小さければ左半分を探索\n4. 目的値が中央値より大きければ右半分を探索\n5. 範囲がなくなるまで繰り返す"}', 2),
('l0000000-0000-0000-0000-000000000004', 'code', '{"language": "python", "code": "def binary_search(arr, target):\n    left, right = 0, len(arr) - 1\n    \n    while left <= right:\n        mid = (left + right) // 2\n        if arr[mid] == target:\n            return mid\n        elif arr[mid] < target:\n            left = mid + 1\n        else:\n            right = mid - 1\n    \n    return -1  # 見つからなかった\n\narr = [2, 3, 4, 10, 40]\nprint(binary_search(arr, 10))  # => 3", "runnable": false}', 3),
('l0000000-0000-0000-0000-000000000004', 'markdown', '{"text": "## 二分探索の応用\n\n二分探索は単純な値の検索以外にも幅広く応用できます:\n\n- **lower_bound / upper_bound**: 条件を満たす最初/最後の位置を見つける\n- **答えの二分探索**: 最適化問題で「条件を満たす最小/最大値」を効率的に求める\n- **回転ソート配列の探索**: 部分的にソートされた配列にも適用可能"}', 4);

-- ===== Lessons: 木構造 =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('l0000000-0000-0000-0000-000000000005', 'c0000000-0000-0000-0000-000000000003', 'binary-tree-basics',
  '二分木の基礎', '木構造の基本概念と走査方法', 1, 15, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('l0000000-0000-0000-0000-000000000005', 'markdown', '{"text": "# 二分木の基礎\n\n二分木（Binary Tree）は、各ノードが最大2つの子ノード（左の子と右の子）を持つ木構造です。\n\n木構造はコンピュータサイエンスにおいて最も重要なデータ構造の一つで、ファイルシステム、データベースインデックス、構文解析などに広く使われています。"}', 0),
('l0000000-0000-0000-0000-000000000005', 'markdown', '{"text": "## 基本用語\n\n- **ルート（Root）**: 木の最上位ノード\n- **葉（Leaf）**: 子を持たないノード\n- **深さ（Depth）**: ルートからの距離\n- **高さ（Height）**: 葉までの最長距離\n- **部分木（Subtree）**: あるノードをルートとする木"}', 1),
('l0000000-0000-0000-0000-000000000005', 'code', '{"language": "python", "code": "class TreeNode:\n    def __init__(self, val=0, left=None, right=None):\n        self.val = val\n        self.left = left\n        self.right = right\n\n# 走査（Traversal）\ndef inorder(node):\n    \"\"\"中順走査: 左 → 根 → 右\"\"\"\n    if node is None:\n        return []\n    return inorder(node.left) + [node.val] + inorder(node.right)\n\ndef preorder(node):\n    \"\"\"前順走査: 根 → 左 → 右\"\"\"\n    if node is None:\n        return []\n    return [node.val] + preorder(node.left) + preorder(node.right)\n\ndef postorder(node):\n    \"\"\"後順走査: 左 → 右 → 根\"\"\"\n    if node is None:\n        return []\n    return postorder(node.left) + postorder(node.right) + [node.val]", "runnable": false}', 2),
('l0000000-0000-0000-0000-000000000005', 'callout', '{"type": "tip", "text": "二分探索木（BST）では、中順走査の結果がソート済みになります。これは BST の重要な性質です。"}', 3),
('l0000000-0000-0000-0000-000000000005', 'markdown', '{"text": "## 走査方法まとめ\n\n| 走査方法 | 順序 | 主な用途 |\n|---|---|---|\n| 前順（Preorder） | 根→左→右 | 木のコピー、式の前置記法 |\n| 中順（Inorder） | 左→根→右 | BSTのソート出力 |\n| 後順（Postorder） | 左→右→根 | 部分木の削除、式の後置記法 |\n| 幅優先（BFS） | レベル順 | 最短経路、レベル別処理 |"}', 4);

-- ===== Lessons: グラフ =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('l0000000-0000-0000-0000-000000000006', 'c0000000-0000-0000-0000-000000000004', 'graph-bfs-dfs',
  'グラフ探索: BFS と DFS', 'グラフの基本的な探索手法', 2, 20, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('l0000000-0000-0000-0000-000000000006', 'markdown', '{"text": "# グラフ探索: BFS と DFS\n\nグラフはノード（頂点）とエッジ（辺）からなるデータ構造です。SNSの人間関係、道路ネットワーク、Webページのリンク構造など、現実世界の多くの問題がグラフとしてモデル化できます。\n\n**BFS（幅優先探索）**と**DFS（深さ優先探索）**は、グラフを系統的に探索する2つの基本的なアプローチです。"}', 0),
('l0000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## BFS（幅優先探索）\n\n開始ノードから近い順にすべてのノードを訪問します。**キュー**を使って実装します。\n\n**特徴:**\n- 最短経路を保証（重みなしグラフ）\n- メモリ使用量が多い（隣接ノードをすべて保持）"}', 1),
('l0000000-0000-0000-0000-000000000006', 'code', '{"language": "python", "code": "from collections import deque\n\ndef bfs(graph, start):\n    visited = set()\n    queue = deque([start])\n    visited.add(start)\n    result = []\n    \n    while queue:\n        node = queue.popleft()\n        result.append(node)\n        \n        for neighbor in graph[node]:\n            if neighbor not in visited:\n                visited.add(neighbor)\n                queue.append(neighbor)\n    \n    return result\n\n# 例\ngraph = {\n    \"A\": [\"B\", \"C\"],\n    \"B\": [\"A\", \"D\", \"E\"],\n    \"C\": [\"A\", \"F\"],\n    \"D\": [\"B\"],\n    \"E\": [\"B\", \"F\"],\n    \"F\": [\"C\", \"E\"]\n}\nprint(bfs(graph, \"A\"))  # => [\"A\", \"B\", \"C\", \"D\", \"E\", \"F\"]", "runnable": false}', 2),
('l0000000-0000-0000-0000-000000000006', 'markdown', '{"text": "## DFS（深さ優先探索）\n\n一つの経路を可能な限り深く進み、行き止まりに達したらバックトラックします。**スタック**（または再帰）を使って実装します。\n\n**特徴:**\n- メモリ効率が良い\n- 経路の探索や連結成分の検出に向いている\n- 最短経路は保証しない"}', 3),
('l0000000-0000-0000-0000-000000000006', 'code', '{"language": "python", "code": "def dfs(graph, start):\n    visited = set()\n    result = []\n    \n    def _dfs(node):\n        visited.add(node)\n        result.append(node)\n        for neighbor in graph[node]:\n            if neighbor not in visited:\n                _dfs(neighbor)\n    \n    _dfs(start)\n    return result\n\nprint(dfs(graph, \"A\"))  # => [\"A\", \"B\", \"D\", \"E\", \"F\", \"C\"]", "runnable": false}', 4),
('l0000000-0000-0000-0000-000000000006', 'callout', '{"type": "info", "text": "BFS は最短経路問題に、DFS はトポロジカルソートや閉路検出に適しています。問題の性質に応じて使い分けましょう。"}', 5);

-- ===== Lessons: 連結リスト =====

INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('l0000000-0000-0000-0000-000000000007', 'c0000000-0000-0000-0000-000000000005', 'linked-list-basics',
  '連結リストの基礎', 'ポインタベースのデータ構造を理解する', 1, 12, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('l0000000-0000-0000-0000-000000000007', 'markdown', '{"text": "# 連結リストの基礎\n\n連結リスト（Linked List）は、各要素（ノード）がデータと次のノードへの参照（ポインタ）を持つデータ構造です。\n\n配列とは異なり、メモリ上に連続して配置される必要がなく、挿入・削除が O(1) で行えます。"}', 0),
('l0000000-0000-0000-0000-000000000007', 'callout', '{"type": "info", "text": "配列 vs 連結リスト: 配列はインデックスアクセス O(1)、連結リストは先頭への挿入/削除 O(1)。用途に応じて使い分けます。"}', 1),
('l0000000-0000-0000-0000-000000000007', 'code', '{"language": "python", "code": "class ListNode:\n    def __init__(self, val=0, next=None):\n        self.val = val\n        self.next = next\n\nclass LinkedList:\n    def __init__(self):\n        self.head = None\n    \n    def prepend(self, val):\n        \"\"\"先頭に追加: O(1)\"\"\"\n        self.head = ListNode(val, self.head)\n    \n    def append(self, val):\n        \"\"\"末尾に追加: O(n)\"\"\"\n        if not self.head:\n            self.head = ListNode(val)\n            return\n        curr = self.head\n        while curr.next:\n            curr = curr.next\n        curr.next = ListNode(val)\n    \n    def delete(self, val):\n        \"\"\"値を削除: O(n)\"\"\"\n        if self.head and self.head.val == val:\n            self.head = self.head.next\n            return\n        curr = self.head\n        while curr and curr.next:\n            if curr.next.val == val:\n                curr.next = curr.next.next\n                return\n            curr = curr.next\n    \n    def to_list(self):\n        result = []\n        curr = self.head\n        while curr:\n            result.append(curr.val)\n            curr = curr.next\n        return result", "runnable": false}', 2),
('l0000000-0000-0000-0000-000000000007', 'markdown', '{"text": "## 連結リストの種類\n\n| 種類 | 特徴 |\n|---|---|\n| 単方向リスト | 各ノードが次のノードのみを参照 |\n| 双方向リスト | 各ノードが前後のノードを参照 |\n| 循環リスト | 末尾が先頭を参照（ループ構造） |\n\n双方向リストは前後の走査が可能ですが、メモリ使用量が増えます。"}', 3);
