-- Delete old sorting lessons and blocks
DELETE FROM lesson_blocks WHERE lesson_id IN (
  '10000000-0000-0000-0000-000000000001',
  '10000000-0000-0000-0000-000000000002',
  '10000000-0000-0000-0000-000000000003'
);
DELETE FROM lessons WHERE id IN (
  '10000000-0000-0000-0000-000000000001',
  '10000000-0000-0000-0000-000000000002',
  '10000000-0000-0000-0000-000000000003'
);

-- ============================================================
-- Bubble Sort: 初級 (difficulty_level=1)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 'bubble-sort',
  'バブルソート',
  '隣接要素の比較交換に基づく最も素朴なソートアルゴリズム。計算量の導出と最適化を学ぶ。', 1, 20, 1, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
-- 導入
('10000000-0000-0000-0000-000000000001', 'markdown', '{"text": "# バブルソート（Bubble Sort）\n\nバブルソートは**隣接する2要素を比較し、順序が逆なら交換する**操作を繰り返すソートアルゴリズムです。\n\n最大値が配列の末尾へ「浮かび上がる」様子が泡（バブル）に似ていることからこの名前がつきました。アルゴリズムの基本概念——ループ不変条件、計算量解析、最適化——を学ぶ教材として最適です。"}', 0),

-- アルゴリズムの定義
('10000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## アルゴリズム\n\n配列 A[0..n-1] に対して:\n\n```\nfor i = 0 to n-2:\n    for j = 0 to n-2-i:\n        if A[j] > A[j+1]:\n            swap(A[j], A[j+1])\n```\n\n### ループ不変条件（Loop Invariant）\n\n外側ループの各反復 i の開始時に、**A[n-i..n-1] は最終的な正しい位置にある最大 i 個の要素を含む**。\n\n- **初期条件**: i=0 のとき、ソート済み部分は空。自明に成立。\n- **維持**: 内側ループにより、A[0..n-1-i] の最大値が A[n-1-i] に移動する。\n- **終了**: i=n-1 のとき、全要素がソート済み。"}', 1),

-- 計算量の導出
('10000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## 計算量の導出\n\n### 比較回数\n\n内側ループの比較回数は i=0 のとき (n-1) 回、i=1 のとき (n-2) 回、...、i=n-2 のとき 1 回。\n\n$$\\sum_{i=0}^{n-2}(n-1-i) = \\sum_{k=1}^{n-1}k = \\frac{n(n-1)}{2}$$\n\nよって比較回数は **Θ(n²)**。\n\n### 最悪ケース（降順配列）\n\n毎回の比較で交換が発生するため、交換回数も Θ(n²)。\n\n### 最良ケース（昇順配列、最適化あり）\n\n1パスで交換が0回なら停止するフラグを導入すると、比較 n-1 回で終了。**O(n)**。\n\n### 空間計算量\n\nインプレースで動作するため **O(1)**（一時変数のみ）。"}', 2),

-- 実装: Python
('10000000-0000-0000-0000-000000000001', 'code', '{"language": "python", "code": "def bubble_sort(arr: list[int]) -> list[int]:\n    \"\"\"最適化バブルソート: 交換が発生しなければ早期終了\"\"\"\n    n = len(arr)\n    for i in range(n):\n        swapped = False\n        for j in range(n - 1 - i):\n            if arr[j] > arr[j + 1]:\n                arr[j], arr[j + 1] = arr[j + 1], arr[j]\n                swapped = True\n        if not swapped:\n            break  # すでにソート済み → O(n) で終了\n    return arr\n\n# 動作確認\nassert bubble_sort([64, 34, 25, 12, 22, 11, 90]) == [11, 12, 22, 25, 34, 64, 90]\nassert bubble_sort([1, 2, 3, 4, 5]) == [1, 2, 3, 4, 5]  # 最良ケース: 1パスで終了", "runnable": false}', 3),

