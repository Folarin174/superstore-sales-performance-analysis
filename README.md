# Superstore Sales Performance Analysis
### A multi-tool data analytics portfolio project — Excel · Power BI · SQL

## The Story
A retail company operating across four US regions and three product categories needed to understand where its sales performance was, and wasn't, translating into profit. Rather than treat this as three separate exercises, this project answers that one business question three times, using three different professional tools — showing the same analytical thinking applied through different technical approaches.

```
RAW DATA → DATA CLEANING → EXCEL DASHBOARD → POWER BI REPORT → SQL DATABASE → BUSINESS INSIGHTS
```

The same cleaned dataset (Sample Superstore, 9,994 transactions, 2014–2017) flows through all three tools, and every core figure — Total Sales ($2,297,200.86), Total Profit ($286,397.02), regional performance, top products, top customers — was independently cross-validated to match across all three, including catching and fixing a genuine SQL precision bug along the way.

## Why Three Tools, One Dataset
- **Excel** demonstrates foundational analysis: PivotTables, KPI formulas, and dashboard design skills every business stakeholder can open and understand immediately.
- **Power BI** demonstrates business intelligence capability: proper data modeling, DAX measures, and a multi-page interactive report with live cross-filtering.
- **SQL** demonstrates data engineering and querying fundamentals: database design, data quality validation, and business questions answered through everything from basic aggregation to window functions and joins.

A client evaluating this repo can see the same analytical judgment applied consistently across three different technical skillsets — not three disconnected assignments.

## Project Structure
```
├── excel/
│   ├── Superstore_Sales_Dashboard.xlsx
│   └── README.md
├── powerbi/
│   ├── Superstore_Sales_Dashboard.pbix
│   └── README.md
├── sql/
│   ├── business_questions.sql
│   ├── superstore_db_backup.sql
│   └── README.md
├── data/
│   ├── raw/
│   └── clean/
└── documentation/
    └── screenshots/
```

## Key Findings (Consistent Across All Three Tools)

1. **West leads on every metric; South trails on every metric.** West: $725,458 sales / $101,430 profit / 14.0% margin — the strongest region overall, not just the largest. South: $391,722 sales / $34,953 profit / 8.9% margin — its underperformance is a genuine efficiency gap, not purely a size difference. This pattern held up independently in Excel, Power BI, and a SQL JOIN against illustrative regional targets, where South also missed by the widest margin (-12.95%).

2. **Revenue and profitability don't move together.** Technology drives the most revenue ($836,154) but has one of the weakest margins (7.4%). Office Supplies is the smallest category by revenue ($719,047) but by far the most profitable (24.4% margin) — nearly 3.5x more efficient than Technology at converting sales into profit.

3. **Losses are concentrated, not spread evenly.** Bookcases is the only sub-category with negative overall profit (-$613.56), and several Furniture-related products appear among the lowest performers by profit — pointing to a specific, addressable problem rather than a company-wide issue.

## Recommendations

- Investigate what differentiates West's operations from South's (pricing, discount practices, fulfillment costs) and assess whether West's approach can be replicated.
- Reassess Technology's discount and cost structure given its high revenue but comparatively thin margin.
- Review discount policy specifically on Bookcases and related Furniture SKUs, where losses are concentrated.

## Tools Used
Microsoft Excel, Power Query, Microsoft Power BI, DAX, PostgreSQL, pgAdmin
