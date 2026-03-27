with stg_fm_orders as (
    select
        o.order_id,
        customer_id,
        'FudgeMart' as division,
        order_date as orderdate,
        shipped_date as shippeddate,
        replace(to_date(order_date)::varchar, '-', '')::int as orderdatekey,
        replace(to_date(shipped_date)::varchar, '-', '')::int as shippeddatekey,
        null as returneddatekey,
    
        ship_via
    from {{ source('fudgemart_v3','fm_orders') }} o


),

stg_ff_orders as (
    select
        at_id AS order_id,
        at_account_id as customer_id,
        'FudgeFlix' as division,
        at_queue_date as orderdate,
        at_shipped_date as shippeddate,
        replace(to_date(at_queue_date)::varchar, '-', '')::int as orderdatekey,
        replace(to_date(at_shipped_date)::varchar, '-', '')::int as shippeddatekey,
        replace(to_date(at_returned_date)::varchar, '-', '')::int  as returneddatekey,

        null as ship_via
    from {{ source('fudgeflix_v3','ff_account_titles') }} at
    join {{ source('fudgeflix_v3','ff_accounts') }} a on at.at_account_id = a.account_id

)
    select order_id,
    {{ dbt_utils.generate_surrogate_key(['order_id','division']) }} as orderkey,
    {{ dbt_utils.generate_surrogate_key(['customer_id','division']) }} as customerkey,
    division,
    orderdatekey,
    shippeddatekey,
    returneddatekey,
    case 
        when shippeddatekey is not null 
        then datediff(day, orderdate, shippeddate)
    end as order_to_shipped,
    ship_via
     from stg_fm_orders
    union all
    select order_id,
    {{ dbt_utils.generate_surrogate_key(['order_id','division']) }} as orderkey,
    {{ dbt_utils.generate_surrogate_key(['customer_id','division']) }} as customerkey,
    division,
    orderdatekey,
    shippeddatekey,
    returneddatekey,
    case 
        when shippeddatekey is not null 
        then datediff(day, orderdate, shippeddate)
    end as order_to_shipped,
    ship_via
     from stg_ff_orders
