{{
  config(
    materialized='table'
  )
}}

select 
    product_id,
    name,
    price,
    inventory

from {{ source('greenery','products')}}