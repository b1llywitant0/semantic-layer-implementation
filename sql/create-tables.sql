DROP TABLE IF EXISTS closed_deals;
CREATE TABLE "closed_deals" (
  "mql_id" varchar UNIQUE PRIMARY KEY NOT NULL,
  "seller_id" varchar UNIQUE NOT NULL,
  "sdr_id" varchar NOT NULL,
  "sr_id" varchar NOT NULL,
  "won_date" timestamp NOT NULL,
  "business_segment" varchar,
  "lead_type" varchar,
  "lead_behaviour_profile" varchar,
  "has_company" bool,
  "has_gtin" bool,
  "average_stock" varchar,
  "business_type" varchar,
  "declared_product_catalog_size" float,
  "declared_monthly_revenue" float
);

DROP TABLE IF EXISTS qualified_leads;
CREATE TABLE "qualified_leads" (
  "mql_id" varchar UNIQUE PRIMARY KEY NOT NULL,
  "first_contact_date" datetime NOT NULL,
  "landing_page_id" varchar NOT NULL,
  "origin" varchar
);

DROP TABLE IF EXISTS seller;
CREATE TABLE "seller" (
  "seller_id" varchar UNIQUE PRIMARY KEY NOT NULL,
  "seller_zip_code_prefix" integer NOT NULL,
  "seller_city" varchar NOT NULL,
  "seller_state" varchar NOT NULL
);

DROP TABLE IF EXISTS order_items;
CREATE TABLE "order_items" (
  "order_id" varchar PRIMARY KEY NOT NULL,
  "order_item_id" int NOT NULL,
  "product_id" varchar NOT NULL,
  "seller_id" varchar NOT NULL,
  "shipping_limit_date" timestamp NOT NULL,
  "price" float NOT NULL,
  "freight_value" float NOT NULL
);

DROP TABLE IF EXISTS products;
CREATE TABLE "products" (
  "product_id" varchar UNIQUE PRIMARY KEY NOT NULL,
  "product_category_name" varchar,
  "product_name_lenght" int,
  "product_description_lenght" int,
  "product_photo_qty" int,
  "product_weight_g" int,
  "product_length_cm" int,
  "product_height_cm" int,
  "product_width_cm" int
);

DROP TABLE IF EXISTS orders;
CREATE TABLE "orders" (
  "order_id" varchar UNIQUE PRIMARY KEY NOT NULL,
  "customer_id" varchar NOT NULL,
  "order_status" varchar NOT NULL,
  "order_purchase_timestamp" timestamp NOT NULL,
  "order_approved_at" timestamp,
  "order_delivered_carrier_date" timestamp,
  "order_delivered_customer_date" timestamp,
  "order_estimated_delivery_date" timestamp
);

DROP TABLE IF EXISTS order_payments;
CREATE TABLE "order_payments" (
  "order_id" varchar UNIQUE PRIMARY KEY NOT NULL,
  "payment_sequential" int NOT NULL,
  "payment_type" varchar NOT NULL,
  "payment_installments" int NOT NULL,
  "payment_value" float NOT NULL
);

DROP TABLE IF EXISTS order_reviews;
CREATE TABLE "order_reviews" (
  "review_id" varchar UNIQUE PRIMARY KEY NOT NULL,
  "order_id" varchar NOT NULL,
  "review_score" int NOT NULL,
  "review_comment_title" varchar,
  "review_comment_message" varchar,
  "review_creation_date" timestamp NOT NULL,
  "review_answer_timestamp" timestamp NOT NULL
);

DROP TABLE IF EXISTS customers;
CREATE TABLE "customers" (
  "customer_id" varchar NOT NULL,
  "customer_unique_id" varchar UNIQUE PRIMARY KEY NOT NULL,
  "customer_zip_code_prefix" varchar NOT NULL,
  "customer_city" varchar NOT NULL,
  "customer_state" varchar NOT NULL
);

DROP TABLE IF EXISTS geolocation;
CREATE TABLE "geolocation" (
  "geolocation_zip_code_prefix" int PRIMARY KEY NOT NULL,
  "geolocation_lat" float NOT NULL,
  "geolocation_lng" float NOT NULL,
  "geolocation_city" varchar NOT NULL,
  "geolocation_state" varchar NOT NULL
);

COMMENT ON TABLE "closed_deals" IS 'After a qualified lead fills in a form at a landing page 
he is contacted by a Sales Development Representative. 
At this step some information is checked and more 
information about the lead is gathered.
';

COMMENT ON COLUMN "closed_deals"."mql_id" IS 'marketing qualified lead id';

COMMENT ON COLUMN "closed_deals"."sdr_id" IS 'sales development representative';

