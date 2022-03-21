{{
  config(
    materialized='table'
  )
}}

select 
    user_id,
    initcap(trim(first_name)) as first_name,
    initcap(trim(last_name)) as last_name,
    lower(email) as email,
    trim(phone_number) as phone_number,
    created_at,
    updated_at,
    address_id

from {{ source('greenery','users')}}