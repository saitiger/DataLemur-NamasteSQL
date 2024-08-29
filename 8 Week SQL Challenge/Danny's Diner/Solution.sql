-- 1) Calculate the total spending by each customer

SELECT 
    s.customer_id,
    SUM(m.price) AS total_spent
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 2) Count the number of distinct visit days per customer

SELECT
    customer_id,
    COUNT(DISTINCT order_date) AS days_visited
FROM dannys_diner.sales
GROUP BY customer_id;

-- 3) Identify the first menu item each customer purchased

WITH first_purchase AS (
    SELECT
        s.customer_id,
        m.product_name,
        ROW_NUMBER() OVER(
            PARTITION BY s.customer_id
            ORDER BY s.order_date, s.product_id
        ) AS purchase_rank
    FROM dannys_diner.sales s
    JOIN dannys_diner.menu m
        ON s.product_id = m.product_id
)
SELECT customer_id, product_name
FROM first_purchase
WHERE purchase_rank = 1;

-- 4) Determine the most popular menu item and its purchase count

SELECT
    m.product_name,
    COUNT(s.product_id) AS times_ordered
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY times_ordered DESC
LIMIT 1;

-- 5) Identify the most frequently ordered item per customer

WITH item_frequency AS (
    SELECT
        s.customer_id,
        m.product_name,
        COUNT(*) AS order_count
    FROM dannys_diner.sales s
    JOIN dannys_diner.menu m
        ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
),
ranked_items AS (
    SELECT 
        *,
        RANK() OVER(PARTITION BY customer_id ORDER BY order_count DESC) AS rank
    FROM item_frequency
)
SELECT customer_id, product_name, order_count
FROM ranked_items
WHERE rank = 1;

-- 6) Create a temporary table to validate membership status at the time of purchase

DROP TABLE IF EXISTS membership_status;
CREATE TEMP TABLE membership_status AS
SELECT
    s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
    mem.join_date,
    CASE 
        WHEN s.order_date >= mem.join_date THEN 'Y'
        ELSE 'N'
    END AS is_member
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
LEFT JOIN dannys_diner.members mem
    ON s.customer_id = mem.customer_id
WHERE mem.join_date IS NOT NULL
ORDER BY s.customer_id, s.order_date;

-- 7) Determine the first purchase made after joining the membership program

WITH first_post_membership AS (
    SELECT 
        customer_id,
        product_name,
        order_date,
        RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS purchase_rank
    FROM membership_status
    WHERE is_member = 'Y'
)
SELECT customer_id, product_name, order_date
FROM first_post_membership
WHERE purchase_rank = 1;

-- 8) Determine the last purchase made before joining the membership program

WITH last_pre_membership AS (
    SELECT 
        customer_id,
        product_name,
        order_date,
        RANK() OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS purchase_rank
    FROM membership_status
    WHERE is_member = 'N'
)
SELECT customer_id, product_name, order_date
FROM last_pre_membership
WHERE purchase_rank = 1;

-- 9) Calculate total spending and item count per customer before they became members

WITH pre_membership_spending AS (
    SELECT 
        customer_id,
        product_name,
        price
    FROM membership_status
    WHERE is_member = 'N'
)
SELECT 
    customer_id,
    SUM(price) AS total_spent,
    COUNT(*) AS items_count
FROM pre_membership_spending
GROUP BY customer_id
ORDER BY customer_id;

-- 10) Calculate loyalty points per customer, considering sushi has double points

SELECT
    customer_id,
    SUM(
        CASE 
            WHEN product_name = 'sushi' THEN price * 20
            ELSE price * 10
        END
    ) AS total_points
FROM membership_status
GROUP BY customer_id
ORDER BY customer_id;

-- 11) Calculate points for each customer considering double points for the first week post-membership

DROP TABLE IF EXISTS first_week_points;
CREATE TEMP TABLE first_week_points AS 
WITH first_week_purchases AS (
    SELECT
        customer_id,
        order_date,
        product_name,
        price,
        CASE 
            WHEN order_date BETWEEN join_date AND join_date + INTERVAL '6 days' THEN 'Y'
            ELSE 'N'
        END AS first_week
    FROM membership_status
)
SELECT
    customer_id,
    SUM(
        CASE 
            WHEN first_week = 'Y' THEN price * 20
            ELSE price * 10
        END
    ) AS total_points
FROM first_week_purchases
WHERE order_date < '2021-02-01'
GROUP BY customer_id;

-- 12) Calculate points for non-first-week purchases and aggregate points for final result

DROP TABLE IF EXISTS non_first_week_points;
CREATE TEMP TABLE non_first_week_points AS 
WITH non_first_week_purchases AS (
    SELECT
        customer_id,
        order_date,
        product_name,
        price
    FROM first_week_purchases
    WHERE first_week = 'N'
)
SELECT
    customer_id,
    SUM(
        CASE 
            WHEN product_name = 'sushi' THEN price * 20
            ELSE price * 10
        END
    ) AS total_points
FROM non_first_week_purchases
GROUP BY customer_id;

-- Final aggregation of points from both first week and non-first week purchases
WITH total_points_union AS (
    SELECT * FROM first_week_points
    UNION ALL
    SELECT * FROM non_first_week_points
)
SELECT
    customer_id,
    SUM(total_points) AS total_points
FROM total_points_union
GROUP BY customer_id
ORDER BY customer_id;
