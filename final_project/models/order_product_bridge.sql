with stg_order_details as (
select *,'FudgeMart' as division
 from  {{ source('fudgemart_v3','fm_order_details') }}
),
stg_acc_titles as (
select *,'FudgeMart' as division
 from {{ source('fudgeflix_v3','ff_account_titles') }}
)
select {{ dbt_utils.generate_surrogate_key(['order_id', 'division']) }} as orderkey,
{{ dbt_utils.generate_surrogate_key(['product_id', 'division']) }} as productkey,
order_qty,
'FudgeMart' as division
from stg_order_details
union all
select {{ dbt_utils.generate_surrogate_key(['at_id', 'division']) }} as orderkey,
{{ dbt_utils.generate_surrogate_key(['at_title_id', 'division']) }} as productkey,
1 as order_qty,
'FudgeFlix' as division
from stg_acc_titles