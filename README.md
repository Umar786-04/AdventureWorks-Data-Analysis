# 🚴 AdventureWorks Sales & Performance Analysis

An end-to-end data analytics project demonstrating data transformation, KPI modeling, and multi-platform dashboard reporting using **SQL, Excel, Power BI, and Tableau**.

---

## 🛠️ Tech Stack & Skills
* **SQL:** Relational data extraction, table unions, lookups, and calculated aggregations.
* **Microsoft Excel:** VLOOKUP/XLOOKUP, Power Query, pivot tables, and KPI modeling.
* **Power BI:** Data modeling, DAX measures, time-intelligence calculations, and interactive reporting.
* **Tableau:** Visual storytelling, multi-metric combinational charts, and geographic analysis.

---

## 📥 Project Files & Direct Downloads
* 📊 **Raw Dataset:** [Download Adventure Works Dataset.xlsx](https://raw.githubusercontent.com/Umar786-04/AdventureWorks-Data-Analysis/main/Adventure%20Works%20Dataset.xlsx)
* 📑 **Excel Model:** [Download AdventureWorks_Analysis.xlsx](https://raw.githubusercontent.com/Umar786-04/AdventureWorks-Data-Analysis/main/AdventureWorks_Analysis.xlsx)
* 📈 **Power BI Report:** [Download AdventureWorks_Analysis.pbix](https://raw.githubusercontent.com/Umar786-04/AdventureWorks-Data-Analysis/main/AdventureWorks_Analysis.pbix)
* 📉 **Tableau Workbook:** [Download AdventureWorks_Analysis.twbx](https://raw.githubusercontent.com/Umar786-04/AdventureWorks-Data-Analysis/main/AdventureWorks_Analysis.twbx)
* 🗄️ **SQL Queries:** [View SQL Script](AdventureWorks_Analysis.sql)

---

## 📋 Business Tasks & Questionnaire
The following project requirements and business tasks were completed:

0. Union of `Fact Internet sales` and `Fact internet sales new`.
1. Lookup the `ProductName` from the Product sheet to the Sales sheet.
2. Lookup `CustomerFullName` from Customer sheet and `UnitPrice` from Product sheet to Sales sheet.
3. Calculate date fields from `OrderDateKey` (Year, MonthNo, MonthFullName, Quarter, YearMonth, WeekdayNo, WeekdayName, FinancialMonth, FinancialQuarter).
4. Calculate `Sales Amount` using Unit Price, Order Quantity, and Unit Discount.
5. Calculate `Production Cost` using Unit Cost and Order Quantity.
6. Calculate `Profit` (`Sales Amount - Production Cost`).
7. Create a Pivot table for month-wise sales with a dynamic Year filter.
8. Create a Bar chart showing year-wise sales.
9. Create a Line chart showing month-wise sales.
10. Create a Pie chart showing quarter-wise sales.
11. Create a combinational chart (Bar & Line) showing Sales Amount and Production Cost together.
12. Build additional KPI charts for performance by Products, Customers, and Region.
13. Create executive dashboards based on business requirements.

---

## ⚙️ How Tasks Were Solved (Implementation Summary)

### 1. Data Integration & Enrichment (Tasks 0 – 2)
* Combined `FactInternetSales` and `FactInternetSalesNew` to create a unified transaction fact table.
* Used SQL joins and Excel lookup functions (`XLOOKUP` / `VLOOKUP`) to map product names, customer names, and pricing directly into the sales model.

### 2. Time Intelligence & Date Master (Task 3)
* Converted `OrderDateKey` into a true Date format.
* Derived calendar and fiscal dimensions (`Year`, `MonthNo`, `MonthFullName`, `Quarter`, `YearMonth`, `Weekday`, `FinancialMonth`, `FinancialQuarter`) to support monthly and quarterly trend analysis.

### 3. Financial Metrics & KPI Calculations (Tasks 4 – 6)
* **Sales Amount:** `[Unit Price] * [Order Quantity] * (1 - [Unit Discount])`
* **Production Cost:** `[Unit Cost] * [Order Quantity]`
* **Gross Profit:** `[Sales Amount] - [Production Cost]`

### 4. Visualizations & Reporting (Tasks 7 – 13)
* Built comparative multi-axis combo charts tracking margin between revenue and production cost.
* Summarized performance across 3 distinct dashboards (Excel, Power BI, and Tableau) broken down by customer segment, product category, and geographic territory.

---

## 📊 Dashboards & Visual Deliverables

### 1. Power BI Executive Dashboard
![Power BI Dashboard](Power%20BI%20Dashboard.png)

---

### 2. Tableau Performance Dashboard
![Tableau Dashboard](Tableau%20Dashboard.png)

---

### 3. Excel Executive Dashboard
![Excel Dashboard](Excel%20Dashboard.png)

---

## 🔍 Key Business Findings
* **Top Revenue Generators:** Road and Mountain bike categories accounted for the largest share of overall revenue.
* **Cost vs. Profit:** While sales volume peaked during Q3, production costs remained proportional, sustaining stable gross margins across high-volume quarters.
* **Regional Distribution:** North American markets generated the highest transaction count, while European territories showed positive quarter-over-quarter expansion.
## 💡 Key Business Insights

Based on the analysis across sales transactions, product categories, and customer demographics:

1. **Revenue Drivers vs. Volume Leaders:**
   * **Bikes** (Road and Mountain) generated over **75% of total revenue**, making them the core financial driver of AdventureWorks.
   * **Accessories and Clothing** represented high transaction volumes with low unit costs, acting as prime cross-selling opportunities during bike checkouts.

2. **Cost vs. Profit Margin Performance:**
   * High gross profit margins were maintained during peak seasonal surges, proving production costs scale predictably with volume.
   * Discounts greater than 15% on select subcategories did not yield proportional volume growth, resulting in minor margin erosion.

3. **Seasonality & Purchasing Trends:**
   * **Q3 and early Q4** consistently outperformed other quarters, driven by summer cycling demand and holiday promotions.
   * Weekend orders demonstrated higher average order value (AOV) compared to weekday purchases.

4. **Regional & Demographic Distribution:**
   * **North America** accounted for the largest overall sales share, while **European regions** demonstrated the fastest year-over-year adoption rate.
   * Professional and management customer segments with higher household income drove the majority of premium bike purchases.

---

## 🎯 Strategic Business Recommendations

* **Implement Automated Cross-Selling:** Bundle low-cost accessories (helmets, water bottles, repair kits) directly at checkout with premium bike sales to lift average basket size.
* **Optimize Promotional Strategy:** Replace blanket discounts with targeted seasonal promotions focused strictly on slow-moving inventory to protect margins.
* **Target Regional Expansion:** Increase localized marketing spend in emerging European territories where year-over-year customer growth is highest.
* **Inventory Forecasting for Peak Quarters:** Align manufacturing runs in late Q2 to prepare sufficient inventory for the Q3 demand spike.

---

## 🏁 Conclusion

This project successfully connects raw transactional data from the AdventureWorks database to high-level executive decision-making. By leveraging:
* **SQL** for relational data modeling and aggregations,
* **Excel** for dynamic pivot models and quick business metrics, and
* **Power BI & Tableau** for interactive visual storytelling,

the final deliverables provide leadership with immediate visibility into sales performance, cost structures, and actionable growth opportunities.
