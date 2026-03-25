with stg_products as (
    select * 
    from {{ source('fudgemart_v3','fm_products') }}
),

stg_titles as (
    select * 
    from {{ source('fudgeflix_v3','ff_titles') }}
),

stg_title_genres as (
    select *
    from (
        select *,
            row_number() over (partition by tg_title_id order by tg_title_id) as rn
        from {{ source('fudgeflix_v3', 'ff_title_genres') }}
    )
    where rn = 1
)

-- Fudgemart products
select 
    cast(p.product_id as varchar) as product_id,  
    p.product_name,
    p.product_department as product_category,
    'FudgeMart' as division,
    {{ dbt_utils.generate_surrogate_key(['product_id', 'division']) }} as productkey
from stg_products p

union all 

-- FudgeFlix titles
select 
    cast(t.title_id as varchar) as product_id,    
    t.title_name as product_name,
    tg.tg_genre_name as product_category,
    'FudgeFlix' as division,
    {{ dbt_utils.generate_surrogate_key(['product_id', 'division']) }} as productkey
from stg_titles t
left join stg_title_genres tg 
    on t.title_id = tg.tg_title_id