-- 実装: Go
('10000000-0000-0000-0000-000000000001', 'code', '{"language": "go", "code": "func bubbleSort(arr []int) {\n\tn := len(arr)\n\tfor i := 0; i < n; i++ {\n\t\tswapped := false\n\t\tfor j := 0; j < n-1-i; j++ {\n\t\t\tif arr[j] > arr[j+1] {\n\t\t\t\tarr[j], arr[j+1] = arr[j+1], arr[j]\n\t\t\t\tswapped = true\n\t\t\t}\n\t\t}\n\t\tif !swapped {\n\t\t\tbreak\n\t\t}\n\t}\n}", "runnable": false}', 4),

-- 安定性
('10000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## 安定性（Stability）\n\nバブルソートは**安定ソート**です。等しい要素の相対順序が保たれます。\n\nこれは比較が `>` （厳密な不等号）で行われ、等しい要素は交換されないためです。比較を `>=` に変えると不安定になります。\n\n安定性が重要な場面:\n- データベースで複数キーによるソート（第1キーでソート後、第2キーで安定ソートすると両方のキーで正しくソートされる）\n- UI でのソート済みリストの再ソート"}', 5),

-- 実用上の位置づけ
('10000000-0000-0000-0000-000000000001', 'callout', '{"type": "warning", "text": "実用上、バブルソートが最適な場面はほぼありません。ほぼソート済みの小さなデータには挿入ソートが優れ（定数係数が小さい）、一般的にはマージソートやクイックソートが使われます。バブルソートの価値は教育にあります。"}', 6),

-- まとめ
('10000000-0000-0000-0000-000000000001', 'markdown', '{"text": "## まとめ\n\n| 特性 | 値 |\n|---|---|\n| 最悪計算量 | O(n²) 比較・交換 |\n| 最良計算量 | O(n) 比較、O(1) 交換（最適化版） |\n| 平均計算量 | O(n²) |\n| 空間計算量 | O(1) |\n| 安定性 | 安定 |\n| 適応性 | あり（最適化版は nearly-sorted に強い） |\n\n**学習のポイント**: ループ不変条件による正当性の議論、Σ計算による計算量の導出、フラグによる最適化の効果。これらの考え方はすべてのアルゴリズム学習の基盤になります。"}', 7);

-- ============================================================
-- Merge Sort: 中級 (difficulty_level=2)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000001', 'merge-sort',
  'マージソート',
  '分割統治法の代表。漸化式による計算量解析（マスター定理）と安定O(n log n)の意義。', 2, 25, 2, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000002', 'markdown', '{"text": "# マージソート（Merge Sort）\n\nマージソートは**分割統治法（Divide and Conquer）**に基づくソートアルゴリズムです。1945年にジョン・フォン・ノイマンが考案しました。\n\n**すべてのケースで O(n log n)** を保証する安定ソートであり、理論的にも実用的にも重要なアルゴリズムです。"}', 0),

('10000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## アルゴリズム\n\n分割統治法の3ステップ:\n\n1. **Divide**: 配列を中央で2つの部分配列に分割\n2. **Conquer**: 各部分配列を再帰的にマージソート\n3. **Combine**: 2つのソート済み部分配列をマージ（統合）\n\n### マージ操作\n\n2つのソート済み配列 L, R から、先頭の小さい方を順に取り出して結果配列に格納。各要素は1回ずつ比較されるため、マージは **O(n)** で完了します。\n\n### 正当性\n\n再帰の基底: 要素数0または1の配列はソート済み（自明）。\n帰納段階: 部分配列が正しくソートされていると仮定すると、マージ操作は2つのソート済み配列から正しいソート結果を生成する（マージのループ不変条件から証明可能）。"}', 1),

