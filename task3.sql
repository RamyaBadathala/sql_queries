create database ramya;

use ramya;

CREATE TABLE `olist_customers_dataset` (
    customer_id VARCHAR(255),
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix INT,
    customer_city  VARCHAR(255),
	customer_state VARCHAR(255)
);

CREATE TABLE `olist_geolocation_dataset` (
    `geolocation_zip_code_prefix` INT,
    `geolocation_lat` FLOAT,
    `geolocation_lng` FLOAT,
    `geolocation_city` VARCHAR(255),
    `geolocation_state` VARCHAR(255)
);

CREATE TABLE `olist_order_items_dataset` (
    `order_id` VARCHAR(255),
    `order_item_id` INT,
    `product_id` VARCHAR(255),
    `seller_id` VARCHAR(255),
    `shipping_limit_date` VARCHAR(255),
    `price` FLOAT,
    `freight_value` FLOAT
);

CREATE TABLE `olist_order_payments_dataset` (
    `order_id` VARCHAR(255),
    `payment_sequential` INT,
    `payment_type` VARCHAR(255),
    `payment_installments` INT,
    `payment_value` FLOAT
);

CREATE TABLE `olist_order_reviews_dataset` (
    `review_id` VARCHAR(255),
    `order_id` VARCHAR(255),
    `review_score` INT,
    `review_comment_title` VARCHAR(255),
    `review_comment_message` VARCHAR(255),
    `review_creation_date` VARCHAR(255),
    `review_answer_timestamp` VARCHAR(255)
);

CREATE TABLE `olist_orders_dataset` (
    `order_id` VARCHAR(255),
    `customer_id` VARCHAR(255),
    `order_status` VARCHAR(255),
    `order_purchase_timestamp` VARCHAR(255),
    `order_approved_at` VARCHAR(255),
    `order_delivered_carrier_date` VARCHAR(255),
    `order_delivered_customer_date` VARCHAR(255),
    `order_estimated_delivery_date` VARCHAR(255)
);

CREATE TABLE `olist_products_dataset` (
    `product_id` VARCHAR(255),
    `product_category_name` VARCHAR(255),
    `product_name_lenght` FLOAT,
    `product_description_lenght` FLOAT,
    `product_photos_qty` FLOAT,
    `product_weight_g` FLOAT,
    `product_length_cm` FLOAT,
    `product_height_cm` FLOAT,
    `product_width_cm` FLOAT
);

CREATE TABLE `olist_sellers_dataset` (
    `seller_id` VARCHAR(255),
    `seller_zip_code_prefix` INT,
    `seller_city` VARCHAR(255),
    `seller_state` VARCHAR(255)
);

CREATE TABLE `product_category_name_translation` (
    `product_category_name` VARCHAR(255),
    `product_category_name_english` VARCHAR(255)
);

INSERT INTO `olist_customers_dataset` (
    customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
) VALUES
('c1a0c1', 'u123456', 12345, 'Sao Paulo', 'SP'),
('c1a0c2', 'u123457', 23456, 'Rio de Janeiro', 'RJ');

INSERT INTO `olist_geolocation_dataset` (
    geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state
) VALUES
(12345, -23.5505, -46.6333, 'Sao Paulo', 'SP'),
(23456, -22.9068, -43.1729, 'Rio de Janeiro', 'RJ');

INSERT INTO `olist_order_items_dataset` (
    order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value
) VALUES
('o1001', 1, 'p001', 's001', '2021-01-10 10:00:00', 100.00, 15.00),
('o1002', 1, 'p002', 's002', '2021-01-11 11:00:00', 200.00, 25.00);

INSERT INTO `olist_order_payments_dataset` (
    order_id, payment_sequential, payment_type, payment_installments, payment_value
) VALUES
('o1001', 1, 'credit_card', 2, 115.00),
('o1002', 1, 'boleto', 1, 225.00);

INSERT INTO `olist_order_reviews_dataset` (
    review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp
) VALUES
('r1001', 'o1001', 5, 'Great!', 'Really loved it.', '2021-01-15', '2021-01-16 10:00:00'),
('r1002', 'o1002', 3, 'Okay', 'Expected better.', '2021-01-16', '2021-01-17 11:00:00');

INSERT INTO `olist_orders_dataset` (
    order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at,
    order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date
) VALUES
('o1001', 'c1a0c1', 'delivered', '2021-01-09 09:00:00', '2021-01-09 10:00:00',
 '2021-01-10', '2021-01-13', '2021-01-15'),
