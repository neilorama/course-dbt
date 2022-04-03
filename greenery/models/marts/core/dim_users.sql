{{
  config(
    materialized='table'
  )
}}

with customers
    as (select * from {{ ref('stg_users') }}),

order_metrics
    as (
        select *
        from {{ ref('int_user_order_metrics') }}
     )

select
  c.user_id,
  c.first_name,
  c.last_name,
  c.email,
  c.phone_number,
  c.created_at,
  c.updated_at,
  c.address_id,
  om.order_count,
  om.first_order_date,
  om.last_order_date,
  om.days_since_last_order,
  om.total_order_spend,
  om.avg_delivery_time,
  om.aov
from customers c
left join order_metrics om
on om.user_id = c.user_id