select
    account_id,
    account_plan_id
from {{ source('fudgeflix_v3', 'ff_accounts') }}
