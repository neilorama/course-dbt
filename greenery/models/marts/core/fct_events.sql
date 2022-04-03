{{
  config(
    materialized='table'
  )
}}

with stg_events as (
  select *
  from {{ ref('stg_events') }}
)

select 
    event_id,
    session_id,
    user_id,
    event_type,
    page_url,
    created_at,
    order_id,
    product_id
from stg_events