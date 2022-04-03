{{
  config(
    materialized='table'
  )
}}

with user_events
    as (select * from {{ ref('int_user_events_metrics') }} )

select
    count(distinct case when ue.checkout_count = 1 then ue.session_id else null end) as user_sessions_with_checkout,
    count(distinct case when ue.checkout_count = 0 then ue.session_id else null end) as user_sessions_without_checkout,
    count(distinct case when ue.checkout_count = 0 and ue.add_to_cart_count >=1 then ue.session_id else null end) as user_sessions_abandoned_cart
from
    user_events ue