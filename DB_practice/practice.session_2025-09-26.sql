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
SELECT products.name,
    sum(order_items.quantity * order_items.unit_price)
FROM customers
    JOIN orders ON customers.id = orders.customer_id
    JOIN order_items ON orders.id = order_items.order_id
    JOIN products ON order_items.product_id = products.id
WHERE region = "east"
GROUP BY products.name;
-- ##1-2   商品別合計が2,000円以上のものだけ残す（HAVINGでSUM…>= 2000）。
SELECT products.name,
    sum(order_items.quantity * order_items.unit_price) as s
FROM customers
    JOIN orders ON customers.id = orders.customer_id
    JOIN order_items ON orders.id = order_items.order_id
    JOIN products ON order_items.product_id = products.id
WHERE region = "east"
GROUP BY products.name
HAVING s >= 2000;
-- #2 GROUP BY 複数キー
-- ##2-1   product.category × customers.region ごとの売上合計と件数。
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