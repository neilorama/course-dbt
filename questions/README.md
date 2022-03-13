## Question 1: How many users do we have?
```sql
select count(user_id) as users_count from users;

Result: 130
```

## Question 2: On average, how many orders do we receive per hour?
```sql
with orders_count_per_hour as (
    select count(*) as orders_count from orders
    group by date_trunc('hour', created_at)
)

select round(avg(orders_count), 2) from orders_count_per_hour;

Result: 7.52
```

## Question 3: On average, how long does an order take from being placed to being delivered?
```sql
select avg(delivered_at - created_at) from orders;

Result: 3 days 21:24:11.803279
```

## Question 4: How many users have only made one purchase? Two purchases? Three+ purchases?
```sql
with user_order_count as (
  select 
  	user_id,
  	count(1) as count
  from orders
  group by user_id
),
purchase_cats as (
  select 
    case
    when count = 1 then 'One Purchase'
	when count = 2 then 'Two Purchases' 
	else 'Three+ Purchases'
	end as categories 
  from 
    user_order_count
)
select 
	categories, 
	count(1) 
from purchase_cats
group by categories;
```
Result
| categories        | count |
| ----------------- | ----- |
| One Purchase      | 25    |
| Two Purchases     | 28    |
| Three+ Purchases  | 71    |

## Question 5: On average, how many unique sessions do we have per hour?
```sql
with session_count_per_hour as (
  select
    count(distinct session_id) as session_count
  from events 
  group by date_trunc('hour', created_at)
)

select round(avg(session_count), 2) from session_count_per_hour

Result: 16.33
```