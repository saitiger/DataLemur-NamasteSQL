with cte as (
select category, min(price) as min_price
from products a
join purchases b
on a.id = b.product_id 
where stars>=4 group by category
) 
select a.category,
min(case when b.min_price is null then 0 else min_price end ) as price
from products a left join cte b on a.category = b.category
group by a.category order by a.category
