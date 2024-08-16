with price_info as 
(
select product_id, price_date start_date ,price,
lead(price_date, 1, '9999-12-31') over (partition by product_id order by price_date) end_date
from 
products
)
select 
p.product_id, 
sum(price) total_sales
FROM 
price_info p
join 
orders o 
on o.product_id = p.product_id
and o.order_date >= start_date 
and o.order_date < end_date
group by 1
order by 1 
