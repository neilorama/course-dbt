{{
  config(
    materialized='table'
  )
}}

with events
    as (select * from {{ ref('stg_events') }} )

SELECT
    e.user_id,
    e.session_id,
    sum(case when e.event_type = 'page_view' then 1 else 0 end) as page_view_count,
    sum(case when e.event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart_count,
    sum(case when e.event_type = 'checkout' then 1 else 0 end) as checkout_count,
    sum(case when e.event_type = 'package_shipped' then 1 else 0 end) as package_shipped_count
from
    events e
GROUP BY
    user_id, session_id