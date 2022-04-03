{% snapshot snap_order_status %}

  {{
    config(
      target_schema='dbt_neil_m',
      unique_key='order_id',
      strategy='check',
      check_cols=['status'],
    )
  }}

  select * from {{ source('greenery', 'orders') }}

{% endsnapshot %}