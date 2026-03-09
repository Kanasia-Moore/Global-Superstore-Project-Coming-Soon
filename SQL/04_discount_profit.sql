-- Profit by Category
SELECT
  Category,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SAFE_DIVIDE(SUM(Profit), NULLIF(SUM(Sales), 0)) * 100, 1) AS Profit_Margin
FROM `superstore_base`
GROUP BY Category

-- Profit by Sub-category
SELECT
  `Sub-Category`,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SAFE_DIVIDE(SUM(Profit), NULLIF(SUM(Sales), 0)) * 100, 1) AS Profit_Margin,
  ROUND(AVG(Discount) * 100, 1) AS Avg_Discount_Percentage
FROM `superstore_base`
GROUP BY `Sub-Category`
ORDER BY Profit_Margin DESC

-- Profit Margin per Discount Band
SELECT
  Discount_Band,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SAFE_DIVIDE(SUM(Profit), NULLIF(SUM(Sales), 0)) * 100, 1) AS Profit_Margin,
  ROUND(AVG(Discount) * 100, 1) AS Avg_Discount_Percentage
FROM `superstore_base`
GROUP BY Discount_Band
ORDER BY Profit_Margin DESC

-- Priortity Return Hotspots
WITH Top_Subcat_Rankings AS 
(
SELECT
  `Sub-Category`,
  COUNT(DISTINCT Order_ID) AS Orders_by_SubCat,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate
FROM `inspiring-grove-457423-b0.global_superstore.superstore_base`
GROUP BY `Sub-Category`
)
SELECT 
  `Sub-Category`,
  RANK() OVER(ORDER BY Return_Rate DESC) AS Ranking
FROM Top_Subcat_Rankings

