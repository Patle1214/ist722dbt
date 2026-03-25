select
    product_id,
    round(product_retail_price, 2) as product_retail_price
from {{ source('fudgemart_v3', 'fm_products') }}
