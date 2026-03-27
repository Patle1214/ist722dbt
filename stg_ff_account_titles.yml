select
    fe.source_order_id as fulfillment_id,
    c.customer_id as customer_key,  
    p.product_id as item_key,
    o.order_id as order_key,
    fe.order_date,
    fe.shipped_date,
    fe.returned_date,
    fe.quantity,
    round(fe.unit_price, 2) as unit_price,
    round(fe.quantity * fe.unit_price, 2) as extended_price,
    fe.fulfillment_channel,
    fe.division,
    case 
        when fe.shipped_date is not null 
        then datediff(day, fe.order_date, fe.shipped_date)
    end as order_to_ship_days,
    case 
        when fe.returned_date is not null 
        then datediff(day, fe.shipped_date, fe.returned_date)
    end as ship_to_return_days
from {{ ref('stg_fulfillment_events') }} fe
join {{ ref('dim_customers') }} c
    on c.customer_id = fe.source_customer_id
   and c.division = fe.division
join {{ ref('dim_orders') }} o
    on o.order_id = fe.source_order_id
   and o.customer_id = fe.source_customer_id
   and o.division = fe.division
join {{ ref('dim_products') }} p
    on p.product_id = fe.source_item_id
   and p.division = fe.division