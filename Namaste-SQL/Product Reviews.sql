select review_id,product_id,review_text
from product_reviews
where(lower(review_text) like '% excellent%' or lower(review_text) like '% amazing%') 
and lower(review_text) not like '%not excellent%'
and lower(review_text) not like '%not amazing%'
order by review_id
