with
stg_fm_orders as (
    select
        order_id,
        'FudgeMart' as division,
        {{ dbt_utils.generate_surrogate_key(['order_id', 'division']) }} as orderkey,
        cast(customer_id as varchar) as customer_id,
        replace(to_date(order_date)::varchar, '-', '')::int as orderdatekey,
        replace(to_date(shipped_date)::varchar, '-', '')::int as shippeddatekey,
        null as returneddatekey,
        ship_via
    from {{ source('fudgemart_v3','fm_orders') }}
),

stg_ff_orders as (
    select
        at_id AS order_id,
        'FudgeFlix' as division,
        {{ dbt_utils.generate_surrogate_key(['at_id', 'division']) }} as orderkey,
        cast(at_account_id as varchar) as customer_id,
        replace(to_date(at_queue_date)::varchar, '-', '')::int as orderdatekey,
        replace(to_date(at_shipped_date)::varchar, '-', '')::int as shippeddatekey,
        replace(to_date(at_returned_date)::varchar, '-', '')::int as returneddatekey,
        null as ship_via
    from {{ source('fudgeflix_v3','ff_account_titles') }}
),

all_orders as (
    select * from stg_fm_orders
    union all
    select * from stg_ff_orders
)

select *
from all_orders