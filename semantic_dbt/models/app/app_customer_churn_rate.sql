WITH
userid AS (
	SELECT 
		DISTINCT customer_unique_id
	FROM {{ref("unique_customers")}}
),
period AS (
	SELECT 
	    DISTINCT order_year, order_month 
	FROM {{ref("mapping")}}
),
cross_joined AS (
    SELECT * 
    FROM userid 
    CROSS JOIN period
),
joined AS (
    SELECT 
    	c.customer_unique_id,
    	c.order_year AS order_y, 
    	c.order_month AS sort_m, 
    	m.order_year AS active_y, 
    	m.order_month AS active_m
    FROM cross_joined c
    LEFT JOIN {{ref("mapping")}} m 
    	ON c.customer_unique_id = m.customer_unique_id 
    	AND c.order_month = m.order_month
    	AND c.order_year = m.order_year
),
record AS (
    SELECT *,
    	LEAD(active_y) OVER (PARTITION BY customer_unique_id ORDER BY order_y, sort_m) AS next_y,
    	LEAD(active_m) OVER (PARTITION BY customer_unique_id ORDER BY order_y, sort_m) AS next_m
    FROM joined
),
filtering AS (
    SELECT 
    	customer_unique_id, 
    	order_y, 
    	sort_m, 
    	active_y, 
    	active_m, 
    	next_y,
    	next_m FROM record
    WHERE active_m IS NOT NULL
    ORDER BY customer_unique_id, active_y, active_m
),
active AS (
    SELECT 
    	order_y,
    	sort_m, 
    	COUNT(DISTINCT(customer_unique_id)) AS active 
    FROM filtering
    WHERE active_m IS NOT NULL
    GROUP BY order_y, sort_m
    ORDER BY order_y, sort_m
),
churned AS (
    SELECT
        active_y,
        active_m, 
        COUNT(DISTINCT(customer_unique_id)) AS churned
    FROM filtering
    WHERE next_m IS NULL
    GROUP BY active_y, active_m
    ORDER BY active_y, 	active_m
)
SELECT
	a.order_y AS year,
    a.sort_m AS month,
    COALESCE(c.churned, 0) AS churned_customers,
    COALESCE(a.active, 0) AS total_active_customers,
    CASE
        WHEN COALESCE(a.active, 0) = 0 THEN 0
        ELSE COALESCE(c.churned, 0) * 100.0 / COALESCE(a.active, 0)
    END AS churn_rate
FROM active a
LEFT JOIN churned c
ON a.order_y = c.active_y AND a.sort_m = c.active_m
ORDER BY year, month