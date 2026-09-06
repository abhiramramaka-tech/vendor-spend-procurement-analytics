# Vendor Spend & Procurement Analytics

## Project Overview
This project analyzes procurement activity for a fictional multi-location company using **Excel, SQL, and Power BI**. The goal is to understand where the company is spending money, evaluate vendor performance, identify price inconsistencies, and highlight practical opportunities for procurement improvement.

The dataset contains **2,600 purchase-order line records** from January 2025 through June 2026.

## Business Questions
- How is procurement spend changing over time?
- Which vendors, categories, departments, and regions drive the most spend?
- Is the company too dependent on a small number of vendors?
- Are vendors charging different prices for the same items?
- Which vendors provide the strongest balance of price and delivery performance?
- Where are late deliveries concentrated?

## Tools Used
- **Excel:** data cleaning, validation, KPI analysis, summary tables, and dashboarding
- **SQL:** aggregations, CASE statements, CTEs, window functions, spend concentration, price analysis, and vendor scorecards
- **Power BI:** executive KPIs, vendor-performance reporting, price-comparison analysis, and interactive filtering

## Data Preparation
The raw file intentionally includes a small number of realistic data-quality issues:
- Leading/trailing spaces in vendor names
- Inconsistent category capitalization
- Inconsistent payment-term formatting
- Inconsistent capitalization in buyer names

These were standardized before analysis. Blank actual-delivery dates for open purchase orders were retained because they are valid business records rather than data errors.

## Key Findings
- Total procurement spend was **₹157,864,068** across **2,600** purchase-order lines.
- **Technology** was the largest spend category at **₹58,810,102**, or **37.3%** of total spend.
- **CoreTech Solutions** was the largest vendor at **₹25,491,861**, but its on-time delivery rate was only **77.6%**.
- The top three vendors represented **37.1%** of total procurement spend.
- The largest observed same-item average price gap was **20.0%** for **Network Switch - 24 Port**.
- The analysis shows a clear tradeoff between price and service: some lower-cost vendors have weaker delivery reliability.

## Recommendations
1. Use item-level average prices as benchmarks during vendor negotiations.
2. Review high-spend vendors with below-average on-time performance.
3. Avoid selecting vendors based on price alone; include delivery reliability in sourcing decisions.
4. Consider split-award sourcing for important categories when one vendor offers better pricing and another offers stronger delivery performance.
5. Track vendor spend concentration to reduce dependency risk.

## Screenshots
<img width="1326" height="812" alt="WhatsApp Image 2026-09-06 at 2 00 09 AM" src="https://github.com/user-attachments/assets/cc6737b0-c0ea-47c4-a641-b5d69d47f41a" />


<img width="1331" height="813" alt="WhatsApp Image 2026-09-06 at 2 00 30 AM" src="https://github.com/user-attachments/assets/6c64da90-e7f3-4730-bd19-bdea6951a061" />


<img width="1320" height="802" alt="WhatsApp Image 2026-09-06 at 2 02 25 AM" src="https://github.com/user-attachments/assets/231e153f-61f0-4781-a212-7b2b29134c4a" />



## Repository Structure
```text
data/
  raw_procurement_data.csv
  cleaned_procurement_data.csv

sql/
  procurement_analysis.sql

powerbi/
  dax_measures.txt
  POWER_BI_BUILD_GUIDE.md

Vendor_Spend_Procurement_Analytics.xlsx
README.md
```

## Note
This is a **synthetic portfolio project** created to demonstrate a realistic business/data analytics workflow. The findings are calculated from the generated dataset and are intended for learning and portfolio use.
