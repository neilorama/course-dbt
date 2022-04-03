{{
  config(
    materialized='table'
  )
}}

with customers
    as (select * from {{ ref('dim_users') }})

select
  c.first_name,
  c.last_name,
  c.email,
  c.phone_number,
  c.created_at,
  c.updated_at,
  c.address_id,
  c.order_count,
  c.first_order_date,
  c.last_order_date,
  c.days_since_last_order,
  c.total_order_spend,
  c.avg_delivery_time,
  c.aov
from customers c