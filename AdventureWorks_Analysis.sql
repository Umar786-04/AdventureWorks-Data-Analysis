####     THE ADVENTUREWORKS PROJECT        ###

create database Adventureworks;
USE adventureworks;
SHOW TABLES;

SELECT COUNT(*) FROM Fact_internet_sales_new;
select count(*) from factinternetsales;
# merge dimproductsubcategory and dimproductcategory and dimproduct table .
DESCRIBE DimProduct;
DESCRIBE DimProductSubcategory;
DESCRIBE DimProductCategory;
CREATE TABLE DimProduct_Merged AS
SELECT
    p.*,
    ps.EnglishProductSubcategoryName,
    pc.EnglishProductCategoryName
FROM DimProduct AS p
LEFT JOIN DimProductSubcategory AS ps
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS pc
    ON ps.ProductCategoryKey = pc.ProductCategoryKey;
 
SELECT COUNT(*)
FROM DimProduct_Merged;

RENAME TABLE DimProduct TO DimProduct_Original;
RENAME TABLE DimProduct_Merged TO DimProduct;

DROP TABLE DimProductSubcategory;
DROP TABLE DimProductCategory;
DROP TABLE DimProduct_Original;

#0.-Union of Fact Internet Sales and Fact Internet Sales new
CREATE TABLE Fact_sales AS
SELECT *
FROM FactInternetSales
UNION ALL
SELECT *
FROM Fact_Internet_Sales_New;

DROP TABLE FactInternetSales;
DROP TABLE Fact_Internet_Sales_New;

select count(*) from fact_sales;

# 1.Lookup the Productname from the product sheet to Sales sheet.
SELECT f.*, p.EnglishProductName AS ProductName
FROM Fact_sales f
LEFT JOIN DimProduct p
ON f.ProductKey = p.ProductKey;

# 2.Lookup the Customerfullname from the Customer and Unit Price from Product sheet to Sales sheet.
SELECT
    f.*,
    CONCAT(
        c.FirstName,
        " ",
        COALESCE(c.MiddleName, ""),
        " ",
        c.LastName
    ) AS CustomerFullName,
    p.`Unit price` as UnitPrice
FROM Fact_sales as f
LEFT JOIN DimCustomer AS c
ON f.CustomerKey = c.CustomerKey
LEFT JOIN DimProduct AS p
ON f.ProductKey = p.ProductKey;

DESCRIBE DimProduct;
select * from dimcustomer;
select customerfullname from dimcustomer;

# 3.
SET SQL_SAFE_UPDATES=0;
Describe fact_sales;
select * from fact_sales;
ALTER TABLE Fact_sales
ADD COLUMN Order_Date DATE;

UPDATE Fact_sales
SET Order_Date = STR_TO_DATE(OrderDateKey, '%Y%m%d');
# A
ALTER TABLE Fact_sales
ADD COLUMN Year INT;
UPDATE Fact_sales
SET Year = YEAR(Order_Date);
SELECT
    Order_Date,
    Year
FROM Fact_sales;

#B
ALTER TABLE Fact_sales
ADD COLUMN MonthNo INT;

UPDATE Fact_sales
SET MonthNo = MONTH(Order_Date);
SELECT
    Order_Date,
    MonthNo
FROM Fact_sales;

#C

ALTER TABLE Fact_sales
ADD COLUMN MonthFullName VARCHAR(20);

UPDATE Fact_sales
SET MonthFullName = MONTHNAME(Order_Date);
SELECT
    Order_Date,
    MonthFullName
FROM Fact_sales;

#D
ALTER TABLE Fact_sales
ADD COLUMN Quarter VARCHAR(2);

UPDATE Fact_sales
SET Quarter = CONCAT('Q', QUARTER(Order_Date));
SELECT
    Order_Date,
	Quarter
FROM Fact_sales;

#E
ALTER TABLE Fact_Sales
ADD COLUMN YearMonth VARCHAR(10);
UPDATE Fact_Sales
SET YearMonth = DATE_FORMAT(Order_Date, '%Y-%b');
SELECT
    Order_Date,
     YearMonth
FROM Fact_sales;

#F
ALTER TABLE Fact_Sales
ADD COLUMN WeekdayNo INT;
UPDATE Fact_Sales
SET WeekdayNo = WEEKDAY(Order_Date) + 1;
SELECT
    Order_Date,
	WeekdayNo
FROM Fact_sales;

#G
ALTER TABLE Fact_Sales
ADD COLUMN WeekdayName VARCHAR(15);
UPDATE Fact_Sales
SET WeekdayName = DAYNAME(Order_Date);
SELECT
    Order_Date,
   WeekdayName
FROM Fact_sales;

#H
ALTER TABLE Fact_Sales
ADD COLUMN FinancialMonth VARCHAR(10);
UPDATE Fact_Sales
SET FinancialMonth =
    CASE
        WHEN MONTH(Order_Date) >= 4
        THEN MONTH(Order_Date)-3
        ELSE MONTH(Order_Date)+9
    END;
   SELECT Order_Date, FinancialMonth
