WITH searches_expanded AS (
  SELECT searches
  FROM search_frequency
  GROUP BY 
    searches, 
    GENERATE_SERIES(1, num_users)
    ORDER BY 1)

SELECT 
PERCENTILE_CONT(0.50) 
WITHIN GROUP (ORDER BY searches) as median
FROM searches_expanded;
