with count_orders as (
select *,
count(*) over(partition by customer_name) tot_count,
row_number() over(partition by customer_name order by order_date desc) order_num
from orders
)
select order_id,order_date,customer_name,product_name,sales
from
count_orders
where order_num = 2 
or 
tot_count = 1
