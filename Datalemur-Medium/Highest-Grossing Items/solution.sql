-- WITH CTE AS (
-- SELECT *, 
-- RANK() OVER(PARTITION BY category ORDER BY total_spend DESC) rnk
-- FROM (
-- SELECT 
-- category,product,
-- SUM(spend) total_spend
-- FROM product_spend
-- WHERE EXTRACT(year from transaction_date) = 2022
-- GROUP BY 1,2
-- ORDER BY 3 DESC
-- )x
-- )
-- SELECT category,product,total_spend
-- FROM 
-- cte 
-- WHERE rnk<=2

SELECT category,product,total_spend
FROM
(
SELECT category,product, SUM(spend) AS total_spend,
RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) rnk 
FROM 
product_spend
WHERE 
EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY 1, 2
)x
WHERE rnk <=2
