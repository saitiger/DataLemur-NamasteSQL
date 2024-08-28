-- A. Customer Journey
Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

with summary as (
select customer_id,count(s.plan_id) as cnt ,min(start_date) as mn,
  max(start_date) as mx , sum(p.price) as total_amount_paid
  from foodie_fi.subscriptions s
  join foodie_fi.plans p
  on s.plan_id = p.plan_id
group by customer_id
  )

-- top_paying 

select customer_id,mn,mx,total_amount_paid from summary where cnt>=3
order by 4 desc

-- number of customers who churned 

select 
round(100.0*sum(case when s.plan_id = 4 then 1 else 0 end)/count(distinct customer_id),2) as pct_churn
from
foodie_fi.plans p join foodie_fi.subscriptions s
on p.plan_id = s.plan_id

with cust_journey as (
select 
s.customer_id,p.plan_id, p.plan_name,  s.start_date,
row_number() over (partition by customer_id order by start_date) as rn 
from foodie_fi.plans p
join foodie_fi.subscriptions s
  on p.plan_id = s.plan_id
where s.customer_id in (1,2,11,13,15,16,18,19)
)
  
-- onboarding
select customer_id, plan_id, plan_name,start_date from cust_journey 
  where rn = 1;
 --all customers started with the trial plan churning after trial 

select c1.customer_id from cust_journey c1 join cust_journey c2 
on c1.customer_id = c2.customer_id and c1.plan_id = 0 and c2.plan_id = 4 and c2.rn - c1.rn = 1
group by 1
  
--most bought plan after trial 
select plan_id,count(plan_id) from cust_journey where rn=2 group by plan_id 

select s.customer_id,
       p.plan_name,
       s.start_date,
       start_date - lag(start_date) over (partition by customer_id order by start_date) as days_between_subscription
from foodie_fi.subscriptions s join foodie_fi.plans p
on s.plan_id = p.plan_id
where s.customer_id in (1,2,11,13,15,16,18,19)

1) How many customers has Foodie-Fi ever had?
2) What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3) What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4) What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5) How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6) What is the number and percentage of customer plans after their initial free trial?
7) How many customers have upgraded to an annual plan in 2020?
8) How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
9) How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10) Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11) How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

select count(distinct customer_id) from foodie_fi.subscriptions

select extract(month from start_date) as mnth, count(*)
from foodie_fi.subscriptions s join foodie_fi.plans p 
on s.plan_id = p.plan_id 
where p.plan_id = 0
group by 1
order by 1

select p.plan_name, count(*)
from foodie_fi.subscriptions s join foodie_fi.plans p 
on s.plan_id = p.plan_id 
where extract(year from s.start_date) > 2020
group by 1
order by 2 desc

select sum(case when s.plan_id = 4 then 1 else 0 end) as churn_count,
round(100.0*sum(case when s.plan_id = 4 then 1 else 0 end)/count(distinct customer_id),1) as churn_pct 
from foodie_fi.subscriptions s join foodie_fi.plans p 
on s.plan_id = p.plan_id 

with cust_rnk as (
select 
s.customer_id,p.plan_id, p.plan_name,  s.start_date,
row_number() over (partition by customer_id order by start_date) as rn 
from foodie_fi.plans p
join foodie_fi.subscriptions s
  on p.plan_id = s.plan_id
)
select count(c1.customer_id) as churn_after_trial,
round(100.0*count(c1.customer_id)/(select count(distinct customer_id) from foodie_fi.subscriptions)) as pct_churn
from cust_rnk c1 join cust_rnk c2 
on c1.customer_id = c2.customer_id and c1.plan_id = 0 
where c2.plan_id = 4 and c2.rn - c1.rn = 1

with after_trial as (
select customer_id,s.plan_id,lead(s.plan_id,1) over (partition by customer_id order by start_date) as nxt_plan
from foodie_fi.plans p
join foodie_fi.subscriptions s
on p.plan_id = s.plan_id
)
select nxt_plan,count(*) as count_conversion,round(100.0*count(*)/(select count(distinct customer_id) from foodie_fi.subscriptions),1) as pct_conversion
from after_trial 
where plan_id = 0 and nxt_plan is not null
group by nxt_plan


