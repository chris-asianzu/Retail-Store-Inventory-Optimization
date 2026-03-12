# Retail Inventory Optimization

A SQL-based consulting case study analyzing branch performance, inventory efficiency, and product strategy across a three-branch supermarket chain. Built on 1,000 real transactions from Q1 2019.

## Business Problem

A supermarket chain operating three branches across Naypyitaw, Yangon, and Mandalay needed to understand why Branch C consistently outperformed Branches A and B despite serving a similar customer base — and how to replicate that advantage across the network.

## Business Questions Answered

1. Which branch drives the most revenue and why?
2. How efficiently does each branch manage inventory?
3. Which product lines generate the highest revenue?
4. Are there seasonal patterns that should drive inventory planning?

## Key Findings

| Metric | Result |
|--------|--------|
| Total Revenue (Q1 2019) | $322,967.43 |
| Top Branch | Branch C — $110,568.86 |
| Best Inventory Turnover | Branch C — 5.58x |
| Top Product Line | Food and Beverages — $56,144.96 |
| Worst February Dip | Yangon — -22.8% month-over-month |
| Health & Beauty Gap | 14.2% below top line despite competitive avg transaction value |

## Top Recommendation

Branch C's 5.58x inventory turnover vs 5.47x at Branch A represents a measurable operational gap. Replicating Branch C's reorder triggers and shelf replenishment model across the network improves capital efficiency without additional spend.

## Tech Stack

| Layer | Tool |
|-------|------|
| Database | MySQL |
| Analysis | SQL — window functions, aggregations, joins |
| Reporting | Consulting-style case study report |

## SQL Techniques Used

- `SUM()`, `COUNT()`, `GROUP BY` for revenue and transaction aggregation
- `DATE_FORMAT()` for monthly trend analysis
- `DENSE_RANK() OVER()` window function for branch ranking
- Inventory turnover ratio: `SUM(quantity) / COUNT(DISTINCT invoice_id)`
- `HAVING` clause for filtering aggregated results

## How to Run

```bash
git clone https://github.com/chris-asianzu/retail-inventory-optimization.git
```

Set up MySQL, create a database, and run `sql/supermarket_sales.sql` to create the table, load the data, and execute all analysis queries.

## About

This project was reframed as a consulting engagement to demonstrate business-oriented SQL analysis — connecting query results directly to operational decisions rather than stopping at data output.
