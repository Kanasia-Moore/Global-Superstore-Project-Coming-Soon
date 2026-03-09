-- Overall Return KPI
Select 
  COUNT(*) AS Total_Orders,
  COUNTIF(Return_Flag = 1) AS Total_Returns,
  ROUND(COUNTIF(Return_Flag = 1) / COUNT(*) * 100, 2) AS Return_Rate
FROM superstore_order_summary

-- Return Rate per Category
SELECT
  Category,
  COUNT(DISTINCT Order_ID) AS Orders_by_Category,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate
FROM `superstore_base`
GROUP BY Category
ORDER BY Return_Rate DESC;

-- Return Rate Per Sub-Category
SELECT
  `Sub-Category`,
  COUNT(DISTINCT Order_ID) AS Orders_by_SubCat,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate
FROM `superstore_base`
GROUP BY `Sub-Category`
ORDER BY Return_Rate DESC

-- Return Rate Per Region
SELECT
  Region,
  COUNT(*) AS Orders_by_Region,
  COUNTIF(Return_Flag = 1) AS Return_Orders,
  ROUND(SAFE_DIVIDE(COUNTIF(Return_Flag = 1), COUNT(Order_ID)) * 100, 2) AS Return_Rate
FROM `superstore_order_summary`
GROUP BY Region
ORDER BY Return_Rate_Percent DESC

-- Return Rate per Segment
SELECT
  Segment,
  COUNT(*) AS Orders_by_Segment,
  COUNTIF(Return_Flag = 1) AS Return_Orders,
  ROUND(SAFE_DIVIDE(COUNTIF(Return_Flag = 1), COUNT(Order_ID)) * 100, 2) AS Return_Rate
FROM `superstore_order_summary`
GROUP BY Segment
ORDER BY Return_Rate DESC

-- Return Rate per Ship Mode
SELECT
  Ship_Mode,
  COUNT(DISTINCT Order_ID) AS Orders_by_Ship,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate
FROM `superstore_base`
GROUP BY Ship_Mode
ORDER BY Return_Rate DESC

-- Return Rate per Discount Band
SELECT
  Discount_Band,
  COUNT(DISTINCT Order_ID) AS Orders_per_Band,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate
FROM `superstore_base`
GROUP BY Discount_Band
ORDER BY Return_Rate DESC
  
-- Top Sub-Categories by Return Rate
WITH Top_Subcat_Rankings AS (
SELECT
  `Sub-Category`,
  COUNT(DISTINCT Order_ID) AS Orders_by_SubCat,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SAFE_DIVIDE(
      COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
      COUNT(DISTINCT Order_ID)) * 100, 2 ) AS Return_Rate
FROM `superstore_base`
GROUP BY `Sub-Category`
)
SELECT 
  `Sub-Category`,
  Orders_by_SubCat,
  Return_Orders,
  Return_Rate,
  RANK() OVER (ORDER BY Return_Rate DESC) AS Ranking
FROM Top_Subcat_Rankings
ORDER BY Ranking;
