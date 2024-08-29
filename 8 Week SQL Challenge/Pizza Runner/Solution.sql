-- 1. How many pizzas were ordered?
SELECT COUNT(*) AS total_pizzas_ordered 
FROM customer_orders;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_orders 
FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(*) AS successful_deliveries 
FROM runner_orders 
WHERE cancellation IS NULL 
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT p.pizza_name, COUNT(*) AS total_delivered 
FROM pizza_names p
JOIN customer_orders c ON p.pizza_id = c.pizza_id 
JOIN runner_orders r ON c.order_id = r.order_id 
WHERE r.cancellation IS NULL 
GROUP BY p.pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.customer_id, 
       SUM(CASE WHEN p.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS vegetarian_pizzas,
       SUM(CASE WHEN p.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS meatlovers_pizzas
FROM customer_orders c
JOIN pizza_names p ON c.pizza_id = p.pizza_id 
GROUP BY c.customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT MAX(pizza_count) AS max_pizzas_in_order
FROM (
    SELECT COUNT(*) AS pizza_count 
    FROM customer_orders 
    GROUP BY order_id
) AS subquery;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT c.customer_id,
       SUM(CASE WHEN p.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS vegetarian_pizzas,
       SUM(CASE WHEN p.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS meatlovers_pizzas
FROM customer_orders c
JOIN pizza_names p ON c.pizza_id = p.pizza_id 
GROUP BY c.customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT order_id 
FROM customer_orders 
WHERE (exclusions IS NOT NULL AND exclusions <> '') 
  AND (extras IS NOT NULL AND extras <> '');

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT EXTRACT(HOUR FROM order_time) AS order_hour, 
       COUNT(*) AS total_pizzas_ordered
FROM customer_orders
GROUP BY order_hour
ORDER BY order_hour;

-- 10. What was the volume of orders for each day of the week?
SELECT EXTRACT(DOW FROM order_time) AS day_of_week, 
       COUNT(*) AS total_orders 
FROM customer_orders 
GROUP BY day_of_week 
ORDER BY day_of_week;
