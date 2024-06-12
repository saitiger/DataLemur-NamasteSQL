-- SELECT EXTRACT(month from event_date) as month FROM user_actions;
-- OR EXTRACT(month from event_date) = 7
with month_6_users as (
SELECT user_id,COUNT(user_id) from user_actions where event_type in ('sign-in','like','comment')
and (EXTRACT(month from event_date) = 6 )
and (EXTRACT(year from event_date)=2022)
GROUP BY 1
),
month_7_users as (
SELECT user_id,EXTRACT(month from event_date) as mth,COUNT(user_id) from user_actions where event_type in ('sign-in','like','comment')
and (EXTRACT(month from event_date) = 7 )
and (EXTRACT(year from event_date)=2022)
GROUP BY 1,2
)
SELECT m2.mth as "month",count(m2.user_id) as monthly_active_users from 
month_6_users m1 join month_7_users m2 on m1.user_id = m2.user_id
GROUP BY 1;
