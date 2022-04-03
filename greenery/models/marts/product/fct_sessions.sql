{{
  config(
    materialized='table'
  )
}}
with session_length as (
  select
    session_id,
    min(created_at) as first_event,
    max(created_at) as last_event
  from
    {{ ref('fct_events') }}
  group by
    session_id
),
stg_products as (
  select
    *
  from
    {{ ref('stg_products') }}
)
select
  int_session_events_agg.session_id,
  int_session_events_agg.user_id,
  dim_users.first_name,
  dim_users.last_name,
  dim_users.email,
  int_session_events_agg.page_view,
  int_session_events_agg.add_to_cart,
  int_session_events_agg.checkout,
  int_session_events_agg.order_id,
  int_session_events_agg.product_id,
  int_session_events_agg.package_shipped,
  session_length.first_event as first_session_event,
  session_length.last_event as last_session_event,
  (
    date_part(
      'day',
      session_length.last_event :: timestamp - session_length.first_event :: timestamp
    ) * 24 + date_part(
      'hour',
      session_length.last_event :: timestamp - session_length.first_event :: timestamp
    ) * 60 + date_part(
      'minute',
      session_length.last_event :: timestamp - session_length.first_event :: timestamp
    )
  ) as session_length_minutes,
  stg_products.name as product_name,
  price,
  inventory
from
  {{ ref('int_session_events_agg') }}
  left join {{ ref('dim_users') }} on int_session_events_agg.user_id = dim_users.user_id
  left join session_length on int_session_events_agg.session_id = session_length.session_id
  left join stg_products on int_session_events_agg.product_id = stg_products.product_id