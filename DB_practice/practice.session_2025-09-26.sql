-- 生成AIに問題を出してもらいながらSQL操作の理解を深める
-- 使いながら理解を固めるための「短い課題」（答えは自力で出す前提）
-- 手動確認用(全部出し)
SELECT *
FROM customers
    JOIN orders ON customers.id = orders.customer_id
    JOIN order_items ON orders.id = order_items.order_id
    JOIN products ON order_items.product_id = products.id;
----------------------------------------------------------------------------------------------------
-- #1 WHERE vs HAVING
-- ##1-1   EAST地域の顧客の注文のみ合計金額を商品別に出す（WHEREでregionを先に絞る）。
--【レビュー】--
--1. (WHERE)：売上集計ならば、支払済みと発送済みに限定するのが自然
----
SELECT products.name,
    sum(order_items.quantity * order_items.unit_price)
FROM customers
    JOIN orders ON customers.id = orders.customer_id
    JOIN order_items ON orders.id = order_items.order_id
    JOIN products ON order_items.product_id = products.id
WHERE region = "east"
    and orders.status IN("paid", "shipped")
GROUP BY products.name;
--------------------------------------------------
-- ##1-2   商品別合計が2,000円以上のものだけ残す（HAVINGでSUM…>= 2000）。
--【レビュー】--
--1. (HAVING)：実行順序に厳格なSQL環境ではSELECTのエイリアスをHAVINGで使えない可能性もある
--2. (ORDER BY)：結果の見やすさを整える
-----
SELECT products.name,
    sum(order_items.quantity * order_items.unit_price) as s
FROM customers
    JOIN orders ON customers.id = orders.customer_id
    JOIN order_items ON orders.id = order_items.order_id
    JOIN products ON order_items.product_id = products.id
WHERE region = "east"
GROUP BY products.name
HAVING sum(order_items.quantity * order_items.unit_price) >= 2000
ORDER BY s DESC;
----------------------------------------------------------------------------------------------------
-- #2 GROUP BY 複数キー
-- ##2-1   product.category × customers.region ごとの売上合計と件数。
--【レビュー】--
--1. (SELECT)：NULL値の見やすさを重視する
--2. (SELECT)：COUNTの使用方法を見直すべき、GROUP BYでグルーピングしているので2つも不要
--3. (WHERE)：売上の定義を追加すべき
--4. (ORDER BY)：出力の安定性のため、表示順を固定したほうが無難
----
SELECT products.category,
    COALESCE(customers.region, "unknown") as region,
    sum(order_items.quantity * order_items.unit_price) as "売上合計",
    count(*) as "注文件数"
FROM customers
    JOIN orders ON orders.customer_id = customers.id
    JOIN order_items ON order_items.order_id = orders.id
    JOIN products ON products.id = order_items.product_id
WHERE orders.status IN ("paid", "shipped")
GROUP BY products.category,
    COALESCE(customers.region, "unknown")
ORDER BY products.category ASC,
    region ASC;
----------------------------------------------------------------------------------------------------
-- #3 DISTINCT
-- ##3-1    クーポンを使ったことがある顧客の ユニークな顧客ID一覧（SELECT DISTINCT）。
-- 定義：
--  ・クーポンを使用していない顧客はリストに含めない
-- 学習目的：
--  ・DISTINCTの使い方を理解する
-- 期待する結果：
--  ・クーポンを使用した事がある顧客IDが重複なく表示される
--顧客IDが重複なく表示された
SELECT DISTINCT(c.id)
FROM customers as c
    JOIN orders as o ON o.customer_id = c.id
ORDER BY c.id ASC;
--WHEREで絞り込みを行い、DISTINCTでIDを取得した。
SELECT DISTINCT(c.id)
FROM customers as c
    JOIN orders as o ON o.customer_id = c.id
WHERE o.coupon_code IS NOT NULL
ORDER BY c.id ASC;
----【レビュー】----
--1. （DISTINCT）：SELECT DISTINCT(c.id) は動くDBもあるが、標準的には括弧を付けない
--2. （全体）：顧客IDのみを表示させるならcustomersテーブルは不要
----
--レビュー後
SELECT DISTINCT o.customer_id
FROM orders as o
WHERE o.coupon_code IS NOT NULL
ORDER BY o.customer_id ASC;
--ordersテーブルのみだとnull除外の段階ですでにユニークなってる…
--------------------------------------------------
-- ##3-2    使用クーポンの種類数（COUNT(DISTINCT coupon_code)、NULL除外に注意）。
-- 定義：
--  ・使用されたクーポンの回数ではなく種類数をカウントする
--  ・SELECTで作る結果は出力のカラム名を見やすくするために"coupon_type_count"とする
-- 目的：
--  ・DISTINCTを含めたカウントの使用方法を理解する
-- 期待する結果：
--  ・使用されたクーポンの種類数が表示される
-- WHERE句でNULLを除外する
-- count(*)では重複をカウントするのでDISTINCTを使用する
-- DISTINCTには"*"が使用できないのでカラム名としてcoupon_codeを使用する
SELECT count(DISTINCT(o.coupon_code)) as coupon_type_count
FROM customers as c
    JOIN orders as o ON o.customer_id = c.id
