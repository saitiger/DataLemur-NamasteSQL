WITH CTE AS
(SELECT 
SUM(CASE WHEN ITEM_TYPE = 'not_prime' THEN 1 ELSE 0 END) as count_non_prime,
SUM(CASE WHEN ITEM_TYPE = 'prime_eligible' THEN 1 ELSE 0 END) as count_prime,
SUM(CASE WHEN ITEM_TYPE = 'not_prime' THEN SQUARE_FOOTAGE END) as area_not_prime,
SUM(CASE WHEN ITEM_TYPE = 'prime_eligible' THEN SQUARE_FOOTAGE END) as area_prime
FROM INVENTORY)

SELECT 
'prime_eligible',
floor(500000/area_prime)*count_prime as item_count
FROM CTE
UNION ALL
SELECT 
'not_prime',
floor((500000-floor(500000/area_prime)*area_prime)/area_not_prime)*count_non_prime as item_count
FROM CTE
