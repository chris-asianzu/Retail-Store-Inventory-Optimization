-- Recommended reorder thresholds using demand x lead time model
-- Business use: set minimum stock levels to prevent revenue loss from stockouts
-- Assumes 3-day supplier lead time (adjust lead_time_days as needed)
-- Formula: reorder point = (avg daily demand x lead time) + safety stock buffer

WITH daily_demand AS (
    SELECT
        product_line,
        SUM(quantity) AS total_units,
        COUNT(DISTINCT sale_date) AS active_days,
        ROUND(SUM(quantity) / COUNT(DISTINCT sale_date), 2) AS avg_daily_demand,
        ROUND(SUM(total) / COUNT(DISTINCT sale_date), 2) AS avg_daily_revenue
    FROM sales
    GROUP BY product_line
),
thresholds AS (
    SELECT
        product_line,
        total_units,
        active_days,
        avg_daily_demand,
        avg_daily_revenue,
        3 AS lead_time_days,
        ROUND(avg_daily_demand * 0.2, 2) AS safety_stock,
        ROUND((avg_daily_demand * 3) + (avg_daily_demand * 0.2), 2) AS reorder_point,
        ROUND(avg_daily_demand * 7, 2) AS recommended_order_qty
    FROM daily_demand
)
SELECT
    product_line,
    avg_daily_demand,
    avg_daily_revenue,
    lead_time_days,
    safety_stock,
    reorder_point,
    recommended_order_qty,
    CASE
        WHEN avg_daily_demand >= 5 THEN 'CRITICAL — reorder immediately when stock hits threshold'
        WHEN avg_daily_demand >= 3 THEN 'MODERATE — monitor weekly'
        ELSE 'LOW — monthly review sufficient'
    END AS reorder_urgency
FROM thresholds
ORDER BY avg_daily_demand DESC;