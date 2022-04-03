{{
  config(
    materialized='table'
  )
}}

with orders
    as (select * from {{ ref('stg_orders') }} )

select user_id,
       count(0) as order_count,
       min(created_at) as first_order_date,
       max(created_at) as last_order_date,
       now() - max(created_at) as days_since_last_order,
       sum(net_revenue) as total_order_spend,
       avg(orders.delivered_at - orders.created_at) as avg_delivery_time,
       sum(total_shipping) / count(0) as avg_shipping_cost,
       sum(net_revenue) / count(0) as aov
from orders
group by user_id