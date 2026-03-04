with stg_orders as (
select orderid,
{{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey,
{{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey,
replace(to_date(orderdate)::varchar,'-','')::int as orderdatekey,
from {{source('northwind','Orders')}}),

stg_order_details as (
select {{ dbt_utils.generate_surrogate_key(['productid']) }}  as productkey,
quantity,
unitprice,
discount,
orderid
from {{source('northwind','Order_Details')}})

select o.*,
od.productkey,
od.quantity,
quantity*unitprice as extendedpriceamount,
(quantity*unitprice)*discount as discountamount,
(quantity*unitprice) - ((quantity*unitprice)*discount) as soldamount
from stg_orders o
join stg_order_details od on o.orderid = od.orderid