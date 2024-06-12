WITH advertiser_status AS (
SELECT
  a.user_id,
  a.status,
  dp.paid
FROM advertiser a 
LEFT JOIN daily_pay dp
  ON a.user_id = dp.user_id

UNION

SELECT
  dp.user_id,
  a.status,
  dp.paid
FROM daily_pay dp
LEFT JOIN advertiser a
  ON a.user_id = dp.user_id
)

SELECT
  user_id,
  CASE WHEN paid IS NULL THEN 'CHURN'
  	WHEN status != 'CHURN' AND paid IS NOT NULL THEN 'EXISTING'
  	WHEN status = 'CHURN' AND paid IS NOT NULL THEN 'RESURRECT'
  	WHEN status IS NULL THEN 'NEW'
  END AS new_status
FROM advertiser_status
ORDER BY 1;
