{{
  config(
    materialized='table'
  )
}}

with event_agg
    as (select * from {{ ref('int_events_agg') }} )

select
    ea.user_sessions_with_checkout,
    ea.user_sessions_without_checkout,
    ea.user_sessions_abandoned_cart
from
    event_agg ea