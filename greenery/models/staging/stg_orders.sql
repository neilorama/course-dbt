{{
  config(
    materialized='table'
  )
}}

select 
    order_id,
    user_id,
    promo_id,
    address_id,
    created_at,
    order_cost as net_revenue,
    shipping_cost as total_shipping,
    order_total as gross_revenue,
    tracking_id,
    shipping_service,
    estimated_delivery_at,
    delivered_at,
    status

from {{ source('greenery','orders')}}