('10000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## 計算量の解析\n\n### 漸化式\n\nサイズ n の問題に対する計算量 T(n):\n\n$$T(n) = 2T(n/2) + O(n)$$\n\n- 2T(n/2): 2つの部分問題を再帰的に解くコスト\n- O(n): マージのコスト\n\n### マスター定理による解法\n\n$T(n) = aT(n/b) + O(n^d)$ の形で、a=2, b=2, d=1。\n\n$\\log_b a = \\log_2 2 = 1 = d$ なので、ケース2に該当:\n\n$$T(n) = O(n^d \\log n) = O(n \\log n)$$\n\n### 直感的理解\n\n再帰の深さは log₂n 段。各段では全要素が1回ずつマージ操作に参加するため、1段あたり O(n) の仕事量。合計 **O(n log n)**。\n\n### 空間計算量\n\nマージ時に一時配列が必要: **O(n)**。これはバブルソートの O(1) と比較した欠点。"}', 2),

('10000000-0000-0000-0000-000000000002', 'code', '{"language": "python", "code": "def merge_sort(arr: list[int]) -> list[int]:\n    \"\"\"トップダウン・マージソート\"\"\"\n    if len(arr) <= 1:\n        return arr\n    \n    mid = len(arr) // 2\n    left = merge_sort(arr[:mid])\n    right = merge_sort(arr[mid:])\n    return merge(left, right)\n\ndef merge(left: list[int], right: list[int]) -> list[int]:\n    \"\"\"2つのソート済み配列をマージ: O(n)\"\"\"\n    result = []\n    i = j = 0\n    \n    while i < len(left) and j < len(right):\n        if left[i] <= right[j]:   # <= で安定性を保証\n            result.append(left[i])\n            i += 1\n        else:\n            result.append(right[j])\n            j += 1\n    \n    # 残りの要素を追加\n    result.extend(left[i:])\n    result.extend(right[j:])\n    return result\n\n# 検証\nimport random\narr = random.sample(range(1000), 100)\nassert merge_sort(arr) == sorted(arr)", "runnable": false}', 3),

('10000000-0000-0000-0000-000000000002', 'code', '{"language": "go", "code": "func mergeSort(arr []int) []int {\n\tif len(arr) <= 1 {\n\t\treturn arr\n\t}\n\tmid := len(arr) / 2\n\tleft := mergeSort(arr[:mid])\n\tright := mergeSort(arr[mid:])\n\treturn mergeSorted(left, right)\n}\n\nfunc mergeSorted(left, right []int) []int {\n\tresult := make([]int, 0, len(left)+len(right))\n\ti, j := 0, 0\n\tfor i < len(left) && j < len(right) {\n\t\tif left[i] <= right[j] {\n\t\t\tresult = append(result, left[i])\n\t\t\ti++\n\t\t} else {\n\t\t\tresult = append(result, right[j])\n\t\t\tj++\n\t\t}\n\t}\n\tresult = append(result, left[i:]...)\n\tresult = append(result, right[j:]...)\n\treturn result\n}", "runnable": false}', 4),

('10000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## ボトムアップ・マージソート\n\n再帰を使わず、サイズ1の区間から始めて隣接区間を順次マージしていく反復的実装もあります。\n\n- 再帰のスタックオーバーフローを回避\n- キャッシュ効率が再帰版より良い場合がある\n- 実装がやや複雑\n\nTimSort（Python の `sorted()`, Java の `Arrays.sort()`）はボトムアップ・マージソートを基盤に、挿入ソートとの組み合わせでさらに最適化したアルゴリズムです。"}', 5),

('10000000-0000-0000-0000-000000000002', 'callout', '{"type": "info", "text": "比較ベースのソートの下界は Ω(n log n) です（決定木モデルによる証明）。マージソートはこの下界に一致するため、漸近的に最適なソートアルゴリズムの一つです。"}', 6),

('10000000-0000-0000-0000-000000000002', 'markdown', '{"text": "## まとめ\n\n| 特性 | 値 |\n|---|---|\n| 最悪計算量 | O(n log n) |\n| 最良計算量 | O(n log n) |\n| 平均計算量 | O(n log n) |\n| 空間計算量 | O(n) |\n| 安定性 | 安定 |\n| 適応性 | なし（入力によらず同じ計算量） |\n\n**学習のポイント**: 分割統治法のパラダイム、漸化式とマスター定理による計算量解析、安定ソートの設計（`<=` の重要性）、O(n log n) が比較ソートの理論的下界であること。"}', 7);

