CREATE TABLE sales (
    invoice_id VARCHAR(50),
    branch VARCHAR(50),
    city VARCHAR(50),
    customer_type VARCHAR(50),
    gender VARCHAR(10),
    product_line VARCHAR(50),
    unit_price DECIMAL(10 , 2 ),
    quantity INT,
    tax_5_percent DECIMAL(10 , 2 ),
    total DECIMAL(10 , 2 ),
    sale_date DATE,
    sale_time TIME,
    payment VARCHAR(50),
    cogs DECIMAL(10 , 2 ),
    gross_margin_percentage DECIMAL(10 , 2 ),
    gross_income DECIMAL(10 , 2 )
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 9.0\\Uploads\\supermarket_sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    invoice_id, 
    branch, 
    city, 
    customer_type, 
    gender, 
    product_line, 
    unit_price, 
    quantity, 
    tax_5_percent, 
    total, 
    @raw_sale_date,  
    sale_time, 
    payment, 
    cogs, 
    gross_margin_percentage, 
    gross_income
)
SET 
    sale_date = STR_TO_DATE(@raw_sale_date, '%m/%d/%Y');


-- 1.1 Total Sales per Branch:
SELECT 
    branch, 
    SUM(total) AS total_sales
FROM 
    sales
GROUP BY 
    branch
ORDER BY 
    total_sales DESC;
-- This query groups the total sales by each branch to see which store performs best in terms of sales.

-- 1.2 Sales Trend Analysis per City:
SELECT 
    city, 
    SUM(total) AS total_sales, 
    DATE_FORMAT(sale_date, '%Y-%m') AS month
FROM 
    sales
GROUP BY 
    city, month
ORDER BY 
    city, month;
-- This provides monthly sales trends across different cities to spot seasonality or changes over time.

-- 1.3 Inventory Turnover Ratio (sales / inventory level)
SELECT 
    branch, 
    SUM(quantity) / COUNT(DISTINCT invoice_id) AS inventory_turnover
FROM 
    sales
GROUP BY 
    branch
ORDER BY 
    inventory_turnover DESC;
-- This shows the inventory turnover ratio by branch, indicating how frequently inventory is sold and restocked.

-- 1.4 Total Revenue Analysis by Product Line:
SELECT 
    product_line, 
    SUM(total) AS total_revenue
FROM 
    sales
GROUP BY 
    product_line
ORDER BY 
    total_revenue DESC;
-- This helps in understanding which product lines contribute most to the total revenue.


/*
2. JOIN Operations and Aggregations to Identify Trends:
The goal here is to perform joins across tables to find relationships between sales, branches, and products.
*/

-- 2.1 Sales by Product Line and Branch:
SELECT 
    s.branch, 
    s.product_line, 
    COUNT(s.invoice_id) AS total_sales,
    SUM(s.total) AS total_revenue
FROM 
    sales s
GROUP BY 
    s.branch, 
    s.product_line
ORDER BY 
    s.branch, s.product_line;
--- This joins sales data to aggregate sales by product line and branch.

-- 2.2 Top 10 Products by Total Sales:
SELECT 
    product_line, 
    SUM(total) AS total_sales
FROM 
    sales
GROUP BY 
    product_line
ORDER BY 
    total_sales DESC
LIMIT 10;
-- This identifies the top-selling products based on total sales.


/*
3. Use of Window Functions for Ranking Products by Demand:
Window functions allow you to perform calculations across a partition of rows and return results based on subsets of data.
*/
-- 3.1 Ranking Branches by Total Sales Using Window Functions:
SELECT 
    branch, 
    SUM(total) AS total_sales,
    DENSE_RANK() OVER (ORDER BY SUM(total) DESC) AS branch_rank
FROM 
    sales
GROUP BY 
    branch
ORDER BY 
    branch_rank;
-- This ranks branches by total sales using the DENSE_RANK() window function.

-- 3.2 Products by Demand without Ranking
SELECT 
    product_line,
    COUNT(*) AS total_sales_count,
    SUM(total) AS total_revenue
FROM 
    sales
GROUP BY 
    product_line
HAVING 
    COUNT(*) > 0  -- Avoiding empty groups in case there's no sales data for some lines
ORDER BY 
    total_revenue DESC;


