select Category,count(*) Category_count
from 
(
select
case when price<100 then "Low Price" when price>500 then "High Price" else "Medium Price" end Category
from
Products)x
group by 1
order by 2 desc
