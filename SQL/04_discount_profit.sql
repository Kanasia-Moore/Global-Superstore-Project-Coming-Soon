-- Profit by Category
SELECT
  Category,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SAFE_DIVIDE(SUM(Profit), NULLIF(SUM(Sales), 0)) * 100, 2) AS Profit_Margin
FROM `superstore_base`
GROUP BY Category

-- Profit by Sub-category
SELECT
  `Sub-Category`,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SAFE_DIVIDE(SUM(Profit), NULLIF(SUM(Sales), 0)) * 100, 2) AS Profit_Margin,
  ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percentage
FROM `superstore_base`
GROUP BY `Sub-Category`
ORDER BY Profit_Margin DESC

-- Profit Margin per Discount Band
SELECT
  Discount_Band,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Profit), 2) AS Total_Profit,
  ROUND(SAFE_DIVIDE(SUM(Profit), NULLIF(SUM(Sales), 0)) * 100, 2) AS Profit_Margin,
  ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percentage
FROM `superstore_base`
GROUP BY Discount_Band
ORDER BY Profit_Margin DESC

-- Priortity Fix List
WITH Subcat_Returns AS (
  SELECT
    `Sub-Category`,
    COUNT(DISTINCT Order_ID) AS Orders_by_SubCat,
    COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END) AS Return_Orders,
    ROUND(SUM(Sales), 2) AS Sales_by_SubCat,
    ROUND(SUM(Profit), 2) AS Profit_by_SubCat,
    ROUND(SAFE_DIVIDE(SUM(Profit), SUM(Sales)) * 100, 2) AS Profit_Margin
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount,
    ROUND(SAFE_DIVIDE(
        COUNT(DISTINCT CASE WHEN Return_Flag = 1 THEN Order_ID END),
        COUNT(DISTINCT Order_ID)) * 100, 2) AS Return_Rate
  FROM `superstore_base`
  GROUP BY `Sub-Category`
)
SELECT
  `Sub-Category`,
  Orders_by_SubCat,
  Return_Orders,
  Sales_by_SubCat,
  Profit_by_SubCat,
  Profit_Margin,
  Avg_Discount,
  Return_Rate,
FROM Subcat_Returns
WHERE Orders_by_SubCat >= 50
  AND Return_Rate > 4.2
ORDER BY Profit_Margin ASC, Return_Rate DESC;

