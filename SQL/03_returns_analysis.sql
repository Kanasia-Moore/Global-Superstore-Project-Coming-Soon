-- Overall Return KPI
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
  ROUND(SAFE_DIVIDE(COUNTIF(Return_Flag = 1),COUNT(Order_ID)) * 100, 2) AS Return_Rate_Percent
FROM `superstore_order_summary`
GROUP BY Region
ORDER BY Return_Rate_Percent DESC

-- Return Rate per Segment
SELECT
  Segment,
  COUNT(*) AS Orders_by_Segment,
  COUNTIF(Return_Flag = 1) AS Return_Orders,
  ROUND(SAFE_DIVIDE(COUNTIF(Return_Flag = 1), COUNT(Order_ID)) * 100, 2) AS Return_Rate_Percent
FROM `superstore_order_summary`
GROUP BY Segment
ORDER BY Return_Rate_Percent DESC

-- Return Rate per Ship Mode
SELECT
  Ship_Mode,
  COUNT(DISTINCT Order_ID) AS Orders_by_Ship,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate_Percent
FROM `superstore_base`
GROUP BY Ship_Mode
ORDER BY Return_Rate_Percent DESC

-- Return Rate per Discount Band
SELECT
  Discount_Band,
  COUNT(DISTINCT Order_ID) AS Orders_per_Band,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate_Percent
FROM `superstore_base`
GROUP BY Discount_Band
ORDER BY Return_Rate_Percent DESC

-- Priortity Return Hotspots
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
