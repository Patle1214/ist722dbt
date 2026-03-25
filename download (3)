with fm as (
    select
        'FudgeMart' as division,
        cast(o.order_id as varchar) as source_order_id,
        cast(o.customer_id as varchar) as source_customer_id,
        cast(od.product_id as varchar) as source_item_id,
        o.order_date,
        o.shipped_date,
        null as returned_date,
        cast(od.order_qty as number) as quantity,
        cast(p.product_retail_price as number(10,2)) as unit_price,
        'Shipping' as fulfillment_channel
    from {{ ref('stg_fm_orders') }} o
    join {{ ref('stg_fm_order_details') }} od using (order_id)
    join {{ ref('stg_fm_products') }} p using (product_id)
),

ff as (
    select
        'FudgeFlix' as division,
        cast(at.account_title_id as varchar) as source_order_id,
        cast(at.account_id as varchar) as source_customer_id,
        cast(at.title_id as varchar) as source_item_id,
        at.order_date,
        at.order_date as shipped_date,
        at.returned_date,
        1 as quantity,
        cast(pl.plan_price as number(10,2)) as unit_price,
        case
            when at.order_date is not null then 'Rental'
            when t.title_instant_available = true then 'Streaming'
            else 'Unknown'
        end as fulfillment_channel
    from {{ ref('stg_ff_account_titles') }} at
    join {{ ref('stg_ff_accounts') }} a on a.account_id = at.account_id
    join {{ ref('stg_ff_titles') }} t on t.title_id = at.title_id
    join {{ ref('stg_ff_plans') }} pl on pl.plan_id = a.account_plan_id
)

select
    source_order_id,
    source_customer_id,
    source_item_id,
    order_date,
    shipped_date,
    returned_date,
    quantity,
    unit_price,
    fulfillment_channel,
    division
from fm

union all

select
    source_order_id,
    source_customer_id,
    source_item_id,
    order_date,
    shipped_date,
    returned_date,
    quantity,
    unit_price,
    fulfillment_channel,
    division
from ff