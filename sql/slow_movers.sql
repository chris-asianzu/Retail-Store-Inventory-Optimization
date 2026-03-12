-- Slow-moving product identification for markdown and clearance decisions
-- Business use: free up shelf space and working capital tied in low-velocity stock
-- Products below 50% of average chain velocity are flagged for markdown review

WITH chain_avg AS (
    SELECT
        ROUND(SUM(quantity) / COUNT(DISTINCT invoice_id), 4) AS chain_avg_turnover,
        ROUND(SUM(total) / COUNT(DISTINCT invoice_id), 2) AS chain_avg_revenue_per_invoice
    FROM sales
),
product_performance AS (
    SELECT
        product_line,
        branch,
        SUM(quantity) AS total_units,
        COUNT(DISTINCT invoice_id) AS total_invoices,
        ROUND(SUM(quantity) / COUNT(DISTINCT invoice_id), 4) AS turnover_ratio,
        ROUND(SUM(total), 2) AS total_revenue,
        ROUND(AVG(total), 2) AS avg_transaction_value
    FROM sales
    GROUP BY product_line, branch
)
SELECT
    pp.product_line,
    pp.branch,
    pp.total_units,
    pp.total_invoices,
    pp.turnover_ratio,
    pp.total_revenue,
    pp.avg_transaction_value,
    ca.chain_avg_turnover,
    ROUND((pp.turnover_ratio / ca.chain_avg_turnover) * 100, 1) AS pct_of_chain_avg,
    CASE
        WHEN pp.turnover_ratio < ca.chain_avg_turnover * 0.5 
            THEN 'SLOW MOVER — markdown or clearance recommended'
        WHEN pp.turnover_ratio < ca.chain_avg_turnover * 0.75 
            THEN 'BELOW AVERAGE — monitor and consider promotion'
        ELSE 'HEALTHY — no action required'
    END AS inventory_action
FROM product_performance pp
CROSS JOIN chain_avg ca
ORDER BY pp.turnover_ratio ASC;