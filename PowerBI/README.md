# Superstore Sales Performance Analysis — Power BI

## Business Problem
A retail company operating across four US regions and three product categories needed visibility into where its sales performance was translating into profit, and where it wasn't — going beyond raw revenue figures to answer *which parts of the business are actually efficient*.

## Objective
Build an interactive, multi-page Power BI report that lets stakeholders explore sales, profit, and margin performance by region, category, product, and customer — with live filtering rather than static snapshots.

## Dataset
- **Source:** Sample Superstore dataset (9,994 transactions, 2014–2017)
- **Fields used:** Order/Ship dates, Region, Category, Sub Category, Product Name, Customer ID, Sales, Profit, Quantity, Discount
- Same cleaned dataset used across the Excel, Power BI, and SQL phases of this project, ensuring one consistent story across all three tools.

## Tools
Power BI Desktop, Power Query, DAX, Excel (as the cleaned data source)

## Data Preparation
- Imported the cleaned Excel Table (`tblSuperstore`) directly, carrying over all cleaning and type work already validated in the Excel phase (verified date types, currency/percentage formats, no missing values or duplicates).
- Verified all column data types on import (dates, decimals, whole numbers, text) as a second checkpoint.

## Data Modeling
- Built a dedicated `DateTable` using `CALENDAR()` spanning the exact date range of the transaction data, with Year, Quarter, Month Number, and Month Name columns — enabling proper time-based analysis and chart axis grouping.
- Created a one-to-many relationship between `DateTable[Date]` and `tblSuperstore[Order Date]`, forming a simple, correct star-schema-style model (fact table + date dimension).

## DAX Measures
| Measure | Formula | Purpose |
|---|---|---|
| Total Sales | `SUM(tblSuperstore[Sales])` | Core revenue KPI |
| Total Profit | `SUM(tblSuperstore[Profit])` | Core profitability KPI |
| Total Quantity | `SUM(tblSuperstore[Quantity])` | Volume KPI |
| Overall Profit Margin | `DIVIDE([Total Profit], [Total Sales], 0)` | Blended profitability rate, safe against divide-by-zero |
| Average Order Value | `DIVIDE([Total Sales], DISTINCTCOUNT(tblSuperstore[Order ID]), 0)` | True per-order value, correcting for multiple line items per order |

All five measures were validated against the equivalent figures independently calculated in the Excel phase of this project, with an exact match.

## Dashboard Design (3 Pages)
- **Page 1 — Executive Overview:** 5 KPI cards, monthly sales trend, sales & profit by region, sales by category, top 10 products by sales.
- **Page 2 — Product Analysis:** bottom 10 products by profit, category trend over time, category summary table, sub-category profit breakdown.
- **Page 3 — Customer/Regional Analysis:** region performance table (sorted by margin), top 10 customers by sales, interactive region slicer connected across all visuals on the page.

## Key Insights
1. **West leads on every metric, South trails on every metric.** West: $725,458 sales / $101,430 profit / 14.0% margin. South: $391,722 sales / $34,953 profit / 8.9% margin. South's underperformance isn't purely a size issue — it converts sales to profit less efficiently than every other region.
2. **Technology drives the most revenue but is not the most efficient category.** Technology: $836,154 sales at 7.4% margin. Office Supplies: $719,047 sales — the smallest category by revenue — but a 24.4% margin, nearly 3.5x more efficient than Technology.
3. **Losses are concentrated, not spread evenly.** Bookcases was the only sub-category with negative overall profit (-$613.56), and several Furniture-related products appear among the bottom 10 by profit — pointing to a specific, addressable problem area rather than a business-wide issue.

## Recommendations
- Investigate what operational or pricing factors differentiate West from South (fulfillment cost, regional discount practices, product mix) and evaluate whether West's approach can be replicated.
- Reassess Technology's discounting and cost structure given its high revenue but comparatively thin margin; consider whether Office Supplies' pricing approach offers a transferable lesson.
- Review discount policy specifically on Bookcases and related Furniture SKUs, where losses are concentrated — consider a discount cap or supplier cost review for this specific product line.
