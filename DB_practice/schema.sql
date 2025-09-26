-- =========================================
-- SQLite 復習用データベース
-- 目的：FROM/WHERE/GROUP BY/HAVING/SELECT/DISTINCT/ORDER BY/LIMIT/WITH/INDEX
-- =========================================
PRAGMA foreign_keys = ON;
-- 既存を掃除
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
-- 顧客
CREATE TABLE customers(
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    region TEXT,
    -- NULLを含めてIS NULL練習
    joined_at DATE NOT NULL
);
-- 商品
CREATE TABLE products(
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    -- 'food' | 'drink' | 'gear'
    price INTEGER NOT NULL -- 現行価格（注文時はorder_items.unit_priceを参照）
);
-- 注文
CREATE TABLE orders(
    id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    status TEXT NOT NULL CHECK(
        status IN ('new', 'paid', 'shipped', 'cancelled')
    ),
    coupon_code TEXT,
    -- NULLあり（HAVING/WHEREの比較用）
    FOREIGN KEY(customer_id) REFERENCES customers(id)
);
-- 注文明細
CREATE TABLE order_items(
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK(quantity > 0),
    unit_price INTEGER NOT NULL,
    -- 注文時点の価格を固定
    PRIMARY KEY(order_id, product_id),
    FOREIGN KEY(order_id) REFERENCES orders(id),
    FOREIGN KEY(product_id) REFERENCES products(id)
);