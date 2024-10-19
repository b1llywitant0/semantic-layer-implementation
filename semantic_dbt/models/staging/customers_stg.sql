{{config(
	post_hook=[
      "CREATE INDEX IF NOT EXISTS idx_customers_customer_id ON {{ this }} (customer_id)"
	]
  )
}}

SELECT 
	c.customer_id,
	c.customer_unique_id
FROM customers c