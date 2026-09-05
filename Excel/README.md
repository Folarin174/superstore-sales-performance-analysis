# Superstore Sales Performance Analysis — Excel

## Business Problem
A retail company operating across four US regions and three product categories needed visibility into sales performance, profitability, and regional trends to make better business decisions — without requiring stakeholders to open a database or a BI tool to get answers.

## Objective
Build a professional, single-screen Excel dashboard that summarizes sales, profit, and regional/category performance using PivotTables, live KPI formulas, and interactive slicers — accessible to any stakeholder with just Excel.

## Dataset
- **Source:** Sample Superstore dataset (9,994 transactions, 2014–2017)
- **Fields used:** Order/Ship dates, Region, Category, Sub Category, Product Name, Customer ID, Sales, Profit, Quantity, Discount
- Same cleaned dataset used across the Excel, Power BI, and SQL phases of this project, ensuring one consistent story across all three tools.

## Tools
Microsoft Excel, Power Query, PivotTables, PivotCharts

## Data Preparation
- Diagnosed the dataset before touching it: verified 9,995 rows × 19 columns, checked for missing values (none found), verified date columns were true date type (not text), and identified a real business signal early — profit values ranging from -$6,599.98 to $8,399.98, indicating discount-driven losses worth investigating later.
- Cleaned via Power Query: enforced correct data types on every column (dates, currency, whole numbers, text), renamed columns for consistency (e.g. "Sub-Category" → "Sub Category"), and added a row-level **Profit Margin** calculated column (Profit ÷ Sales).
- Converted the cleaned range into a named Excel Table (`tblSuperstore`) to support structured formula references and reliable PivotTable refreshing.

## Exploratory Analysis & KPIs
Built live formulas (not hardcoded values) for the five core KPIs, each referencing the Table directly so they update automatically if the underlying data changes:

| KPI | Value | Formula Approach |
|---|---|---|
| Total Sales | $2,297,200.86 | `SUM(tblSuperstore[Sales])` |
| Total Profit | $286,397.02 | `SUM(tblSuperstore[Profit])` |
| Total Quantity | 37,873 | `SUM(tblSuperstore[Quantity])` |
| Average Order Value | $458.61 | Sales ÷ distinct Order ID count (via `SUMPRODUCT`/`COUNTIF`, correcting for multiple line items per order) |
| Overall Profit Margin | 12.5% | Total Profit ÷ Total Sales |

Supporting PivotTables were built for Region, Category, Monthly/Yearly trend, and Top 10 Customers — each independently validated against a fresh manual calculation of the raw data.

## Dashboard Design
Single-page dashboard featuring:
- 5 color-coded KPI cards across the top, each linked live to the EDA sheet
- Monthly Sales Trend (line chart)
- Sales & Profit by Region (clustered column chart)
- Sales by Category (horizontal bar chart)
- Top 10 Customers by Sales (horizontal bar chart)
- Interactive slicers (Region) connected to the underlying PivotTables/PivotCharts via Report Connections

## Dashboard QA
Every PivotTable was checked for and cleared of Grand Total rows and blank rows bleeding into chart ranges (a common but easy-to-miss PivotChart pitfall). A live data-refresh test (temporarily changing a Sales value and confirming the KPI cards and charts updated correctly) confirmed the dashboard is genuinely dynamic, not a static snapshot. During this process, a real bug was found and fixed: a stale PivotTable source range left over from an earlier, wider dataset version was causing Refresh errors — resolved by repointing all PivotTables to the `tblSuperstore` Table directly.

## Key Insights
1. **West and South sit at opposite ends on every metric.** West leads on sales ($725,458), profit ($101,430), and margin (14.0%); South trails on all three (margin: 8.9%) — South's underperformance is a genuine efficiency gap, not just a smaller regional footprint.
2. **Category profitability doesn't track category revenue.** Technology generates the most sales ($836,154) but has a comparatively thin margin (7.4%); Office Supplies is the smallest category by revenue ($719,047) but the most profitable by far (24.4% margin).
3. **Losses are concentrated in specific products, not spread evenly.** Bookcases is the only sub-category with negative overall profit, consistent with the extreme individual loss-making transactions flagged during initial data diagnostics.

## Recommendations
- Investigate what differentiates West's regional operations from South's (discount practices, fulfillment costs, product mix) to see if West's approach can be replicated.
- Reassess Technology's discount and pricing strategy given its high revenue but thin margin.
- Review discounting policy specifically on Bookcases and related Furniture products, where losses are concentrated.

