-- with summ_day as (
-- select tweet_date,
-- lag(tweet_date,1) over(PARTITION BY user_id order by tweet_date) as prev_day,
-- lead(tweet_date,1) over(PARTITION BY user_id order by tweet_date) as next_day
-- from 
-- tweets
-- )
-- select * from summ_day 
-- where tweet_date - prev_day = 1
-- and next_day - tweet_date = 1

select user_id,tweet_date,
round(avg(tweet_count) 
over(PARTITION BY user_id order by tweet_date rows between 2 preceding and 0 following),2) as rolling_avg_3days
from 
tweets