WHERE o.coupon_code IS NOT NULL
ORDER BY c.id ASC;
----【レビュー】----
--1. （全体）：種類数カウントは orders 単体で十分。customers へのJOINは不要
--2. （ORDER BY）：集計だけ返すクエリに ORDER BY c.id は無意味かつDBによってはエラー
----
--レビュー後
SELECT count(DISTINCT o.coupon_code) as coupon_type_count
FROM orders as o
WHERE o.coupon_code IS NOT NULL;
----------------------------------------------------------------------------------------------------
-- #4 ORDER BY + LIMIT
-- ##4-1   注文日の新しい順トップ5件。
-- 定義：
--  ・結果に注文日、顧客名、メールアドレス、地域を含める
-- 目的：
--  ・ORDER BYとLIMITに関する理解を深める
-- 期待する結果：
--  ・注文日の日付が新しい順に5件分表示される
--注文日を大きい(新しい)順にしたいのでDESCを使用する
SELECT o.order_date,
    c.name,
    c.email,
    c.region
FROM orders as o
    JOIN customers as c ON c.id = o.customer_id
ORDER BY o.order_date DESC
LIMIT 5;
----【レビュー】----
--1. （ORDER BY）：もし同一日付が並ぶと表示順が不安定。o.id をセカンダリキーに。
----
--レビュー後
SELECT o.order_date,
    c.name,
    c.email,
    c.region
FROM orders as o
    JOIN customers as c ON c.id = o.customer_id
ORDER BY o.order_date DESC,
    o.id DESC
LIMIT 5;
--------------------------------------------------
-- ##4-2   売上高トップ3商品（SUM(oi.quantity*oi.unit_price)を集計→降順→LIMIT）。
-- 定義：
--  ・売上なので注文状態は'paid'または'shipped'のものとする
--  ・結果には商品名と金額を表示させる
-- 目的：
--  ・SUMの集計関数とLIMITの理解を深める
-- 期待する結果：
--  ・商品名と合計金額が表示される
SELECT p.name,
    sum(oi.unit_price * oi.quantity) as total_price
FROM order_items as oi
    JOIN orders as o ON o.id = oi.order_id
    JOIN products as p ON p.id = oi.product_id
WHERE o.status IN ('paid', 'shipped')
GROUP BY p.name
ORDER BY total_price DESC
LIMIT 3;
----【レビュー】----
--1. （GROUP BY）：商品名は変更/重複の可能性あり。p.id で集計し、表示に p.name。
--2. （SELECT）：total_price よりも total_amount（金額合計）などに揃えると他クエリと整合が取れる。
----
--レビュー後
SELECT p.id,
    p.name,
    sum(oi.unit_price * oi.quantity) as total_amount
FROM order_items as oi
    JOIN orders as o ON o.id = oi.order_id
    JOIN products as p ON p.id = oi.product_id
WHERE o.status IN('paid', 'shipped')
GROUP BY p.id
ORDER BY total_amount DESC
LIMIT 3;
----------------------------------------------------------------------------------------------------
-- #5 WITH (CTE)
-- ##5-1   直近30日（例：'2025-07-01'以降など任意）にpaid/shippedのみを集計対象にするCTEを作り、
--          そのCTEから「顧客別の総購入金額」を算出して上位3名を出す。
-- 定義：
--  ・2025-07-01以降を直近30日と仮定する。
--  ・上位3名の顧客ID、顧客名、総購入金額を表示させる
-- 目的：
--  ・CTE(WITH)の用法を理解する
-- 期待する結果：
--  ・2025-07-01以降で、総購入金額の多い上位3名の顧客ID、顧客名、総購入金額が表示される
WITH cte_shopping as (
    SELECT *
    FROM orders
    WHERE order_date >= '2025-07-01'
        and status IN('paid', 'shipped')
    ORDER BY order_date ASC
)
SELECT c.id,
    c.name,
    sum(oi.quantity * oi.unit_price) as total_amount
FROM cte_shopping s
    JOIN customers as c ON c.id = s.customer_id
    JOIN order_items as oi ON oi.order_id = s.id
GROUP BY c.id
ORDER BY total_amount DESC,
    c.id ASC
LIMIT 3;
----【レビュー】----
--1. （WITH）：CTEはそのままでは順序を保証しません。ORDER BY は外側（最終SELECT）にのみ意味があります。
--2. （WITH）：SELECTは使う列だけに絞るべき。読みやすさ・最適化の観点。
--3. （WHERE）：>= '2025-07-01' だけだと「30日」ではなく「7/1以降すべて」。厳密に30日なら < '2025-08-01' を併記。
--4. （GROUP BY）：GROUP BY c.id のままだと、PostgreSQLやOracleでは c.name が未集計でエラー。c.id, c.name を指定。
----
--レビュー後
-- WITH内は後のJOINで使用するidとcustomer_idのみを結果セットに入れる
WITH cte_shopping as (
    SELECT id,
        customer_id
    FROM orders
    WHERE order_date >= '2025-07-01'
        AND order_date < '2025-08-01'
        AND status IN('paid', 'shipped')
)
SELECT c.id,
    c.name,
    sum(oi.quantity * oi.unit_price) as total_amount
