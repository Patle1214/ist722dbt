select
    title_id,
    title_name,
    title_instant_available
from {{ source('fudgeflix_v3', 'ff_titles') }}
