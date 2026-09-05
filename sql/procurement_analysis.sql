-- Vendor Spend & Procurement Analytics
-- Dialect: SQL Server / T-SQL
-- Dataset: cleaned_procurement_data.csv
-- Level: beginner to intermediate

-- ============================================================
-- OPTIONAL TABLE DEFINITION
-- ============================================================
CREATE TABLE procurement_data (
    PO_Number VARCHAR(20) PRIMARY KEY,
    PO_Date DATE,
    Vendor_ID VARCHAR(10),
    Vendor_Name VARCHAR(100),
    Department VARCHAR(100),
    Category VARCHAR(100),
    Item_ID VARCHAR(20),
    Item_Description VARCHAR(150),
    Quantity INT,
    Unit_Price_INR DECIMAL(18,2),
    PO_Amount_INR DECIMAL(18,2),
    Payment_Terms VARCHAR(20),
    Expected_Delivery_Date DATE,
    Actual_Delivery_Date DATE NULL,
    Region VARCHAR(20),
    Buyer VARCHAR(100),
    PO_Status VARCHAR(20),
    Delivery_Status VARCHAR(20),
    [Year] INT,
    [Month] VARCHAR(10),
    Year_Month CHAR(7),
    Days_Late INT NULL,
    On_Time_Flag INT NULL
);

-- 1. Overall procurement KPIs
SELECT
    COUNT(*) AS Total_POs,
    SUM(PO_Amount_INR) AS Total_Spend_INR,
    AVG(PO_Amount_INR) AS Avg_PO_Value_INR,
    SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) AS Late_POs,
    CAST(
        100.0 * SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN Delivery_Status IN ('On Time','Late') THEN 1 ELSE 0 END), 0)
        AS DECIMAL(6,2)
    ) AS On_Time_Delivery_Pct
FROM procurement_data;

-- 2. Monthly spend trend
SELECT
    Year_Month,
    SUM(PO_Amount_INR) AS Monthly_Spend_INR,
    COUNT(*) AS PO_Count
FROM procurement_data
GROUP BY Year_Month
ORDER BY Year_Month;

-- 3. Vendor spend and share of total
SELECT
    Vendor_Name,
    SUM(PO_Amount_INR) AS Vendor_Spend_INR,
    CAST(
        100.0 * SUM(PO_Amount_INR) / SUM(SUM(PO_Amount_INR)) OVER()
        AS DECIMAL(6,2)
    ) AS Spend_Share_Pct
FROM procurement_data
GROUP BY Vendor_Name
ORDER BY Vendor_Spend_INR DESC;

-- 4. Category and department spend
SELECT Category, SUM(PO_Amount_INR) AS Spend_INR
FROM procurement_data
GROUP BY Category
ORDER BY Spend_INR DESC;

SELECT Department, SUM(PO_Amount_INR) AS Spend_INR
FROM procurement_data
GROUP BY Department
ORDER BY Spend_INR DESC;

-- 5. Vendor delivery performance
SELECT
    Vendor_Name,
    COUNT(CASE WHEN PO_Status = 'Closed' THEN 1 END) AS Closed_POs,
    SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) AS Late_POs,
    CAST(
        100.0 * SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN Delivery_Status IN ('On Time','Late') THEN 1 ELSE 0 END), 0)
        AS DECIMAL(6,2)
    ) AS On_Time_Pct
FROM procurement_data
GROUP BY Vendor_Name
ORDER BY On_Time_Pct DESC;

-- 6. Spend concentration: top 3 vendors
WITH VendorSpend AS (
    SELECT Vendor_Name, SUM(PO_Amount_INR) AS Spend_INR
    FROM procurement_data
    GROUP BY Vendor_Name
),
Ranked AS (
    SELECT
        Vendor_Name,
        Spend_INR,
        ROW_NUMBER() OVER (ORDER BY Spend_INR DESC) AS Spend_Rank,
        SUM(Spend_INR) OVER () AS Total_Spend
    FROM VendorSpend
)
SELECT
    SUM(CASE WHEN Spend_Rank <= 3 THEN Spend_INR ELSE 0 END) AS Top_3_Vendor_Spend,
    MAX(Total_Spend) AS Total_Spend,
    CAST(
        100.0 * SUM(CASE WHEN Spend_Rank <= 3 THEN Spend_INR ELSE 0 END) / MAX(Total_Spend)
        AS DECIMAL(6,2)
    ) AS Top_3_Share_Pct