with cust_rnk as (
select 
s.customer_id,p.plan_id, p.plan_name,  s.start_date,
row_number() over (partition by customer_id order by start_date) as rn 
from foodie_fi.plans p
join foodie_fi.subscriptions s
  on p.plan_id = s.plan_id
)
select plan_id,count(*) as count_conversion,
round(100.0*count(*)/(select count(distinct customer_id) from foodie_fi.subscriptions),1) as pct_conversion
from cust_rnk 
where rn = 2
group by plan_id

with latest_plan as (
  select *, rank() over(partition by customer_id order by start_date desc) as rnk
  from foodie_fi.subscriptions
  where start_date <= '2020-12-31'
  )
  select plan_id,count(*) as cnt,
  round(100.0*count(*)/(select count(distinct customer_id) from foodie_fi.subscriptions),1) as pct_total
  from latest_plan 
  where rnk = 1 
  group by 1
  
select count(customer_id) as cnt 
from foodie_fi.subscriptions
where extract(year from start_date) = 2020
and plan_id = 3

with initial_date as (
select customer_id,min(start_date) as initial_date 
  from foodie_fi.subscriptions
  group by customer_id
  ),
final_date as (
select customer_id,min(start_date) as final_date 
  from foodie_fi.subscriptions
  where plan_id = 3
  group by customer_id
)
select 
round(avg(cast(final_date - initial_date as decimal)),0) as avg_days 
from initial_date i join final_date f
on i.customer_id = f.customer_id

with initial_date as (
select customer_id,min(start_date) as initial_date 
  from foodie_fi.subscriptions
  group by customer_id
  ),
final_date as (
select customer_id,min(start_date) as final_date 
  from foodie_fi.subscriptions
  where plan_id = 3
  group by customer_id
),
buckets as (select width_bucket(f.final_date - i.initial_date, 0, 360, 12) AS bucket,
count(i.customer_id) AS customer_count,
     ROUND(avg(cast(f.final_date - i.initial_date AS DECIMAL)), 0) AS average_days
                  from   initial_date i
                  join   final_date f
                  on     i.customer_id = f.customer_id
                  group  by width_bucket (final_date - initial_date, 0, 360, 12)
                 )
select case 
           when bucket = 1 
           then concat((bucket - 1) * 30,' - ', bucket * 30, ' days') 
           else concat((bucket - 1) * 30 + 1,' - ', bucket * 30, ' days')
       end as period,
       customer_count,
       average_days
from   buckets
group by bucket, customer_count, average_days
order by bucket 

with pro_monthly as (
select 
s.customer_id,start_date
from foodie_fi.subscriptions s
where plan_id = 3
),
basic_monthly as (
select 
s.customer_id,start_date
from foodie_fi.subscriptions s
where plan_id = 2
)
select count(*) from pro_monthly p join basic_monthly b 
on p.customer_id = b.customer_id and p.start_date <= b.start_date

-- Challenge Payment Question
The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in 
the subscriptions table with the following requirements:
monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
once a customer churns they will no longer make payments

with series as(
select s.customer_id,s.plan_id,p.plan_name,
cast(generate_series(s.start_date,case when s.plan_id in(0, 3, 4) then s.start_date 
when s.plan_id in (1, 2) and lead(s.plan_id) over (partition by s.customer_id order by s.start_date) <> s.plan_id then LEAD(s.start_date) 
over (partition by s.customer_id order by s.start_date) - 1 
else '2020-12-31' end,'1 MONTH') as date) payment_date,p.price
from subscriptions s
join plans p
on s.plan_id = p.plan_id
where extract(year from s.start_date) = 2020
)
select customer_id,plan_id,plan_name,payment_date,
case when plan_id = 1 then price
when plan_id IN (2, 3) and lag(plan_id) over (partition by customer_id order by payment_date) <> plan_id
and payment_date - lag(payment_date) over (partition by customer_id order by payment_date) < 30
then price - lag(price) over (partition by customer_id order by payment_date)
else price end as amount,
rank() OVER (partition by customer_id order by payment_date) AS rnk
into payments
from series
where plan_id not in (0, 4)
