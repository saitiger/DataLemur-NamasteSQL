with info as (select l.loan_id,
payment_date,
l.due_date,
l.loan_amount,
sum(amount_paid) over(partition by loan_id order by payment_date) repayment
from
payments p
join 
loans l
on l.loan_id = p.loan_id
),
last_payment as (
select
loan_id,due_date,loan_amount,
max(repayment) as total_paid,
max(payment_date) as last_date
from 
info 
group by 1,2,3
)
select 
loan_id,
loan_amount,
due_date,
case when total_paid=loan_amount then 1 else 0 end fully_paid_flag,
case when total_paid=loan_amount and last_date<=due_date then 1 else 0 end as on_time_flag
from
last_payment

-- Solution 2 (Credits : Solutions Tab) 
-- The code is optimized and has lesser lines
select l.loan_id,l.loan_amount,l.due_date
,case when sum(p.amount_paid)= l.loan_amount then 1 else 0 end as fully_paid_flag
,case when sum(case when p.payment_date<=l.due_date then p.amount_paid end)=l.loan_amount then 1 else 0 end as on_time_flag
from loans l 
left join payments p on l.loan_id=p.loan_id
group by l.loan_id,l.loan_amount,l.due_date
order by l.loan_id
