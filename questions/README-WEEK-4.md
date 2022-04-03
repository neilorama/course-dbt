## Part 1: Setup orders snapshot?
```
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
```
## Part 2: Funnel Results?
|label               |funnel_level_id|num_sessions|num_sessions_level_above|level_conversion|drop_off_relative|drop_off_absolute|
|--------------------|---------------|------------|------------------------|----------------|-----------------|-----------------|
|Just Page View      |1              |578         |                        |                |                 |                 |
|Up to Add to Cart.  |2              |467         |578                     |0.81            |0.19             |0.19             |
|Checkout            |3              |361         |467                     |0.77            |0.04             |0.23             |

## Part 3A: if your organization is using dbt, what are 1-2 things you might do differently / recommend to your organization based on learning from this course?
- I think this course has given me some more tools to analysis some of the trade offs and structural reasons for data modelling.
- I also believe the course has firmed up some best practices that can be added to our code review process.

## Part 3B: if your organization is using dbt, what are 1-2 things you might do differently / recommend to your organization based on learning from this course?
- I like the current stack I helped create with DBT at the heart which is below. I do think as we mature we may add in other ETL options, orchastration options etc
  - Sources -> Fivetran -> Snowflake -> DBT -> looker
