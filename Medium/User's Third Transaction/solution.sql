with summary as (
SELECT 
*,
row_number() over(PARTITION BY user_id ORDER BY transaction_date) as rn
FROM transactions
)
select user_id,spend,transaction_date 
from summary 
where rn = 3
