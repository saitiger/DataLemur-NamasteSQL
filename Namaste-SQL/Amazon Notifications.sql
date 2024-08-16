with notification_windows as (
    select 
        notification_id,
        delivered_at,
        product_id,
        case 
            when date_add(delivered_at, interval 2 hour) <= lead(delivered_at, 1, '9999-12-31') over (order by notification_id)
            then date_add(delivered_at, interval 2 hour) 
            else lead(delivered_at, 1, '9999-12-31') over (order by notification_id)
        end as notification_valid_till
    from 
        notifications
),
purchases_in_window as (
    select 
        nw.notification_id,
        p.user_id,
        p.product_id as purchased_product,
        nw.product_id as notified_product
    from 
        purchases p
    inner join 
        notification_windows nw on p.purchase_timestamp between nw.delivered_at and nw.notification_valid_till
)
select 
    notification_id,
    sum(case when purchased_product = notified_product then 1 else 0 end) as same_product_purchases,
    sum(case when purchased_product != notified_product then 1 else 0 end) as different_product_purchases
from 
    purchases_in_window
group by 
    notification_id
order by 
    notification_id;
