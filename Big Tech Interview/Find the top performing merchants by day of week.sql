WITH cte as (select
merchant_id,to_char(order_date,'Day') initcap,order_date,order_revenue,
rank() over(partition by order_date order by order_revenue desc) AS rnk
from orders)
select
merchant_id,
initcap,
order_revenue
from cte
where rnk=1
order by order_date desc;
