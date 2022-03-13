
select
    address_id,
    trim(address) as address,
    state,
    zipcode,
    country

from {{ source('greenery', 'addresses') }}