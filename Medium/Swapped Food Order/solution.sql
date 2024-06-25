SELECT 
CASE WHEN order_id % 2 != 0 AND order_id != total_orders 
THEN order_id + 1 
WHEN order_id % 2 != 0 AND order_id = total_orders 
THEN order_id
ELSE order_id - 1
END AS corrected_order_id,
item
FROM 
orders,
(SELECT COUNT(order_id) AS total_orders FROM orders) AS order_counts
ORDER BY corrected_order_id;
