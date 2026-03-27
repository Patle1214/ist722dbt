select
    order_id,
    product_id,
    order_qty
from {{ source('fudgemart_v3', 'fm_order_details') }}
