-- Superstore base table view (line-level)
CREATE VIEW superstore_base AS SELECT 
  o.* EXCEPT(Row_ID),
  EXTRACT(MONTH FROM Order_Date) AS Order_Month,
  EXTRACT(YEAR FROM Order_Date) AS Order_Year,
  If(r.Returned IS NOT NULL, 1, 0) AS Return_Flagged,
  CASE
    WHEN Discount = 0 THEN '0%'
    WHEN Discount <= 0.01 THEN '0-1%'
    WHEN Discount <= 0.15 THEN '1-15%'
    WHEN Discount <= 0.30 THEN '16-30%'
    WHEN Discount <= 0.50 THEN '31-50%'
    ELSE '50%+'
  END AS Discount_Band,
  ROUND(SAFE_DIVIDE(o.Profit, NULLIF(o.Sales, 0)) * 100, 2) AS Profit_Margin_Line,
  p.Person
FROM `orders` as o
LEFT JOIN `returns` as r ON o.Order_ID = r.Order_ID
LEFT JOIN `people` as p ON o.Region = p.Region

-- Superstore order table view (order-level)

