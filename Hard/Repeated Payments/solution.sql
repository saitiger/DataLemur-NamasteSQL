with diff as (
select t1.transaction_id,t2.transaction_id
,(t2.transaction_timestamp) - (t1.transaction_timestamp) as time_diff
from transactions t1 join transactions t2 ON
t1.merchant_id = t2.merchant_id and t1.credit_card_id = t2.credit_card_id 
and t1.amount = t2.amount and t1.transaction_id <> t2.transaction_id
)
-- SELECT * FROM diff;
SELECT count(*) FROM diff where EXTRACT(minutes from time_diff)<=10 
AND EXTRACT(hours from time_diff)=0 AND
EXTRACT(minutes from time_diff)>0
;

-- select transaction_timestamp::time from transactions;