FROM Fact_Sales;
#I
ALTER TABLE Fact_Sales
ADD COLUMN FinancialQuarter VARCHAR(10);
UPDATE Fact_Sales
SET FinancialQuarter =
CASE
    WHEN MONTH(Order_Date) IN (4,5,6) THEN 'Q1'
    WHEN MONTH(Order_Date) IN (7,8,9) THEN 'Q2'
    WHEN MONTH(Order_Date) IN (10,11,12) THEN 'Q3'
    WHEN MONTH(Order_Date) IN (1,2,3) THEN 'Q4'
END;
SELECT
    Order_Date,
   financialquarter
FROM Fact_sales;

# 4.Calculate the Sales amount uning the columns(unit price,order quantity,unit discount)
select * from fact_sales;
SELECT
    UnitPrice,
    OrderQuantity,
    UnitPriceDiscountPct,
    (UnitPrice * OrderQuantity * (1 - UnitPriceDiscountPct)) AS SalesAmount
FROM Fact_sales;

# 5.Calculate the Productioncost uning the columns(unit cost ,order quantity)
DESCRIBE DimProduct;
describe fact_sales;
SELECT
    ProductStandardCost,
    OrderQuantity,
    (ProductStandardCost * OrderQuantity) AS ProductionCost
FROM Fact_sales;

#6.Calculate the profit
SELECT
    SalesAmount,
    TotalProductCost,
    (SalesAmount - TotalProductCost) AS Profit
FROM Fact_sales;

# 7.YEAR-WISE MONTHLY SALES
SHOW COLUMNS FROM Fact_sales;
SELECT 
    Year,
    MonthNo,
    MonthFullName,
    SUM(SalesAmount) AS TotalSales
FROM Fact_Sales
GROUP BY Year, MonthNo, MonthFullName
ORDER BY Year, MonthNo;

# IF WE DON'T MAKE COLUMNS OF SALE AMOUNT, MONTHNO/MONTHNAME ,YEAR THEN QUERY IS
SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS MonthNo,
    MONTHNAME(Order_Date) AS MonthFULLName,
    SUM(SalesAmount) AS TotalSales
FROM Fact_Sales
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    YEAR(Order_Date),
    MONTH(Order_Date);

USE ADVENTUREWORKS;
# 8. YEAR WISE SALES
SELECT
    Year,
    CONCAT(
        ROUND(SUM(SalesAmount) / 1000, 2),
        'K'
    ) AS Sales
FROM Fact_Sales
GROUP BY Year
ORDER BY Year;

# 9. MONTH-WISE SALES
SELECT
    Year,
    MonthNo,
    MonthFullName,
    CONCAT(
        ROUND(SUM(SalesAmount) / 1000, 2),
        'K'
    ) AS Sales
FROM Fact_Sales
GROUP BY
    Year,
    MonthNo,
    MonthFullName
ORDER BY
    Year,
    MonthNo;
    
# 10. QUARTER-WISE SALES
SELECT
    Year,
    Quarter,
    CONCAT(
        ROUND(SUM(SalesAmount) / 1000, 2),
        'K'
    ) AS Sales
FROM Fact_Sales
GROUP BY
    Year,
    Quarter
ORDER BY
    Year,
    Quarter;

# 11. YEAR-WISE SALES VS PRODUCTION COST
SELECT
    Year,
    CONCAT(
        ROUND(SUM(SalesAmount) / 1000, 2),
        'K'
    ) AS Sales,
    CONCAT(
        ROUND(SUM(TotalProductCost) / 1000, 2),
        'K'
    ) AS ProductionCost
FROM Fact_Sales
GROUP BY Year
ORDER BY Year;
 # 12.KPI/ PERFORMANCXE BY PRODUCT, REGION ,CUSTOMER
 SELECT
    ProductKey,
    CONCAT(ROUND(SUM(SalesAmount) / 1000, 2), 'K') AS Sales,
    CONCAT(ROUND(SUM(TotalProductCost) / 1000, 2), 'K') AS ProductionCost,
    CONCAT(
        ROUND((SUM(SalesAmount) - SUM(TotalProductCost)) / 1000, 2),
        'K'
    ) AS Profit
FROM Fact_Sales
GROUP BY ProductKey
ORDER BY SUM(SalesAmount) DESC;

# REGION
SHOW COLUMNS FROM DIMSALESTERRITORY;
SELECT
    T.SalesTerritoryRegion,

    CONCAT(
        ROUND(SUM(F.SaleSAmount) / 1000, 2),
        'K'
    ) AS Sales,

    CONCAT(
        ROUND(SUM(F.TotalProductCost) / 1000, 2),
        'K'
    ) AS ProductionCost,

    CONCAT(
        ROUND(
            (SUM(F.SaleSAmount) - SUM(F.TotalProductCost)) / 1000,
            2
        ),
        'K'
    ) AS Profit

FROM Fact_Sales F

JOIN DimSalesTerritory T
    ON F.SalesTerritoryKey = T.SalesTerritoryKey

GROUP BY T.SalesTerritoryRegion

