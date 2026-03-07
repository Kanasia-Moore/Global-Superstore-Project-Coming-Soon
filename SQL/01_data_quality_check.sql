SELECT
  COUNT(*) AS total_orders,
  COUNT(DISTINCT Order_ID) AS distinct_orders
FROM `orders`;

SELECT 
  min(Order_Date),
  max(Order_Date)
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
  COUNTIF(sales = 0) AS zero_sales,
  COUNTIF(profit = 0) AS zero_profit
FROM `orders`;

SELECT 
  DISTINCT discount
FROM `orders`;

SELECT 
  COUNT(Discount)
FROM `orders`
WHERE discount = 0.002;

SELECT 
    ROUND(
        SUM(CASE WHEN discount = 0.002 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 
    2) AS discount_percentage
FROM `orders`;

SELECT
    ROUND(SUM(CASE WHEN discount = 0.002 THEN sales ELSE 0 END), 2) AS low_discount_revenue,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND((SUM(CASE WHEN discount = 0.002 THEN sales ELSE 0 END) 
        / SUM(sales)), 2) * 100 AS revenue_percentage
FROM `orders`;


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
FROM `orders_flagged`;

SELECT
  COUNT(*) AS total_rows,
  COUNTIF(p.Region IS NOT NULL) AS matched_people_rows,
  COUNTIF(p.Region IS NULL) AS unmatched_people_rows
FROM `orders` o
LEFT JOIN `people` p
  ON o.Region = p.Region;

