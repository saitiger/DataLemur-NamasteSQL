with tot_weight as (
select lift_id,passenger_name,weight_kg,
sum(weight_kg) over(partition by lift_id order by weight_kg) cum_weight
from 
lift_passengers
)
select t.lift_id id,
group_concat(passenger_name order by t.weight_kg) passenger_list
from
lifts l 
join 
tot_weight t
on l.id = t.lift_id
where t.cum_weight<=l.capacity_kg
group by 1
