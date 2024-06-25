select ab.age_bucket,
round(100.0 * sum(case when activity_type = 'send' then time_spent else 0 end)/sum(case when activity_type = 'open' or activity_type = 'send' then time_spent else 0 end),2) send_perc,
round(100.0 * sum(case when activity_type = 'open' then time_spent else 0 end)/sum(case when activity_type = 'open' or activity_type = 'send' then time_spent else 0 end),2) open_perc
FROM
activities ac join age_breakdown ab 
on ac.user_id = ab.user_id
GROUP BY 1
