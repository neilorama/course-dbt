{{
  config(
    materialized='table'
  )
}}

with orders
    as (select * from {{ ref('stg_orders') }}),

order_items
    as (
        select *
        from {{ ref('stg_order_items') }}
     ),

promos
    as (
        select *
        from {{ ref('stg_promos') }}
     ),

addresses
    as (
        select *
        from {{ ref('stg_addresses') }}
     ),

customer
    as (
        select *
        from {{ ref('stg_users') }}
     )

select 
    o.order_id,
    c.first_name,
    c.last_name,
    c.phone_number,
    c.email,
    a.address as shipping_address,
    oi.product_id,
    oi.quantity,
    o.created_at,
    o.net_revenue,
    o.total_shipping,
    o.gross_revenue,
    COALESCE(p.discount, 0) as discount_applied,
    o.estimated_delivery_at,
    o.delivered_at,
    o.shipping_service,
    o.tracking_id,
    o.status
from 
    orders o
left join
    customer c
on
    o.user_id = c.user_id
left join 
    addresses a
on
    o.address_id = a.address_id
left join
    promos p
on 
    o.promo_id = p.promo_id
left join
    order_items oi
on
    o.order_id = oi.order_id