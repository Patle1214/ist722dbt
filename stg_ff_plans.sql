select 
    AT_ID as account_title_id,
    AT_ACCOUNT_ID as account_id,
    AT_TITLE_ID as title_id,
    to_timestamp_ntz(try_to_number(AT_QUEUE_DATE) / 1000000) as order_date,
    to_timestamp_ntz(try_to_number(AT_SHIPPED_DATE) / 1000000) as shipped_date,
    to_timestamp_ntz(try_to_number(AT_RETURNED_DATE) / 1000000) as returned_date
from {{ source('fudgeflix_v3', 'ff_account_titles') }}