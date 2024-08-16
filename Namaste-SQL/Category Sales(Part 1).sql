select category, SUM(amount) total_sales
from sales
where year(order_date) = 2022 and month(order_date) = 2
and dayofweek(order_date) between 2 and 6
group by category
order by total_sales;
