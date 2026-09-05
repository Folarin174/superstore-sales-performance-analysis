-- ============================================================
-- Superstore Sales Performance Analysis
-- Business Questions - SQL Queries
-- Database: PostgreSQL | Table: superstore
-- ============================================================

-- 1. Total revenue and profit
SELECT SUM(sales) AS total_revenue, SUM(profit) AS total_profit
FROM superstore;

-- 2. Monthly sales trend
SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS monthly_sales
FROM superstore
GROUP BY month
ORDER BY month;

-- 3. Top 10 products by revenue
SELECT product_name, SUM(sales) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- 4. Sales and profit by region
SELECT region, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;

-- 5. Top 10 customers by revenue
SELECT customer_id, SUM(sales) AS total_sales
FROM superstore
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;

-- 6. Average order value (distinct order count, not row count)
SELECT SUM(sales) / COUNT(DISTINCT order_id) AS avg_order_value
FROM superstore;

-- 7. Products with above-average profit margin (subquery)
SELECT product_name, profit_margin
FROM superstore
WHERE profit_margin > (SELECT AVG(profit_margin) FROM superstore)
ORDER BY profit_margin DESC
LIMIT 10;

-- 8. Month-over-month sales growth (CTE + LAG window function)
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS total_sales
    FROM superstore
    GROUP BY month
)
SELECT
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month))
        / LAG(total_sales) OVER (ORDER BY month) * 100, 2
    ) AS pct_change
FROM monthly_sales
ORDER BY month;

-- 9. Top customer ranking within each region (RANK + PARTITION BY)
SELECT
    region,
    customer_id,
    SUM(sales) AS customer_sales,
    RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rank_in_region
FROM superstore
GROUP BY region, customer_id
ORDER BY region, rank_in_region;

-- 10. Cumulative (running total) sales trend
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS total_sales
    FROM superstore
    GROUP BY month
)
SELECT
    month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY month) AS running_total
FROM monthly_sales
ORDER BY month;

-- 11. Actual sales vs. regional targets (JOIN)
-- Note: region_targets uses illustrative, hypothetical figures for demonstration.
DROP TABLE IF EXISTS region_targets;

CREATE TABLE region_targets (
    region TEXT PRIMARY KEY,
    sales_target NUMERIC(12,2)
);

INSERT INTO region_targets (region, sales_target) VALUES
('Central', 550000.00),
('East', 650000.00),
('South', 450000.00),
('West', 700000.00);

SELECT
    s.region,
    SUM(s.sales) AS actual_sales,
    t.sales_target,
    ROUND(SUM(s.sales) - t.sales_target, 2) AS variance,
    ROUND((SUM(s.sales) / t.sales_target - 1) * 100, 2) AS pct_of_target_diff
FROM superstore s
JOIN region_targets t ON s.region = t.region
GROUP BY s.region, t.sales_target
ORDER BY variance DESC;
