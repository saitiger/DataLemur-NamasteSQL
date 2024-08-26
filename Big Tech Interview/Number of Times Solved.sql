# Solution 1 
with cte as (
select m.question_id,m.minutes,
to_char(m.start_time, 'YYYY-MM') year_month
from 
questions q
join
members m
on q.question_id = m.question_id
)
select 
question_id,
count(*),
sum(minutes) total_minutes
from 
cte 
where year_month = '2018-12'
group by 1
order by 1

# Solution 2 
select
question_id
,count(user_id) "count"
,sum(minutes) total_minutes
from members
where
date_part('year',start_time)=2018
and date_part('month',start_time)=12
group by question_id
order by question_id asc;
