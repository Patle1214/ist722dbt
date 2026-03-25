select
    plan_id,
    plan_price
from {{ source('fudgeflix_v3', 'ff_plans') }}
