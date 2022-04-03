## Question 1: What is the overall conversion rate?
```sql
with fct_sessions as (
    select *
    from dbt_neil_m.fct_sessions
)

select
    sum(case 
        when checkout = 1 and order_id is not null
        then 1 else 0 emd)::numeric / 
    count(distinct session_id)::numeric as conversion_rate                           
from fct_sessions

Result: 0.62456747404844290657
```

## Question 2: What is our conversion rate by product?
```sql
with int_conversion_events as ( 
    select *
    from dbt_neil_m.int_product_conversion_events
)

select product_name, 
       round(purchases / views, 4) as conversion_rate
from int_conversion_events
order by 2 desc
```

Result:
| product_name      | conversion_rate |
| ----------------- | --------------- |
| String of pearls  | 0.6094          |
| Arrow Head        | 0.5556          |
| Cactus            | 0.5455          |
| ZZ Plant          | 0.5397          |    
| Bamboo            | 0.5373          |
