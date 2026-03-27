select
    order_id,
    customer_id,
    to_timestamp_ntz(try_to_number(order_date) / 1000000) as order_date,
    to_timestamp_ntz(try_to_number(shipped_date) / 1000000) as shipped_date
from {{ source('fudgemart_v3', 'fm_orders') }}