('o1002', 'c1a0c2', 'shipped', '2021-01-10 10:30:00', '2021-01-10 11:00:00',
 '2021-01-11', NULL, '2021-01-18');
 
 INSERT INTO `olist_products_dataset` (
    product_id, product_category_name, product_name_lenght, product_description_lenght,
    product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm
) VALUES
('p001', 'eletronicos', 50, 300, 2, 1500, 20, 10, 15),
('p002', 'moveis', 60, 400, 1, 2500, 80, 50, 70);

INSERT INTO `olist_sellers_dataset` (
    seller_id, seller_zip_code_prefix, seller_city, seller_state
) VALUES
('s001', 12345, 'Sao Paulo', 'SP'),
('s002', 23456, 'Rio de Janeiro', 'RJ');

INSERT INTO `product_category_name_translation` (
    product_category_name, product_category_name_english
) VALUES
('eletronicos', 'electronics'),
('moveis', 'furniture');

-- 1. Customers from São Paulo (SP)
SELECT customer_id, customer_unique_id, customer_city, customer_state
FROM ramya.olist_customers_dataset
WHERE customer_state = 'SP'
ORDER BY customer_city
LIMIT 10;

-- 2. Top 10 Customers by Number of Orders
SELECT customer_id, COUNT(order_id) AS total_orders
FROM olist_orders_dataset
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- 3. Top 10 Cities by Order Volume
SELECT c.customer_city, COUNT(o.order_id) AS order_count
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
GROUP BY c.customer_city
ORDER BY order_count DESC
LIMIT 10;

-- 4. Average Payment Value by Type
SELECT payment_type, AVG(payment_value) AS avg_payment
FROM olist_order_payments_dataset
GROUP BY payment_type;

-- 5. Monthly Order Volume Trend
SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(order_id) AS order_count
FROM olist_orders_dataset
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY month
ORDER BY month;

---6. Top 5 Product Categories by Revenue
SELECT 
    p.product_category_name, 
    SUM(oi.price) AS total_revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 7. Top Sellers by Average Review Score
SELECT 
    s.seller_id,
    AVG(r.review_score) AS avg_review_score
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
JOIN olist_sellers_dataset s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY avg_review_score DESC
LIMIT 10;

-- 8. Freight Cost by Customer State
SELECT 
    c.customer_state,
    AVG(oi.freight_value) AS avg_freight
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_freight DESC
LIMIT 10;

CREATE VIEW vw_customer_orders AS
SELECT 
    c.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id;

CREATE VIEW vw_order_payments_summary AS
SELECT 
    p.order_id,
    SUM(p.payment_value) AS total_payment,
    COUNT(DISTINCT p.payment_type) AS payment_types_used
FROM olist_order_payments_dataset p
GROUP BY p.order_id;

CREATE VIEW vw_product_sales AS
SELECT 
    i.product_id,
    pr.product_category_name,
    pr.product_weight_g,
    i.price,
    i.freight_value,
    i.order_id
FROM olist_order_items_dataset i
JOIN olist_products_dataset pr ON i.product_id = pr.product_id;

CREATE VIEW vw_order_reviews_summary AS
SELECT 
    order_id,
    AVG(review_score) AS avg_review_score,
    COUNT(review_id) AS total_reviews
FROM olist_order_reviews_dataset
GROUP BY order_id;

CREATE VIEW vw_seller_performance AS
SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(i.order_id) AS total_orders,
    SUM(i.price + i.freight_value) AS total_revenue
FROM olist_sellers_dataset s
JOIN olist_order_items_dataset i ON s.seller_id = i.seller_id
GROUP BY s.seller_id, s.seller_city, s.seller_state;


-- Indexes for faster joins and filters
CREATE INDEX idx_customer_id ON olist_customers_dataset(customer_id);
CREATE INDEX idx_order_customer_id ON olist_orders_dataset(customer_id);
CREATE INDEX idx_order_id ON olist_orders_dataset(order_id);
CREATE INDEX idx_payment_order_id ON olist_order_payments_dataset(order_id);
CREATE INDEX idx_review_order_id ON olist_order_reviews_dataset(order_id);
CREATE INDEX idx_order_item_product_id ON olist_order_items_dataset(product_id);
CREATE INDEX idx_order_item_order_id ON olist_order_items_dataset(order_id);
CREATE INDEX idx_order_item_seller_id ON olist_order_items_dataset(seller_id);
CREATE INDEX idx_product_product_id ON olist_products_dataset(product_id);
CREATE INDEX idx_seller_seller_id ON olist_sellers_dataset(seller_id);






