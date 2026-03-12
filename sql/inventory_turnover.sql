-- Inventory turnover by product line and branch
-- Business use: identify which categories and locations cycle stock fastest
-- Higher turnover = faster selling = higher restock priority

SELECT
    branch,
    product_line,
    SUM(quantity) AS total_units_sold,
    COUNT(DISTINCT invoice_id) AS total_invoices,
    ROUND(SUM(quantity) / COUNT(DISTINCT invoice_id), 4) AS turnover_ratio,
    ROUND(SUM(total), 2) AS total_revenue,
    DENSE_RANK() OVER (
        PARTITION BY branch 
        ORDER BY SUM(quantity) / COUNT(DISTINCT invoice_id) DESC
    ) AS turnover_rank_in_branch
FROM sales
GROUP BY branch, product_line
ORDER BY branch, turnover_ratio DESC;