COMMENT ON COLUMN "closed_deals"."sr_id" IS 'sales representative';

COMMENT ON COLUMN "closed_deals"."won_date" IS 'date the deal was closed';

COMMENT ON COLUMN "closed_deals"."has_gtin" IS 'global trade item number (barcode) of products';

COMMENT ON TABLE "qualified_leads" IS 'After a lead fills in a form at a landing page, 
a filter is made to select the ones that are qualified 
to sell their products at Olist. They are the Marketing 
Qualified Leads (MQLs).
';

COMMENT ON COLUMN "qualified_leads"."mql_id" IS 'marketing qualified lead id';

COMMENT ON TABLE "seller" IS 'This dataset includes data about the sellers that fulfilled orders made at Olist.
';

COMMENT ON TABLE "order_items" IS 'This dataset includes data about the items purchased within each order.

Example:
The order_id = 00143d0f86d6fbd9f9b38ab440ac16f5 has 3 items (same product). 
Each item has the freight calculated accordingly to its measures and weight. 
To get the total freight value for each order you just have to sum.

The total order_item value is: 21.33 * 3 = 63.99

The total freight value is: 15.10 * 3 = 45.30

The total order value (product + freight) is: 45.30 + 63.99 = 109.29
';

COMMENT ON COLUMN "order_items"."order_item_id" IS 'sequential number identifying number of items included in the same order.';

COMMENT ON TABLE "products" IS 'This dataset includes data about the products sold by Olist.
';

COMMENT ON TABLE "orders" IS 'This is the core dataset. 
From each order you might find all other information.
';

COMMENT ON COLUMN "orders"."order_delivered_carrier_date" IS 'Shows the order posting timestamp. 
When it was handled to the logistic partner.
';

COMMENT ON COLUMN "orders"."order_delivered_customer_date" IS 'Shows the actual order delivery date to the customer.
';

COMMENT ON COLUMN "orders"."order_estimated_delivery_date" IS 'Shows the estimated delivery date that was informed 
to customer at the purchase moment.
';

COMMENT ON TABLE "order_payments" IS 'This dataset includes data about the orders payment options.
';

COMMENT ON COLUMN "order_payments"."payment_sequential" IS 'A customer may pay an order with more than one payment method. 
If he/she does so, a sequence will be created.
';

COMMENT ON TABLE "order_reviews" IS 'This dataset includes data about the reviews made by the customers.
After a customer purchases the product from Olist Store a seller gets 
notified to fulfill that order. Once the customer receives the product, 
or the estimated delivery date is due, the customer gets a satisfaction 
survey by email where he can give a note for the purchase experience and 
write down some comments.
';

COMMENT ON TABLE "customers" IS 'This dataset has information about the customer and its location. 
Use it to identify unique customers in the orders dataset and to find the orders delivery location.
At our system each order is assigned to a unique customer_id. 
This means that the same customer will get different ids for different orders. 
The purpose of having a customer_unique_id on the dataset is to allow you to identify 
customers that made repurchases at the store. 
Otherwise you would find that each order had a different customer associated with.
';

COMMENT ON COLUMN "customers"."customer_id" IS 'Each order has a unique customer_id.';

COMMENT ON TABLE "geolocation" IS 'This dataset has information Brazilian zip codes and its lat/lng coordinates. 
Use it to plot maps and find distances between sellers and customers.
';

ALTER TABLE "closed_deals" ADD FOREIGN KEY ("mql_id") REFERENCES "qualified_leads" ("mql_id");

ALTER TABLE "seller" ADD FOREIGN KEY ("seller_id") REFERENCES "closed_deals" ("seller_id");

ALTER TABLE "order_items" ADD FOREIGN KEY ("seller_id") REFERENCES "closed_deals" ("seller_id");

ALTER TABLE "order_items" ADD FOREIGN KEY ("seller_id") REFERENCES "seller" ("seller_id");

ALTER TABLE "order_items" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("product_id");

ALTER TABLE "order_items" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("order_id");

ALTER TABLE "order_payments" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("order_id");

ALTER TABLE "order_reviews" ADD FOREIGN KEY ("order_id") REFERENCES "orders" ("order_id");

ALTER TABLE "orders" ADD FOREIGN KEY ("customer_id") REFERENCES "customers" ("customer_id");

ALTER TABLE "customers" ADD FOREIGN KEY ("customer_zip_code_prefix") REFERENCES "geolocation" ("geolocation_zip_code_prefix");

ALTER TABLE "seller" ADD FOREIGN KEY ("seller_zip_code_prefix") REFERENCES "geolocation" ("geolocation_zip_code_prefix");
