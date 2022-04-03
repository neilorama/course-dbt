## Question 1: What is the user repeat rate?
```sql
with orders as (
  select * from dbt_neil_m.stg_orders
  ),
  total_orders as (
  select 
    user_id,
    count(*) as total_orders
  from orders
  group by user_id
)

select 
  cast(
    sum(
      case when total_orders > 1 
      then 1
      else 0 
      end
    ) as float
  ) / count(*) as repeat_rate
from total_orders

Result: 0.7983870967741935
```

## Question 2: What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Things that may me good indicators that a user might purchase again
* LTV of user
* Total order count
* AOV or total spend
* frequency of orders
* discount usage
* funnel behaviour
* Item distribution

Things that may be bad indicators
* user shipping experience (delayed shipping etc) 
* bounce rate

If I had more data I would look into 
* retention marketing / order corralation
* advertising / order corralation
* product cycles (subscription products / product extensions)
* cohorting on geolocation
* cohorting on demographics
* product review scores

## Question 3: Within each marts folder, create intermediate models and dimension/fact models. Explain the marts models you added. Why did you organize the models in the way you did?

I followed the above indicators and tried to add them to the core / marketing.

#### Core

In core I added dim users and fct orders. Dim users contains all the user info merged with the user orders metric table. I though this would be useful for a BI tool to be able to segment users on their order metrics. I then added the fct_orders to allow for a wide table which would make segmentation easy.

#### Marketing

Marketing just uses the core dim users to output a table specific for marketing which should be easy to segment users on.


#### Product

I created 2 intermediate tables to aggregate general event metrics and to aggregate user specific event metrics. These were then imported into the fact tables.

## What assumptions are you making about each model? (i.e. why are you adding each test?)

* Primary keys should be all not null and unique.

## Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

I would use dbt cloud to run daily with slack notifications.