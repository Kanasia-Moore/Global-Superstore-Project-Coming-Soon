```sql
  SELECT  
  Count(Order_ID) as total_orders  
FROM `inspiring-grove-457423-b0.global_superstore.orders`;

SELECT 
  count(DISTINCT Order_ID) as bundled_orders
FROM `inspiring-grove-457423-b0.global_superstore.orders`;

SELECT 
  min(Order_Date),
  max(Order_Date)
FROM `inspiring-grove-457423-b0.global_superstore.orders`;

SELECT Row_ID, count(*)
FROM `inspiring-grove-457423-b0.global_superstore.orders`
GROUP BY Row_ID
HAVING COUNT(*) > 1;