FROM cte_shopping as s
    JOIN customers as c ON c.id = s.customer_id
    JOIN order_items as oi ON oi.order_id = s.id
GROUP BY c.id,
    c.name
ORDER BY total_amount DESC,
    c.id ASC
LIMIT 3;
----------------------------------------------------------------------------------------------------
-- #6 NULLの扱い
-- ##6-1    regionがNULLの顧客の購入合計。IS NULLを使う／= NULLはダメ。
-- 定義：
--  ・地域に未記入の顧客を集めて、購入合計金額を集計する
--  ・購入を売上と仮定して支払済、もしくは発送済みのものに限定する
--  ・地域未記入の顧客を特定するため、顧客IDと顧客名を含めるようにする
-- 目的：
--  ・IS NULLの用法を理解する。
-- 期待する結果：
--  ・地域欄がNULLの顧客ID、顧客名、購入金額の合計が表示される。
SELECT c.id,
    c.name,
    sum(oi.quantity * oi.unit_price) as total_amount
FROM customers as c
    JOIN orders as o ON o.customer_id = c.id
    JOIN order_items as oi ON oi.order_id = o.id
WHERE c.region IS NULL
    AND o.status IN('paid', 'shipped')
GROUP BY c.id;
----【レビュー】----
--1. （GROUP BY）：標準SQLでは GROUP BY c.id, c.name にする必要がある。
--2. （全体）：現状のINNER JOINだと「購入がある人だけ」。購入ゼロも出したいなら LEFT JOIN + COALESCE(SUM(...),0) にする。
--          ：登録はしたものの、購入は行っていない人はJOIN(INNER JOIN)だと弾かれてしまう。LEFT JOINで残し、購入金額はコアレスで0表示に。
----
--レビュー後
SELECT c.id,
    c.name,
    COALESCE(sum(oi.quantity * oi.unit_price), 0) as total_amount
FROM customers as c
    LEFT OUTER JOIN orders as o ON o.customer_id = c.id
    LEFT OUTER JOIN order_items as oi ON oi.order_id = o.id
WHERE c.region IS NULL
    AND (
        o.status IN('paid', 'shipped')
        OR o.id IS NULL
    )
GROUP BY c.id,
    c.name;
----------------------------------------------------------------------------------------------------
-- #7 インデックス効果を体感
-- SELECT * FROM orders WHERE order_date BETWEEN '2025-07-01' AND '2025-07-31' ORDER BY order_date;
-- → idx_orders_order_date が効く構造。EXPLAIN QUERY PLANで確認（SQLite）。
-- INDEXが使用されているか確認
EXPLAIN QUERY PLAN
SELECT *
FROM orders
WHERE order_date >= '2025-07-01'
    AND order_date < '2025-08-01'
ORDER BY order_date;
--INDEXが使用されていることは確認できたが、実際に短縮できているかを知りたい
EXPLAIN ANALYZE SELECT *
FROM orders
WHERE order_date >= '2025-07-01'
    AND order_date < '2025-08-01'
ORDER BY order_date;
--ANALYZEは実行できなかったので、バージョンを調べてみる
SELECT sqlite_version();
--実行時点でのバーションは3.44.2
EXPLAIN QUERY PLAN SELECT 1;
--最小実行でも構文エラーになったのでターミナルでの実行に切り替える
SELECT *
FROM orders
WHERE order_date >= '2025-07-01'
    AND order_date < '2025-08-01'
ORDER BY order_date;
--インデックスありのクエリの実行時間
-- Run Time: real 0.000 user 0.000257 sys 0.000178
-- Run Time: real 0.000 user 0.000165 sys 0.000164
-- Run Time: real 0.000 user 0.000107 sys 0.000119
-- Run Time: real 0.001 user 0.000116 sys 0.000118
-- Run Time: real 0.000 user 0.000154 sys 0.000151
-- （Average）：real 0.2ms user 159.8us sys 146us
--インデックスなしのクエリの実行時間
-- Run Time: real 0.000 user 0.000125 sys 0.000128
-- Run Time: real 0.000 user 0.000162 sys 0.000167
-- Run Time: real 0.001 user 0.000149 sys 0.000174
-- Run Time: real 0.000 user 0.000121 sys 0.000126
-- Run Time: real 0.000 user 0.000130 sys 0.000116
-- （Average）：real 0.2ms user 137.4us sys 142.2us

-- 総実行時間(real)は分解能に追いつかず、ほぼ同値の結果に
-- userの実行時間がインデックスなしのほうが短くなったのは
-- シード数が少なすぎる(12件)のでインデックスを用いた処理が
-- フルスキャンよりも時間がかかってしまったのではないかと考えられる。