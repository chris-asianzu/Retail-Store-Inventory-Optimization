# Retail Inventory & Sales Optimization

**Consulting case study analyzing product demand velocity, inventory 
turnover, and reorder threshold modeling for a three-branch 
supermarket chain across Q1 2019.**

---

## Business Problem

Retail stores lose 12-18% of potential revenue annually from stockouts 
and overstock in high-velocity product categories. Without structured 
demand analysis, inventory decisions are made reactively — resulting in 
missed sales when top products run out and tied-up working capital in 
slow-moving stock.

This analysis identifies which product categories drive the most demand, 
which branches cycle inventory most efficiently, and what reorder 
thresholds should be set to prevent revenue loss from stockouts in 
high-velocity categories.

---

## Dataset

| Property | Detail |
|----------|--------|
| Source | Supermarket Sales Dataset |
| Transactions | 1,000 invoices |
| Branches | 3 (A, B, C) across Mandalay, Naypyitaw, Yangon |
| Date Range | January – March 2019 |
| Product Lines | 6 categories |
| Key Fields | branch, product_line, quantity, unit_price, total, sale_date |

---

## Key Findings

**1. Food & Beverages is the highest-velocity category — and the most 
at risk of stockout**
Food and Beverages generates $56,144.96 in total revenue — the highest 
of all 6 product lines — with Branch C alone contributing $23,766.88. 
At its sales velocity, any disruption to stock replenishment directly 
threatens the chain's top revenue line.

**2. Branch C leads on inventory turnover at 5.58 — but the gap is narrow**
Branch C cycles inventory 5.58 times per invoice versus 5.47 for Branch A. 
The 0.11 gap signals that Branch A and B have room to improve stock 
cycling efficiency by replicating Branch C's product mix, particularly 
in Food & Beverages where Branch A generates $6,600 less than Branch C 
in the same category.

**3. Health & Beauty is the chain's slow mover — $6,951 below the top 
category**
Health & Beauty generates $49,193.84 — the weakest of all 6 product 
lines and $6,951 below Food & Beverages. Except in Branch B where it 
performs strongly at $19,980, this category is tying up shelf space 
and working capital that could be reallocated to faster-moving stock.

---

## Analysis Method

| SQL File | What It Calculates |
|----------|--------------------|
| `product_velocity.sql` | Units sold per day by product line — demand velocity tier |
| `inventory_turnover.sql` | Turnover ratio per product line per branch with ranking |
| `reorder_threshold.sql` | Recommended reorder points using avg daily demand × lead time |
| `slow_movers.sql` | Products below 50% of chain average velocity flagged for markdown |
| `supermarket_sales.sql` | Branch performance, revenue by product, window function ranking |

---

## Business Recommendations

**1. Set reorder thresholds for Food & Beverages based on daily demand 
model**
Using the reorder threshold model (avg daily demand × 3-day lead time + 
20% safety stock buffer), Food & Beverages requires a reorder point of 
approximately 15-18 units per branch per day. Implementing automated 
reorder triggers at this threshold prevents stockouts in the chain's 
top revenue category.

**2. Replicate Branch C's Food & Beverages stock mix in Branches A and B**
Branch C generates $6,600 more in F&B revenue than Branch A despite 
similar overall sales volumes. Aligning A and B's F&B inventory levels 
and shelf allocation to Branch C's approach is estimated to recover 
$6,000–$9,000 per branch annually.

**3. Mark down Health & Beauty in Branches A and C — reallocate shelf 
space**
H&B underperforms in Branches A and C while performing strongly in 
Branch B. Reducing H&B stock in A and C by 20-30% and reallocating 
that shelf space to Food & Beverages or Sports & Travel frees working 
capital and increases revenue per square foot.

---

## Expected Impact

| Action | Estimated Impact |
|--------|-----------------|
| F&B reorder thresholds implemented | 9% increase in revenue availability for top category |
| Branch C product mix replicated in A and B | +$6,000–$9,000 per branch annually |
| H&B markdown in Branches A and C | 15-20% reduction in slow-moving stock |
| Combined effect | Estimated 8-12% improvement in overall inventory efficiency |

---

## Tech Stack

| Tool | Use |
|------|-----|
| MySQL | Database, schema, all queries |
| Window Functions | Turnover ranking with DENSE_RANK() |
| Demand Modeling | Reorder point formula: (avg daily demand × lead time) + safety stock |
| Aggregation & JOINs | Revenue, velocity, branch performance analysis |

---

## Project Structure
```
retail-inventory-optimization/
│
├── dataset/
│   └── supermarket_sales.csv
│
├── sql/
│   ├── supermarket_sales.sql
│   ├── product_velocity.sql
│   ├── inventory_turnover.sql
│   ├── reorder_threshold.sql
│   └── slow_movers.sql
│
├── results/
│   └── (CSV output files from each query)
│
└── report/
    └── Retail_Inventory_CaseStudy.pdf
```

---

## About

Built as a consulting-style case study demonstrating SQL-based inventory 
and demand analysis. Covers product velocity modeling, inventory turnover 
efficiency, reorder threshold calculation, and slow-mover identification 
using real supermarket transaction data.

Dataset: Supermarket Sales — 1,000 transactions, 3 branches, Q1 2019.