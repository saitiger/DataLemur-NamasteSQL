WITH call_category_cnt AS (

SELECT COUNT(case_id) as cnt FROM callers where call_category = 'n/a' or call_category IS NULL

)

SELECT ROUND(100.0 *cnt/(SELECT count(*) FROM callers),1) as uncategorised_call_pct from call_category_cnt;
