COPY closed_deals FROM '/data/olist_closed_deals_dataset.csv' DELIMITER AS ',' CSV HEADER;
SELECT * FROM closed_deals LIMIT 5;

COPY qualified_leads FROM '/data/olist_marketing_qualified_leads_dataset.csv' DELIMITER AS ',' CSV HEADER;
SELECT * FROM qualified_leads LIMIT 5;

COPY seller FROM '/data/olist_sellers_dataset.csv' DELIMITER AS ',' CSV HEADER;
SELECT * FROM seller LIMIT 5;

COPY order_items FROM '/data/olist_order_items_dataset.csv' DELIMITER AS ',' CSV HEADER;
SELECT * FROM order_items LIMIT 5;

COPY products FROM '/data/olist_products_dataset.csv' DELIMITER AS ',' CSV HEADER;
SELECT * FROM products LIMIT 5;

COPY orders FROM '/data/olist_orders_dataset.csv' DELIMITER AS ',' CSV HEADER;
SELECT * FROM orders LIMIT 5;

COPY order_payments FROM '/data/olist_order_payments_dataset.csv' DELIMITER AS ',' CSV HEADER;
SELECT * FROM order_payments LIMIT 5;

COPY order_reviews FROM '/data/olist_order_reviews_dataset.csv' DELIMITER AS ',' CSV HEADER;
SELECT * FROM order_reviews LIMIT 5;

COPY customers FROM '/data/olist_customers_dataset.csv' DELIMITER AS ',' CSV HEADER;
SELECT * FROM customers LIMIT 5;

COPY geolocation FROM '/data/olist_geolocation_dataset.csv' DELIMITER AS ',' CSV HEADER;
SELECT * FROM geolocation LIMIT 5;
