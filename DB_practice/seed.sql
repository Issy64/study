BEGIN IMMEDIATE;
-- ===== シード =====
INSERT INTO customers(id, name, email, region, joined_at) VALUES
(1,'Alice','alice@example.com','east','2025-01-10'),
(2,'Bob',  'bob@example.com',  'west','2025-02-03'),
(3,'Cathy','cathy@example.com','east','2025-03-21'),
(4,'Dan',  'dan@example.com',  NULL,  '2025-03-25'),
(5,'Eve',  'eve@example.com',  'north','2025-04-02'),
(6,'Fred', NULL,               'west','2025-04-18');

INSERT INTO products(id, name, category, price) VALUES
(1,'Coffee Beans 250g','drink',900),
(2,'Green Tea 100g',   'drink',700),
(3,'Protein Bar',      'food', 250),
(4,'Pasta 500g',       'food', 380),
(5,'Water Bottle',     'gear', 1200),
(6,'T-Shirt',          'gear', 1800),
(7,'Olive Oil 250ml',  'food', 800),
(8,'Espresso Cup',     'gear', 600);

INSERT INTO orders(id, customer_id, order_date, status, coupon_code) VALUES
(101,1,'2025-06-01','paid',    NULL),
(102,1,'2025-06-15','shipped', 'SAVE10'),
(103,2,'2025-06-20','paid',    NULL),
(104,3,'2025-07-02','cancelled',NULL),
(105,3,'2025-07-05','paid',    'SUMMER5'),
(106,4,'2025-07-10','paid',    NULL),
(107,5,'2025-07-15','shipped', NULL),
(108,6,'2025-07-18','paid',    'SAVE10'),
(109,6,'2025-07-25','paid',    NULL),
(110,2,'2025-08-01','new',     NULL),
(111,1,'2025-08-03','paid',    NULL),
(112,5,'2025-08-12','shipped', 'VIP15');

INSERT INTO order_items(order_id, product_id, quantity, unit_price) VALUES
-- 101 Alice
(101,1,1,900),
(101,3,4,250),
(101,5,1,1200),
-- 102 Alice
(102,2,2,700),
(102,8,2,600),
-- 103 Bob
(103,4,3,380),
(103,7,1,800),
-- 104 Cathy (cancelledでも明細はあるケースを再現)
(104,6,1,1800),
-- 105 Cathy
(105,1,2,900),
(105,3,2,250),
(105,5,1,1200),
-- 106 Dan (region=NULLの顧客)
(106,2,1,700),
(106,4,2,380),
-- 107 Eve
(107,7,2,800),
(107,5,1,1200),
-- 108 Fred
(108,1,1,900),
(108,8,4,600),
-- 109 Fred
(109,3,6,250),
-- 110 Bob (new=未確定受注)
(110,6,1,1800),
-- 111 Alice
(111,1,1,900),
(111,4,1,380),
(111,7,1,800),
-- 112 Eve
(112,2,3,700),
(112,5,1,1200);

-- ===== 代表的なインデックス（演習用に最小限） =====
-- WHEREやORDER BYで頻出の列に付与
-- CREATE INDEX idx_orders_order_date      ON orders(order_date);
-- CREATE INDEX idx_orders_customer_id     ON orders(customer_id);
-- CREATE INDEX idx_products_category      ON products(category);
-- CREATE INDEX idx_customers_region       ON customers(region);
-- CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- よくある複合条件用（範囲＋並べ替え）
-- CREATE INDEX idx_orders_cust_date ON orders(customer_id, order_date);
COMMIT;