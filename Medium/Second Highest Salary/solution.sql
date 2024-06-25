WITH sal_rnk AS (SELECT salary,
DENSE_RANK() OVER(ORDER BY salary DESC) rnk
FROM employee
)
SELECT salary second_highest_salary
FROM
sal_rnk
WHERE rnk = 2
LIMIT 1
