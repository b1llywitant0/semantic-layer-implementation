{{
  config(
	post_hook=[
      "CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON {{ this }} (customer_id)"
    ]
  )
}}

SELECT 
	o.order_id,
	o.customer_id,
	o.order_status,
	o.order_purchase_timestamp,
	o.order_delivered_customer_date,
	o.order_estimated_delivery_date 
FROM orders o