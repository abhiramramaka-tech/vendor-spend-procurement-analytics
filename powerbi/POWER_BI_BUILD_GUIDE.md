# Power BI Build Guide

## Data
Import `data/cleaned_procurement_data.csv` and rename the table to `Procurement`.

Set the following data types:
- PO_Date, Expected_Delivery_Date, Actual_Delivery_Date: Date
- Quantity, Year, Days_Late, On_Time_Flag: Whole number
- Unit_Price_INR, PO_Amount_INR: Decimal number
- All remaining fields: Text

## Page 1 — Executive Overview
Cards:
- Total Spend
- PO Count
- Average PO Value
- On Time Delivery %
- Top 3 Vendor Share %

Visuals:
1. Line chart — Axis: Year_Month; Value: Total Spend
2. Bar chart — Axis: Category; Value: Total Spend
3. Bar chart — Axis: Vendor_Name; Value: Total Spend; Top N = 8
4. Donut or column chart — Delivery_Status by PO Count
5. Slicers — Year, Department, Region, Category

## Page 2 — Vendor Performance
Visuals:
1. Matrix — Vendor_Name, Total Spend, Vendor Spend Share %, On Time Delivery %, Late POs
2. Scatter chart — X: Total Spend; Y: On Time Delivery %; Details: Vendor_Name
3. Bar chart — Vendor_Name vs Late POs
4. Slicers — Category, Department, Region

Business question:
Which high-spend vendors have weaker delivery performance?

## Page 3 — Price & Savings Opportunities
Visuals:
1. Matrix — Item_Description > Vendor_Name with average Unit_Price_INR
2. Bar chart — Item_Description by average Unit_Price_INR, legend Vendor_Name
3. Table — Item_ID, Item_Description, Vendor_Name, Average Unit Price
4. Filter to items supplied by multiple vendors

Business question:
Where is the company paying materially different prices for the same item?

## Validated findings from this dataset
- Total procurement spend: ₹157,864,068
- Technology is the largest category: ₹58,810,102 (37.3%)
- CoreTech Solutions is the largest vendor: ₹25,491,861 (16.1%)
- Overall on-time delivery rate: 90.2%
- CoreTech Solutions on-time rate: 77.6%
- Top 3 vendor share: 37.1%
- Largest same-item average price gap: Network Switch - 24 Port at 20.0%

Use these as checkpoints. The Power BI report should reproduce them after filters are cleared.
