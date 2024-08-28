1. How many pizzas were ordered?

select count(*) as num_pizza_ordered from customer_orders;

2. How many unique customer orders were made?

select count(distinct(order_id)) from customer_orders;

3. How many successful orders were delivered by each runner?

select count(*) as sucessful_pizza_delivered from runner_orders where cancellation is NULL;

4. How many of each type of pizza was delivered?

select runner_id,count(*) as succesful_delivery from runner_orders where cancellation is NULL group by runner_id order by 1; 

5. How many Vegetarian and Meatlovers were ordered by each customer?

select p.pizza_name,count(*) as number_of_pizza_delivered from pizza_names p join customer_orders c 
on p.pizza_id = c.pizza_id join runner_orders r on c.order_id = r.order_id where r.cancellation is NULL group by p.pizza_name ;
  
6.What was the maximum number of pizzas delivered in a single order?

select customer_id,p.pizza_name,count(*) from customer_orders c join pizza_names p on c.pizza_id = p.pizza_id group by 1,2 order by 1;

7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select c.customer_id,sum(case when p.pizza_name = 'Meatlovers' then 1 else 0 end) as Meatlovers_count ,
sum(case when p.pizza_name = 'Vegetarian' then 1 else 0 end) as Vegetarian_count
from customer_orders c join pizza_names p on c.pizza_id = p.pizza_id
group by c.customer_id
order by c.customer_id ;

8. How many pizzas were delivered that had both exclusions and extras?

-- select order_id,count(*) as max_orders from customer_orders group by order_id order by 2 desc limit 1;

select order_id from customer_orders group by order_id having (exclusions <> 'null' or exclusions <>'')

9. What was the total volume of pizzas ordered for each hour of the day?

with day_hours as (
select *, extract(hour from order_time) as hrs from customer_orders
)
select hrs as Hour_of_Day,count(*) as Volume from day_hours group by 1 order by 1 ;

10. What was the volume of orders for each day of the week?

with week_day as (
select *, extract(dow from order_time) as dw from customer_orders
)
select dw as Day_of_Week,count(*) as Volume from week_day group by 1 order by 1 ;