-- ============================================================
-- Quick Sort: 中級〜上級 (difficulty_level=3)
-- ============================================================
INSERT INTO lessons (id, category_id, slug, title, summary, difficulty_level, estimated_minutes, sort_order, is_published)
VALUES ('10000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000001', 'quick-sort',
  'クイックソート',
  'Hoareのパーティション、ピボット選択戦略、期待計算量の解析、実測性能の優位性。', 3, 30, 3, true);

INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('10000000-0000-0000-0000-000000000003', 'markdown', '{"text": "# クイックソート（Quick Sort）\n\n1960年にC.A.R. Hoareが考案。実測性能で最速のソートアルゴリズムの一つであり、多くの標準ライブラリ（C の `qsort`、Go の `sort.Slice`）の実装基盤です。\n\n最悪 O(n²) ですが、**期待計算量は O(n log n)**であり、定数係数の小ささとキャッシュ効率の良さから実測ではマージソートを上回ります。"}', 0),

('10000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## アルゴリズム\n\n1. **ピボット選択**: 配列から基準値 p を選ぶ\n2. **パーティション**: p より小さい要素を左に、大きい要素を右に配置（O(n)）\n3. **再帰**: 左右それぞれに対してクイックソートを適用\n\nマージソートとの本質的な違い: マージソートは分割が自明（中央で割る）でマージが仕事。クイックソートはパーティションが仕事で、結合が自明（インプレースで完了済み）。"}', 1),

('10000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## パーティションの実装\n\n### Lomutoパーティション\n\nシンプルだが、等しい要素が多い場合に効率が落ちる。教育向き。\n\n### Hoareパーティション\n\n両端からポインタを動かす。比較回数は平均でLomutoの約半分。\n\n### Dutch National Flag（3-way partition）\n\nDijkstraの手法。等しい要素が多い場合に O(n) で完了。重複の多いデータで有効。"}', 2),

('10000000-0000-0000-0000-000000000003', 'code', '{"language": "python", "code": "def quicksort(arr: list[int], lo: int = 0, hi: int | None = None) -> None:\n    \"\"\"インプレース・クイックソート（Lomutoパーティション）\"\"\"\n    if hi is None:\n        hi = len(arr) - 1\n    if lo >= hi:\n        return\n    \n    pivot_idx = partition(arr, lo, hi)\n    quicksort(arr, lo, pivot_idx - 1)\n    quicksort(arr, pivot_idx + 1, hi)\n\ndef partition(arr: list[int], lo: int, hi: int) -> int:\n    \"\"\"Lomutoパーティション: ピボット=末尾要素\"\"\"\n    pivot = arr[hi]\n    i = lo  # i: pivot以下の要素の境界\n    \n    for j in range(lo, hi):\n        if arr[j] <= pivot:\n            arr[i], arr[j] = arr[j], arr[i]\n            i += 1\n    \n    arr[i], arr[hi] = arr[hi], arr[i]\n    return i  # ピボットの最終位置\n\n# 検証\nimport random\narr = random.sample(range(10000), 1000)\nquicksort(arr)\nassert arr == sorted(arr)", "runnable": false}', 3),

('10000000-0000-0000-0000-000000000003', 'code', '{"language": "python", "code": "def quicksort_3way(arr: list[int], lo: int = 0, hi: int | None = None) -> None:\n    \"\"\"3-way partition（Dutch National Flag）: 重複要素に強い\"\"\"\n    if hi is None:\n        hi = len(arr) - 1\n    if lo >= hi:\n        return\n    \n    pivot = arr[lo]\n    lt, i, gt = lo, lo, hi  # lt: <pivot, i: scanning, gt: >pivot\n    \n    while i <= gt:\n        if arr[i] < pivot:\n            arr[lt], arr[i] = arr[i], arr[lt]\n            lt += 1\n            i += 1\n        elif arr[i] > pivot:\n            arr[i], arr[gt] = arr[gt], arr[i]\n            gt -= 1\n        else:  # arr[i] == pivot\n            i += 1\n    \n    # arr[lo..lt-1] < pivot == arr[lt..gt] < arr[gt+1..hi]\n    quicksort_3way(arr, lo, lt - 1)\n    quicksort_3way(arr, gt + 1, hi)", "runnable": false}', 4),