FROM Ranked;

-- 7. Same-item price comparison by vendor
SELECT
    Item_ID,
    Item_Description,
    Vendor_Name,
    COUNT(*) AS Purchase_Lines,
    AVG(Unit_Price_INR) AS Avg_Unit_Price_INR
FROM procurement_data
GROUP BY Item_ID, Item_Description, Vendor_Name
ORDER BY Item_ID, Avg_Unit_Price_INR;

-- 8. Items with the largest vendor-to-vendor price gaps
WITH ItemVendorPrice AS (
    SELECT
        Item_ID,
        Item_Description,
        Vendor_Name,
        AVG(Unit_Price_INR) AS Avg_Unit_Price
    FROM procurement_data
    GROUP BY Item_ID, Item_Description, Vendor_Name
),
PriceRange AS (
    SELECT
        Item_ID,
        MAX(Item_Description) AS Item_Description,
        MIN(Avg_Unit_Price) AS Lowest_Avg_Price,
        MAX(Avg_Unit_Price) AS Highest_Avg_Price
    FROM ItemVendorPrice
    GROUP BY Item_ID
)
SELECT
    Item_ID,
    Item_Description,
    Lowest_Avg_Price,
    Highest_Avg_Price,
    CAST(
        100.0 * (Highest_Avg_Price - Lowest_Avg_Price) / NULLIF(Lowest_Avg_Price,0)
        AS DECIMAL(8,2)
    ) AS Price_Gap_Pct
FROM PriceRange
WHERE Highest_Avg_Price > Lowest_Avg_Price
ORDER BY Price_Gap_Pct DESC;

-- 9. Region spend
SELECT
    Region,
    SUM(PO_Amount_INR) AS Spend_INR,
    COUNT(*) AS PO_Count
FROM procurement_data
GROUP BY Region
ORDER BY Spend_INR DESC;

-- 10. Month-over-month spend change
WITH MonthlySpend AS (
    SELECT Year_Month, SUM(PO_Amount_INR) AS Spend_INR
    FROM procurement_data
    GROUP BY Year_Month
),
Trend AS (
    SELECT
        Year_Month,
        Spend_INR,
        LAG(Spend_INR) OVER (ORDER BY Year_Month) AS Prior_Month_Spend
    FROM MonthlySpend
)
SELECT
    Year_Month,
    Spend_INR,
    Prior_Month_Spend,
    CAST(
        100.0 * (Spend_INR - Prior_Month_Spend) / NULLIF(Prior_Month_Spend,0)
        AS DECIMAL(8,2)
    ) AS MoM_Change_Pct
FROM Trend
ORDER BY Year_Month;

-- 11. Department x category matrix
SELECT
    Department,
    Category,
    SUM(PO_Amount_INR) AS Spend_INR
FROM procurement_data
GROUP BY Department, Category
ORDER BY Department, Spend_INR DESC;

-- 12. Vendor scorecard: spend + delivery reliability
SELECT
    Vendor_Name,
    SUM(PO_Amount_INR) AS Spend_INR,
    AVG(Unit_Price_INR) AS Avg_Unit_Price_INR,
    CAST(
        100.0 * SUM(CASE WHEN Delivery_Status = 'On Time' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN Delivery_Status IN ('On Time','Late') THEN 1 ELSE 0 END),0)
        AS DECIMAL(6,2)
    ) AS On_Time_Pct
FROM procurement_data
GROUP BY Vendor_Name
ORDER BY Spend_INR DESC;
