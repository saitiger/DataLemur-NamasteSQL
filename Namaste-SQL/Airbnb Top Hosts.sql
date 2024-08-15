with candidates as 
(select host_id,listing_id,
 count(listing_id) over(partition by host_id) number_of_listing 
 from listings
)
select host_id,max(number_of_listing) number_of_listing,
round(sum(rating)/count(*),2) avg_rating
from candidates c
join 
reviews r 
on c.listing_id = r.listing_id
where c.number_of_listing>=2
group by 1
order by 3 desc 
limit 2
