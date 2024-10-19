SELECT 
    *
FROM {{ref("order_items_stg")}}
WHERE item_count <= 0 AND price <= 0 AND freight_value <= 0