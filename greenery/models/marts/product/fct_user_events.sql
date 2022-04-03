{{
  config(
    materialized='table'
  )
}}

with customer
    as (select * from {{ ref('stg_users') }} ),

event_metrics
    as (select * from {{ ref('int_user_events_metrics') }} )

SELECT
    c.user_id,
    c.first_name,
    c.last_name,
    c.phone_number,
    c.email,
    em.page_view_count,
    em.add_to_cart_count,
    em.checkout_count,
    em.package_shipped_count
from
    event_metrics em
left join
    customer c
on 
    em.user_id = c.user_id