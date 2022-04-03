{{
  config(
    materialized='table'
  )
}}

with stg_products as (
  select *
  from {{ ref('stg_products') }}
)

select
    product_id,
    name,
    price,
    inventory
from stg_products