('10000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## 計算量の解析\n\n### 最悪ケース: O(n²)\n\nピボットが毎回最小値または最大値の場合、パーティションが (0, n-1) に分割され:\n\n$$T(n) = T(n-1) + O(n) = O(n^2)$$\n\nすでにソート済みの配列に対し、先頭/末尾をピボットにすると最悪ケースに陥ります。\n\n### 最良ケース: O(n log n)\n\nピボットが常に中央値の場合: $T(n) = 2T(n/2) + O(n) = O(n \\log n)$\n\n### 期待計算量: O(n log n)\n\nランダムピボット選択の場合、任意の要素がピボットになる確率は等しく 1/n。\n\n期待比較回数は $2n\\ln n \\approx 1.39 n\\log_2 n$\n\nこれはマージソートの $n\\log_2 n$ の約1.39倍ですが、クイックソートはインプレースでキャッシュ効率が良いため、実測ではマージソートより速くなります。"}', 5),

('10000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## ピボット選択戦略\n\n| 戦略 | 最悪ケース | 実装の複雑さ | 備考 |\n|---|---|---|---|\n| 先頭/末尾 | ソート済みで O(n²) | 最も単純 | 教育用のみ |\n| ランダム | 確率的に O(n²) を回避 | 簡単 | 実用的 |\n| Median-of-3 | ほぼ回避 | やや複雑 | 多くの標準ライブラリで採用 |\n| Median-of-medians | O(n log n) 保証 | 複雑 | 定数が大きく理論的意義 |\n\n**Median-of-3**: 先頭・中央・末尾の3値の中央値をピボットにする。ソート済みデータでの最悪ケースを回避し、実装も簡潔。\n\n**Introspective Sort (Introsort)**: クイックソートで始め、再帰の深さが 2log₂n を超えたらヒープソートに切り替え。最悪 O(n log n) を保証。C++ の `std::sort` で採用。"}', 6),

('10000000-0000-0000-0000-000000000003', 'callout', '{"type": "tip", "text": "クイックソートが実測で速い理由: (1) インプレースのためメモリアロケーションが不要、(2) 配列の連続アクセスによるキャッシュヒット率の高さ、(3) 分岐予測に優しいアクセスパターン。これらのハードウェア要因がO記法の定数係数を小さくします。"}', 7),

('10000000-0000-0000-0000-000000000003', 'markdown', '{"text": "## 比較ソートの全体像\n\n| | バブル | マージ | クイック | ヒープ | Tim |\n|---|---|---|---|---|---|\n| 最悪 | O(n²) | O(n log n) | O(n²) | O(n log n) | O(n log n) |\n| 平均 | O(n²) | O(n log n) | O(n log n) | O(n log n) | O(n log n) |\n| 最良 | O(n) | O(n log n) | O(n log n) | O(n log n) | O(n) |\n| 空間 | O(1) | O(n) | O(log n) | O(1) | O(n) |\n| 安定 | Yes | Yes | No | No | Yes |\n| 実測速度 | 遅い | 速い | 最速級 | 中程度 | 最速級 |\n\n**理論的下界**: 比較ベースのソートは最悪 Ω(n log n) の比較が必要（決定木の高さ ≥ log₂(n!)  ≈ n log n）。カウンティングソートや基数ソートはこの制約を受けませんが、入力の範囲に制約があります。\n\n**学習のポイント**: パーティション操作の設計、ピボット選択が性能に与える影響、期待値解析の考え方、O記法と実測性能の乖離。"}', 8);
