{{
  config(
    materialized='table'
  )
}}
{%
set
  event_types = dbt_utils.get_query_results_as_dict(
    "select distinct quote_literal(event_type) as event_type, event_type as column_name from" ~ ref('fct_events')
  ) 
%}
with fct_events as (
    select
      *
    from
      {{ ref('fct_events') }}
  ) -- for every event type get the number of events of that type per user
SELECT
  session_id,
  created_at,
  user_id,
  product_id,
  order_id 
{% for event_type in event_types ['event_type'] %},
  SUM(
    CASE
      WHEN event_type = {{ event_type }} THEN 1
      ELSE 0
    END
  ) AS {{ event_types ['column_name'] [loop.index0] }}
{% endfor %}
FROM
  fct_events
  {{ dbt_utils.group_by(5) }}