ORDER BY SUM(F.SaleSAmount) DESC;

# CUSTOMER 
SHOW COLUMNS FROM DIMCUSTOMER;
SELECT
    CONCAT(
    C.FirstName, ' ',
    COALESCE(C.MiddleName, ''), ' ',
    C.LastName) AS FULLNAME,

    CONCAT(
        ROUND(SUM(F.SalesAmount) / 1000, 2),'K') AS Sales,

    CONCAT(
        ROUND(SUM(F.TotalProductCost) / 1000, 2),'K') AS ProductionCost,

    CONCAT(
        ROUND(
            (SUM(F.SalesAmount) - SUM(F.TotalProductCost)) / 1000,2),'K') AS Profit
FROM Fact_Sales F
JOIN DimCustomer C
    ON F.CustomerKey = C.CustomerKey
GROUP BY FullName
ORDER BY SUM(F.SalesAmount) DESC;

# 13. OVERALL REPORT 
####     VIEW-1  OVERALL-YEARLY-SALES PERFORMNCE REPORT    ####

CREATE VIEW vw_overall_yearly_report AS
SELECT
    Year,
    ROUND(SUM(SalesAmount), 2) AS TotalSales,
    ROUND(SUM(TotalProductCost), 2) AS ProductionCost,
    ROUND(SUM(SalesAmount) - SUM(TotalProductCost), 2) AS Profit
FROM Fact_Sales
GROUP BY Year;

SELECT *
FROM vw_overall_yearly_report
ORDER BY Year;

####     VIEW-2  MONTHLY-SALES PERFORMNCE REPORT    ####
CREATE VIEW vw_monthly_sales_report AS
SELECT
    Year,
    MonthNo,
    MonthFullName,
    ROUND(SUM(SalesAmount), 2) AS TotalSales
FROM Fact_Sales
GROUP BY
    Year,
    MonthNo,
    MonthFullName;
    
    SELECT *
FROM vw_monthly_sales_report
ORDER BY Year, MonthNo;

####     VIEW-3 PRODUCT PERFORMNCE     ####
CREATE VIEW vw_product_performance AS
SELECT
    ProductKey,
    ROUND(SUM(SalesAmount), 2) AS TotalSales,
    ROUND(SUM(TotalProductCost), 2) AS ProductionCost,
    ROUND(SUM(SalesAmount) - SUM(TotalProductCost), 2) AS Profit
FROM Fact_Sales
GROUP BY ProductKey;

SELECT *
FROM vw_product_performance
ORDER BY TotalSales DESC;

####     VIEW-4 REGION PERFORMNCE     ####

CREATE VIEW vw_region_performance AS
SELECT
    T.SalesTerritoryRegion AS Region,
    ROUND(SUM(F.SalesAmount), 2) AS TotalSales,
    ROUND(SUM(F.TotalProductCost), 2) AS ProductionCost,
    ROUND(
        SUM(F.SalesAmount) - SUM(F.TotalProductCost),
        2
    ) AS Profit
FROM Fact_Sales F
JOIN DimSalesTerritory T
    ON F.SalesTerritoryKey = T.SalesTerritoryKey
GROUP BY T.SalesTerritoryRegion;

SELECT *
FROM vw_region_performance
ORDER BY TotalSales DESC;

####     VIEW-5 CUSTOMER PERFORMNCE     ####
CREATE VIEW vw_customer_performance AS
SELECT
    C.CustomerKey,
    CONCAT_WS(' ', C.FirstName, C.MiddleName, C.LastName) AS CustomerName,

    ROUND(SUM(F.SalesAmount), 2) AS TotalSales,

    ROUND(SUM(F.TotalProductCost), 2) AS ProductionCost,

    ROUND(
        SUM(F.SalesAmount) - SUM(F.TotalProductCost),
        2
    ) AS Profit

FROM Fact_Sales F
JOIN DimCustomer C
    ON F.CustomerKey = C.CustomerKey

GROUP BY
    C.CustomerKey,
    C.FirstName,
    C.MiddleName,
    C.LastName;
    
    SELECT *
FROM vw_customer_performance
ORDER BY TotalSales DESC;


SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW';




#DATA MODELLING
USE ADVENTUREWORKS;
DESCRIBE Fact_Sales;
DESCRIBE DimProduct;
DESCRIBE DimCustomer;
DESCRIBE DimSalesTerritory;
DESCRIBE DimDate;
SELECT
    P.ProductKey,
    F.SalesAmount
FROM DimProduct P
JOIN Fact_Sales F
    ON P.ProductKey = F.ProductKey
LIMIT 10;
SELECT
    C.CustomerKey,
    F.SalesAmount
FROM DimCustomer C
JOIN Fact_Sales F
    ON C.CustomerKey = F.CustomerKey
LIMIT 10;
SELECT
    T.SalesTerritoryKey,
    T.SalesTerritoryRegion,
    F.SalesAmount
FROM DimSalesTerritory T
JOIN Fact_Sales F
    ON T.SalesTerritoryKey = F.SalesTerritoryKey
LIMIT 10;

#######                       COMPLETED                         ######################
