# Superstore Sales Performance Analysis — SQL

## Business Problem
Same core problem as the Excel and Power BI phases of this project: understanding where sales performance is (and isn't) translating into profit across regions, categories, and customers — this time demonstrated through direct SQL querying against a relational database rather than a BI tool's visual interface.

## Objective
Set up a PostgreSQL database from the cleaned Superstore dataset and answer a structured set of business questions using SQL fundamentals through advanced techniques (subqueries, CTEs, window functions, joins), with every result cross-validated against the Excel and Power BI phases of this project.

## Database & Setup
- **Platform:** PostgreSQL 18, managed via pgAdmin 4
- **Database:** `superstore_db`
- **Table:** `superstore` (19 columns, `row_id` as primary key)
- 9,994 rows imported from the same cleaned dataset used in Excel and Power BI

**A real technical issue worth noting:** the initial import failed three times in sequence — first due to a `profit_margin` column defined too narrowly for the data's actual range (fixed by widening `NUMERIC(6,4)` to `NUMERIC(8,4)`), then due to a CSV encoding mismatch with special characters in product names, then a file-permissions restriction on PostgreSQL's server-side `COPY` command (resolved by moving the source file to a publicly-readable directory). A follow-up precision issue was also found and fixed: `sales`/`profit` columns needed `NUMERIC(12,4)` rather than `NUMERIC(10,2)` to avoid rounding-induced discrepancies with the Excel/Power BI totals. All totals now match exactly across all three tools.

## Data Quality Checks
| Check | Result |
|---|---|
| Missing values (order_id, order_date, sales, profit, customer_id) | 0 in all columns |
| Duplicate row_id | 0 (enforced by primary key constraint) |
| Category/Region/Sub-Category consistency | No typos or inconsistent casing found |
| Date range | 2014-01-01 to 2017-12-31, as expected |

## Business Questions

### 1. What is total revenue and profit?
```sql
SELECT SUM(sales) AS total_revenue, SUM(profit) AS total_profit
FROM superstore;
```
**Result:** $2,297,200.86 revenue / $286,397.02 profit. Matches Excel and Power BI exactly.

### 2. What are monthly sales trends?
```sql
SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS monthly_sales
FROM superstore
GROUP BY month
ORDER BY month;
```
**Interpretation:** Consistent seasonal pattern with sales rising toward November/December each year, matching the trend visualized in both the Excel and Power BI dashboards.

### 3. Which products generate the most revenue?
```sql
SELECT product_name, SUM(sales) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;
```
**Interpretation:** Top 10 list matches the Power BI "Top 10 Products" visual exactly, led by the Canon imageCLASS copier.

### 4. Which regions generate the most sales?
```sql
SELECT region, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;
```
**Interpretation:** West leads on both sales and profit; South trails on both — consistent across every phase of this project.

### 5. Which customers contribute the most revenue?
```sql
SELECT customer_id, SUM(sales) AS total_sales
FROM superstore
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;
```
**Interpretation:** Same 10 customer IDs as identified in Excel and Power BI, in the same order.

### 6. What is the average order value?
```sql
SELECT SUM(sales) / COUNT(DISTINCT order_id) AS avg_order_value
FROM superstore;
```
**Result:** ~$458.61, matching the Excel/Power BI figure exactly. SQL's built-in `COUNT(DISTINCT ...)` handles the multiple-line-items-per-order problem far more simply than Excel's array formula equivalent.

### 7. Which products have above-average profit margin? *(Subquery)*
```sql
SELECT product_name, profit_margin
FROM superstore
WHERE profit_margin > (SELECT AVG(profit_margin) FROM superstore)
ORDER BY profit_margin DESC
LIMIT 10;
```
**Interpretation:** Highest margin product ("Easy-staple paper" at 271.48%) matches the extreme outlier identified during the original Excel data-cleaning phase.

### 8. What is month-over-month sales growth? *(CTE + Window Function)*
```sql
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS total_sales
    FROM superstore
    GROUP BY month
)
SELECT month, total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales,
    ROUND((total_sales - LAG(total_sales) OVER (ORDER BY month))
        / LAG(total_sales) OVER (ORDER BY month) * 100, 2) AS pct_change
FROM monthly_sales
ORDER BY month;
```
**Interpretation:** Early-year percentage swings (e.g. +1132% Feb→Mar 2014) are large in relative terms but reflect naturally low absolute sales volume in early months — a reminder that percentage change needs context alongside absolute figures.

### 9. Who are the top customers within each region? *(Window Function with PARTITION BY)*
```sql
SELECT region, customer_id, SUM(sales) AS customer_sales,
    RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rank_in_region
FROM superstore
GROUP BY region, customer_id
ORDER BY region, rank_in_region;
```
**Interpretation:** Surfaces regionally relevant top accounts (e.g. a #1 customer specific to Central) rather than only a single company-wide top 10 — useful for regional account management.

### 10. What is the cumulative sales trend? *(Running Total)*
```sql
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS total_sales
    FROM superstore
    GROUP BY month
)
SELECT month, total_sales,
    SUM(total_sales) OVER (ORDER BY month) AS running_total
FROM monthly_sales
ORDER BY month;
```
**Result:** Final running total (Dec 2017) = $2,297,200.86 — ties out exactly to the grand total, confirming the calculation logic.

### 11. How does actual performance compare to regional targets? *(JOIN)*
```sql
CREATE TABLE region_targets (
    region TEXT PRIMARY KEY,
    sales_target NUMERIC(12,2)
);

INSERT INTO region_targets (region, sales_target) VALUES
('Central', 550000.00), ('East', 650000.00),
('South', 450000.00), ('West', 700000.00);

SELECT s.region, SUM(s.sales) AS actual_sales, t.sales_target,
    ROUND(SUM(s.sales) - t.sales_target, 2) AS variance,
    ROUND((SUM(s.sales) / t.sales_target - 1) * 100, 2) AS pct_of_target_diff
FROM superstore s
JOIN region_targets t ON s.region = t.region
GROUP BY s.region, t.sales_target
ORDER BY variance DESC;
```
*(Note: `region_targets` uses illustrative, hypothetical figures for demonstration purposes, not real company targets.)*

**Result:** East (+4.43%) and West (+3.64%) beat target; Central (-8.87%) and South (-12.95%) fell short — South underperforming most severely, consistent with its position as the weakest region across every other metric in this project.

## Key Insights
1. West consistently outperforms on every dimension measured across Excel, Power BI, and SQL — sales, profit, margin, and now hypothetical target performance.
2. South consistently underperforms on every same dimension — this is a robust, multi-tool-validated finding, not a one-off artifact of a single analysis method.
3. Extreme individual outliers (e.g. products with -253% or +271% profit margins) exist in the data and should be understood before drawing conclusions from averages alone.

## Recommendations
- Prioritize a root-cause review of South region's underperformance, given it is the weakest performer across every metric and every tool used in this project.
- Use West's performance characteristics as a potential internal benchmark or case study for other regions.

## Tools
PostgreSQL 18, pgAdmin 4

---

