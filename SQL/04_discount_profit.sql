-- Profit Margin per Discount Band
SELECT
  Discount_Band,
  COUNT(DISTINCT Order_ID) AS Orders_per_Band,
  COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SAFE_DIVIDE(SUM(Profit), NULLIF(SUM(Sales), 0)) * 100, 2) AS Profit_Margin,
  ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percentage,
  ROUND(SAFE_DIVIDE(
          COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
          COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate
FROM `superstore_base`
GROUP BY Discount_Band
ORDER BY Profit_Margin DESC

-- Priortity Fix List
WITH Subcat_Returns AS (
  SELECT
    `Sub-Category`,
    COUNT(DISTINCT Order_ID) AS Orders,
    COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
    ROUND(SUM(Sales), 2) AS Sales,
    ROUND(SUM(Profit), 2) AS Profit,
    ROUND(SAFE_DIVIDE(SUM(Profit), SUM(Sales)) * 100, 2) AS Profit_Margin,
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount,
    ROUND(SAFE_DIVIDE(
        COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
        COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate
  FROM `superstore_base`
  GROUP BY `Sub-Category`
)
SELECT
  `Sub-Category`,
  Orders,
  Return_Orders,
  Sales,
  Profit,
  Profit_Margin,
  Avg_Discount,
  Return_Rate,
FROM Subcat_Returns
WHERE Orders>= 50
  AND Return_Rate > 4.2
ORDER BY Profit_Margin ASC, Return_Rate DESC;

