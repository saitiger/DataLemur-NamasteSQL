SELECT department_name,name,salary 
FROM (
SELECT 
d.department_name,
e.name,
e.salary,
DENSE_RANK() OVER(PARTITION BY e.department_id ORDER BY e.salary DESC) rnk
FROM employee e
JOIN
department d 
ON e.department_id = d.department_id
)x
where rnk <= 3
ORDER BY department_name,rnk,name
