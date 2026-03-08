-- Superstore base table view (line-level)
CREATE VIEW superstore_base AS 
SELECT 
  o.* EXCEPT(Row_ID),
  EXTRACT(MONTH FROM Order_Date) AS Order_Month,
  EXTRACT(YEAR FROM Order_Date) AS Order_Year,
  If(r.Returned IS NOT NULL, 1, 0) AS Return_Flag,
  CASE
    WHEN Discount = 0 THEN '0%'
    WHEN Discount <= 0.01 THEN '<1%'
    WHEN Discount <= 0.15 THEN '1-15%'
    WHEN Discount <= 0.30 THEN '16-30%'
    WHEN Discount <= 0.50 THEN '31-50%'
    ELSE '>50%'
  END AS Discount_Band,
  ROUND(SAFE_DIVIDE(o.Profit, NULLIF(o.Sales, 0)) * 100, 2) AS Profit_Margin_Line,
  p.Person
FROM `orders` as o
LEFT JOIN `returns` as r ON o.Order_ID = r.Order_ID
LEFT JOIN `people` as p ON o.Region = p.Region

-- Superstore order table view (order-level)
CREATE VIEW superstore_order_summary AS 
SELECT
  Order_Id,
  ANY_VALUE(Customer_ID) AS Customer_ID,
  ANY_VALUE(Segment) AS Segment,
  ANY_VALUE(Region) AS Region,
  ANY_VALUE(Order_Year) AS Year,
  ROUND(SUM(Sales), 2) AS Sales,
  ROUND(SUM(Profit), 2) AS Profit,
  ROUND(SAFE_DIVIDE(SUM(Profit), NULLIF(SUM(Sales), 0)) * 100, 2) AS Profit_Margin,
  ROUND(AVG(Discount), 2) AS Avg_Discount,
  MAX(Return_Flag) AS Return_Flag
FROM `superstore_base`
GROUP BY Order_Id;

-- Overall Return Rate Calc
Select 
  COUNT(*) AS Total_Orders,
  COUNTIF(Return_Flag = 1) AS Total_Returns,
  ROUND(COUNTIF(Return_Flag = 1) / COUNT(*) * 100, 1) AS Return_Rate
FROM superstore_order_summary

-- Return Rate per Category
SELECT
  Category,
  COUNT(DISTINCT Order_ID) AS Orders_by_Category,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SUM(Sales), 2) Sales_by_Cat,
  ROUND(SUM(Profit), 2) Profit_by_Cat,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate_Percent
FROM `superstore_base`
GROUP BY Category
ORDER BY Return_Rate_Percent DESC;

-- Return Rate Per Sub-Category
SELECT
  `Sub-Category`,
  COUNT(DISTINCT Order_ID) AS Orders_by_SubCat,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SUM(Sales), 2) Sales_by_SubCat,
  ROUND(SUM(Profit), 2) Profit_by_SubCat,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate_Percent
FROM `superstore_base`
GROUP BY `Sub-Category`
ORDER BY Return_Rate_Percent DESC

-- Return Rate Per Region
SELECT
  Region,
  COUNT(*) AS Orders_by_Region,
  COUNTIF(Return_Flag = 1) AS Return_Orders,
  ROUND(SUM(Sales), 2) Sales_by_Region,
  ROUND(SUM(Profit), 2) Profit_by_Region,
  ROUND(SAFE_DIVIDE(COUNTIF(Return_Flag = 1),COUNT(Order_ID)) * 100, 2) AS Return_Rate_Percent
FROM `superstore_order_summary`
GROUP BY Region
ORDER BY Return_Rate_Percent DESC

-- Return Rate per Segment
SELECT
  Segment,
  COUNT(*) AS Orders_by_Segment,
  COUNTIF(Return_Flag = 1) AS Return_Orders,
  ROUND(SUM(Sales), 2) Sales_by_Segment,
  ROUND(SUM(Profit), 2) Profit_by_Segment,
  ROUND(SAFE_DIVIDE(COUNTIF(Return_Flag = 1),COUNT(Order_ID)) * 100, 2) AS Return_Rate_Percent
FROM `superstore_order_summary`
GROUP BY Segment
ORDER BY Return_Rate_Percent DESC

-- Return Rate per Discount Band
SELECT
  Discount_Band,
  COUNT(*) AS Order_Lines,
  COUNTIF(Return_Flag = 1) AS Returned_Lines,
  ROUND(AVG(Line_Profit_Margin), 2) AS Avg_Profit_Margin,
  ROUND(SAFE_DIVIDE(COUNTIF(Return_Flag = 1), COUNT(*)) * 100, 2) AS Return_Rate_Percent
FROM `superstore_base`
GROUP BY Discount_Band
ORDER BY Return_Rate_Percent DESC;

-- Priortity Fix List
SELECT
  `Sub-Category`,
  ROUND(SUM(Sales), 2) Sales_by_SubCat,
  ROUND(SUM(Profit), 2) Profit_by_SubCat,
  ROUND(SAFE_DIVIDE(SUM(Profit), NULLIF(SUM(Sales), 0)) * 100, 2) AS Profit_Margin,
  ROUND(Avg(Discount) * 100, 2) AS Avg_Discount,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate_Percent
FROM `superstore_base`
GROUP BY `Sub-Category` 
ORDER BY Return_Rate_Percent DESC;


