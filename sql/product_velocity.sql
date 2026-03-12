-- Product demand velocity: units sold per day by product line
-- Business use: identify high-velocity categories requiring tighter inventory control
-- Note: uses quantity sold as demand proxy (stock level data not available)

WITH date_range AS (
    SELECT 
        MIN(sale_date) AS first_sale,
        MAX(sale_date) AS last_sale,
        DATEDIFF(MAX(sale_date), MIN(sale_date)) + 1 AS total_days
    FROM sales
),
product_demand AS (
    SELECT
        product_line,
        SUM(quantity) AS total_units_sold,
        COUNT(DISTINCT invoice_id) AS total_transactions,
        SUM(total) AS total_revenue
    FROM sales
    GROUP BY product_line
)
SELECT
    pd.product_line,
    pd.total_units_sold,
    pd.total_transactions,
    pd.total_revenue,
    ROUND(pd.total_units_sold / dr.total_days, 2) AS units_per_day,
    ROUND(pd.total_revenue / dr.total_days, 2) AS revenue_per_day,
    CASE
        WHEN pd.total_units_sold / dr.total_days >= 5 THEN 'High Velocity'
        WHEN pd.total_units_sold / dr.total_days >= 3 THEN 'Medium Velocity'
        ELSE 'Low Velocity'
    END AS velocity_tier
FROM product_demand pd
CROSS JOIN date_range dr
ORDER BY units_per_day DESC;