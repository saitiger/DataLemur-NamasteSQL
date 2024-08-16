select c.category_name, coalesce(sum(s.amount), 0) total_sales
from 
categories c
left join 
sales s 
on c.category_id = s.category_id
group by 1
order by 2
