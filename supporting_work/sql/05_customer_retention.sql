-- Total Customers
SELECT
  COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM `superstore_base`

-- Repeat Customers and Customer Rate
WITH customer_orders AS (
  SELECT
    Customer_ID,
    COUNT(Order_ID) AS order_count
  FROM `superstore_order_summary`
  GROUP BY Customer_ID
) SELECT
    COUNT(*) AS total_customers,
    COUNTIF(order_count >= 2) AS repeat_customers,
    ROUND(SAFE_DIVIDE(COUNTIF(order_count >= 2), COUNT(*)) * 100, 2) AS repeat_customer_rate,
    ROUND(AVG(order_count), 2) AS avg_orders_per_customer
  FROM customer_orders;

-- Repeat Rate of Customers by Segment
WITH customer_orders AS (
  SELECT
    Segment,
    Customer_ID,
    COUNT(Order_ID) AS order_count
  FROM `superstore_order_summary`
  GROUP BY Segment, Customer_ID
) SELECT
    Segment,
    COUNT(*) AS total_customers,
    COUNTIF(order_count >= 2) AS repeat_customers,
    ROUND(SAFE_DIVIDE(COUNTIF(order_count >= 2), COUNT(*)) * 100, 2) AS repeat_customer_rate,
    ROUND(AVG(order_count), 2) AS avg_orders_per_customer
  FROM customer_orders
  GROUP BY Segment
  ORDER BY repeat_customer_rate DESC;

-- Repeat Rate of Customers per Region
WITH customer_orders AS (
  SELECT
    Region,
    Customer_ID,
    COUNT(Order_ID) AS order_count
  FROM `inspiring-grove-457423-b0.global_superstore.superstore_order_summary`
  GROUP BY Region, Customer_ID
) SELECT
    Region,
    COUNT(*) AS total_customers,
    COUNTIF(order_count >= 2) AS repeat_customers,
    ROUND(SAFE_DIVIDE(COUNTIF(order_count >= 2), COUNT(*)) * 100, 2) AS repeat_customer_rate,
    ROUND(AVG(order_count), 2) AS avg_orders_per_customer
  FROM customer_orders
  GROUP BY Region
  ORDER BY repeat_customer_rate DESC;

-- Top Customers by Profit
  SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT IF(Return_Flag = 1, Order_ID, NULL)) AS Total_Returns,
    ROUND(SAFE_DIVIDE(COUNT(DISTINCT IF(Return_Flag = 1, Order_ID, NULL)), COUNT(DISTINCT Order_ID)) * 100, 2) AS Customer_Return_Rate
  FROM `superstore_base`
  GROUP BY Customer_ID, Customer_Name
  ORDER BY Total_Profit DESC




