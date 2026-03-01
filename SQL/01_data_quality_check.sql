-- Global Superstore Data Quality Check
-- Purpose: Validate table grain, key integrity, null presence,
-- and join relationships prior to KPI construction. 

SELECT
  COUNT(*) AS total_orders,
  COUNT(DISTINCT Order_ID) AS distinct_orders
FROM `orders`;

SELECT 
  min(Order_Date),
  max(Order_Date)
FROM `orders`;

SELECT 
  COUNTIF(Order_ID IS NULL) AS null_order_id,
  COUNTIF(Order_Date IS NULL) AS null_order_date,
  COUNTIF(Customer_ID IS NULL) AS null_customer_id,
  COUNTIF(Sales IS NULL) AS null_sales,
  COUNTIF(Profit IS NULL) AS null_profit
FROM `orders`;

SELECT 
  MIN(Sales) AS min_sales,
  MAX(Sales) AS max_sales,
  MIN(Profit) AS min_profit,
  MAX(Profit) AS max_profit,
  MIN(Discount) AS min_discount,
  MAX(Discount) AS max_discount
FROM `orders`;

SELECT
  COUNT(*) AS total_returns,
  COUNT(DISTINCT Order_ID) AS distinct_return_orders
FROM `returns`;

SELECT
  Order_ID,
  COUNT(*) AS cnt
FROM `returns`
GROUP BY Order_ID
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

WITH orders_flagged AS (
  SELECT 
    o.Order_ID,
    MAX(IF(r.Returned IS NOT NULL, 1, 0)) AS is_returned
  FROM `orders` AS o
  LEFT JOIN `returns` AS r
    ON o.Order_ID = r.Order_ID
  GROUP BY o.Order_ID
  ) 
SELECT
  COUNTIF(is_returned = 1) AS returned_orders,
  COUNTIF(is_returned = 0) AS non_returned_orders,
  COUNT(*) AS total_orders
FROM orders_flagged;

SELECT
  COUNT(*) AS total_rows,
  COUNTIF(p.Region IS NOT NULL) AS matched_people_rows,
  COUNTIF(p.Region IS NULL) AS unmatched_people_rows
FROM `orders` o
LEFT JOIN `people` p
  ON o.Region = p.Region;

