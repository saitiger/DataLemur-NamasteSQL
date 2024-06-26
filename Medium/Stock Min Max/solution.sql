WITH CTE AS (
SELECT 
ticker,
date,
open,
RANK() OVER(PARTITION BY ticker order by open desc) high_rnk,
RANK() OVER(PARTITION BY ticker order by open) low_rnk
FROM
stock_prices
)
SELECT 
ticker,
MAX(CASE WHEN high_rnk = 1 THEN to_char(date, 'Mon-YYYY')
 END) AS highest_mth,
MAX(open) highest_open,
MAX(CASE WHEN low_rnk = 1 THEN to_char(date, 'Mon-YYYY') END) AS lowest_mth,
MIN(open) lowest_open
FROM 
cte
GROUP BY 1
