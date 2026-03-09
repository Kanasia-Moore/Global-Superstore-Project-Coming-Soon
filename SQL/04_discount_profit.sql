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
SELECT
  `Sub-Category`,
  ROUND(SUM(Sales), 2) Sales_by_SubCat,
  ROUND(SUM(Profit), 2) Profit_by_SubCat,
  ROUND(Avg(Discount) * 100, 2) AS Avg_Discount,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 1) AS Return_Rate
FROM `superstore_base`
GROUP BY `Sub-Category` 
ORDER BY Return_Rate_Percent DESC;
