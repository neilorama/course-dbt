{{
  config(
    materialized='table'
  )
}}
with int_session_events_agg as (
  select
    *
  from
    {{ ref('int_session_events_agg') }}
),
denominator as (
  select
    product_id,
    count(distinct session_id)::numeric as views
  from
    int_session_events_agg
  where
    page_view = 1
  group by
    1
),
numerator as (
  select
    stg_order_items.product_id,
    count(distinct int_session_events_agg.order_id)::numeric as purchases
  from
    int_session_events_agg
    join {{ ref('stg_order_items') }} using(order_id)
  where
    int_session_events_agg.order_id is not null
    and checkout = 1
  group by
    1
)
select 
  denominator.product_id,
  dim_products.name as product_name,
  denominator.views,
  numerator.purchases
from
  denominator
  left join numerator on denominator.product_id = numerator.product_id
  left join {{ ref('dim_products') }} on denominator.product_id = dim_products.product_id