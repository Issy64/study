-- 生成AIに問題を出してもらいながらSQL操作の理解を深める
-- 使いながら理解を固めるための「短い課題」（答えは自力で出す前提）
-- 手動確認用(全部出し)
SELECT *
FROM customers
    JOIN orders ON customers.id = orders.customer_id
    JOIN order_items ON orders.id = order_items.order_id
    JOIN products ON order_items.product_id = products.id;
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
-- ##1-2   商品別合計が2,000円以上のものだけ残す（HAVINGでSUM…>= 2000）。
--【レビュー】--
--1. (HAVING)：実行順序に厳格なSQL環境ではSELECTのエイリアスをHAVINGで使えない可能性もある
--2. (ORDER BY)：結果の見やすさを整える
----
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
-- #3 DISTINCT
-- ##3-1   クーポンを使ったことがある顧客の ユニークな顧客ID一覧（SELECT DISTINCT）。
--          使用クーポンの種類数（COUNT(DISTINCT coupon_code)、NULL除外に注意）。
-- #4 ORDER BY + LIMIT
-- ##4-1   注文日の新しい順トップ5件。
-- ##4-2   売上高トップ3商品（SUM(oi.quantity*oi.unit_price)を集計→降順→LIMIT）。
-- #5 WITH (CTE)
-- ##5-1   直近30日（例：'2025-07-01'以降など任意）にpaid/shippedのみを集計対象にするCTEを作り、
--          そのCTEから「顧客別の総購入金額」を算出して上位3名を出す。
-- #6 NULLの扱い
-- ##6-1    regionがNULLの顧客の購入合計。IS NULLを使う／= NULLはダメ。
-- #7 インデックス効果を体感
-- SELECT * FROM orders WHERE order_date BETWEEN '2025-07-01' AND '2025-07-31' ORDER BY order_date;
-- → idx_orders_order_date が効く構造。EXPLAIN QUERY PLANで確認（SQLite）。