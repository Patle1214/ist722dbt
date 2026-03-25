/* STAGING VIEW/TABLE: stg_customers
   Purpose: Unify FudgeFlix and FudgeMart customer data.
*/
with 
stg_customers as (
--Stage FudgeFlix Accounts with ZIP lookup
    select
        cast(a.account_id as varchar) as customer_id,
        'FudgeFlix' as division,
        a.account_firstname as customer_first_name,
        a.account_lastname as customer_last_name,
        a.account_address as customer_address,
        z.zip_city as customer_city,       -- from ff_zipcodes
        z.zip_state as customer_state,     -- from ff_zipcodes
        a.account_zipcode as customer_postal_code,
        NULL as customer_phone,            -- missing in FudgeFlix
        a.account_email as customer_email
    from {{ source('fudgeflix_v3','ff_accounts') }} a
    left join {{ source('fudgeflix_v3','ff_zipcodes') }} z
        on a.account_zipcode = z.zip_code

    union all

    --Stage FudgeMart Customers
    select
        cast(c.customer_id as varchar) as customer_id,
        'FudgeMart' as division,
        c.customer_firstname as customer_first_name,
        c.customer_lastname as customer_last_name,
        c.customer_address as customer_address,
        c.customer_city as customer_city,
        c.customer_state as customer_state,   -- standardize state column
        c.customer_zip as customer_postal_code,
        c.customer_phone as customer_phone,
        c.customer_email as customer_email
    from {{ source('fudgemart_v3','fm_customers') }} c
)

select
    {{ dbt_utils.generate_surrogate_key(['customer_id','division']) }} as customerkey,
    customer_id,  
    division,
    customer_first_name,
    customer_last_name,
    customer_address,
    customer_city,
    customer_state,
    customer_postal_code,
    customer_phone,
    customer_email
from stg_customers