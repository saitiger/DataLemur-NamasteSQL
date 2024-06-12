
with yr_data as (
select product_id,
EXTRACT(year from transaction_date) as "year",
sum(spend) over 
(PARTITION BY product_id,EXTRACT(year from transaction_date) ORDER BY EXTRACT(year from transaction_date))
as curr_year_spend
from user_transactions
),
summ as (
select *,lag(curr_year_spend,1) OVER(PARTITION BY product_id) as prev_year_spend
from yr_data
)
select year,product_id,curr_year_spend,prev_year_spend,
ROUND(100.0*(curr_year_spend - prev_year_spend)/prev_year_spend,2) as yoy_rate
from summ
