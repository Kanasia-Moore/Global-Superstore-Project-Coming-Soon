```sql
SELECT  
  Count(Order_ID) as total_orders  
FROM `orders`;

SELECT 
  count(DISTINCT Order_ID) as bundled_orders
FROM `orders`;

SELECT 
  min(Order_Date),
  max(Order_Date)
FROM `orders`;

SELECT Row_ID, count(*)
FROM `orders`
GROUP BY Row_ID
HAVING COUNT(*) > 1;


