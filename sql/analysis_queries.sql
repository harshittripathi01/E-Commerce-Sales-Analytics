-- =====================================================
-- Project: E-Commerce Sales Analytics
-- Author: Harshit Tripathi
-- Description:
-- SQL queries used to analyze e-commerce sales data.
-- =====================================================

CREATE DATABASE ecommerce_sales;

USE ecommerce_sales;

CREATE TABLE retail_sales (
    Invoice VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    Price DECIMAL(10,2),
    CustomerID DOUBLE,
    Country VARCHAR(100),
    Revenue DECIMAL(12,2),
    Year INT,
    Month INT,
    Month_Name VARCHAR(20),
    Day INT,
    Day_Name VARCHAR(20)
);

SHOW TABLES;

SELECT * FROM retail_sales;

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/ecommerce_sales/cleaned_retail.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
Invoice,
StockCode,
Description,
Quantity,
InvoiceDate,
Price,
CustomerID,
Country,
Revenue,
Year,
Month,
Month_Name,
Day,
Day_Name
);

SELECT COUNT(*) AS Total_Rows
FROM retail_sales;

-- =====================================================
-- 1. SALES OVERVIEW
-- =====================================================

-- Total revenue
SELECT SUM(Revenue) AS Total_Revenue
FROM retail_sales;

-- Total Orders
SELECT COUNT(DISTINCT Invoice) AS Total_Orders
FROM retail_sales;

-- Total Customers
SELECT COUNT(DISTINCT CustomerID) AS Total_Customers
FROM retail_sales;

-- Average Order Value
SELECT
    SUM(Revenue) / COUNT(DISTINCT Invoice) AS Average_Order_Value
FROM retail_sales;

-- =====================================================
-- 2. TIME ANALYSIS
-- =====================================================

-- Q1. What is the monthly revenue trend?
SELECT
    Year,
    Month,
    Month_Name,
    ROUND(SUM(Revenue),2) AS Total_Revenue
FROM retail_sales
GROUP BY
    Year,
    Month,
    Month_Name
ORDER BY
    Year,
    Month;

-- Q2. What is the total revenue generated each year?

SELECT
    Year,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM retail_sales
GROUP BY Year
ORDER BY Year;

-- =====================================================
-- 3. COUNTRY ANALYSIS
-- =====================================================

-- Q1. Which countries generate the highest revenue?

SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM retail_sales
GROUP BY Country
ORDER BY Total_Revenue DESC;

-- Q2. Top 10 countries by revenue

SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM retail_sales
GROUP BY Country
ORDER BY Total_Revenue DESC
LIMIT 10;

-- =====================================================
-- 4. PRODUCT ANALYSIS
-- =====================================================

-- Q1. Top 10 products by revenue

SELECT
    Description,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM retail_sales
GROUP BY Description
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Q2. Top 10 products by quantity sold

SELECT
    Description,
    SUM(Quantity) AS Total_Quantity
FROM retail_sales
GROUP BY Description
ORDER BY Total_Quantity DESC
LIMIT 10;

-- =====================================================
-- 5. CUSTOMER ANALYSIS
-- =====================================================

-- Q1. Top 10 customers by revenue

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM retail_sales
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Q2. Top 10 customers by number of orders

SELECT
    CustomerID,
    COUNT(DISTINCT Invoice) AS Total_Orders
FROM retail_sales
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Total_Orders DESC
LIMIT 10;


