1. Repeat rate -- approx 80%
```
With source as (select user_id, count(*) as total_orders from stg_postgres_orders
group by 1
order by 2 desc
)```
 
select count(distinct case when total_orders >1 then user_id end) as repeat_users, count(user_id) as total_users,
count(distinct case when total_orders >1 then user_id end) / count(user_id) *100 as repeat_rate
from source

2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

To create a scoring metric for prediction based on demographics such as age, B2B or B2C customer, session lengths in total, total orders, conversion rate per user id, use of promo id etc. 
```
with events as (
select user_id, count(*) as sessions from stg_postgres_events
group by 1),

orders as (select user_id, count(*) as sales from stg_postgres_orders
group by 1)

select e.user_id, sum(sessions), sum(sales), sum(sales)/ sum(sessions) *100 as Conversion_rate
from events e 
left join orders o on e.user_id = o.user_id
group by 1
order by 3 desc```

3. Why did you organise the models in the way you did? (only includig fact/dim that is modelled with more than one staging model)

a. CORE : dim_users- user dimension is designed to build a connection between user and their address details as this belongs in same table as address is something that enriches a user profile 

b. Marketing: from marketing perspective, understanding user behaviour is important: so enriching user data with order data would give insights into how frequently users are engaging with our site and how much are they investing on our products on average

c. Product : fact_product_measures : from product perspective a funnel starting from sessions till orders is needed to understand the conversion rates across each phase for a product. Such as drop out rate per product across process funnel like sessions, views, add to carts, check out etc. 
So enriching product data with event data will provide the initial part of funnel like sessions, views etc: and connecting product items with order data, will show how many sales we are getting: combining both gives entire pipeline and it conversion based on products. 

4 What assumptions are you making about each model? (i.e. why are you adding each test?) & Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

Didnt find any incorrectable data. 
One quick addition would be Events source not having order_id across a particualar session: 
it only get passed order_id, once the event type is 'checkout' or 'package shipped' - this causes us to combine sessions data with order data to get entire funnel process per product id. 

The tests are available under _core_model.yml, _marketing_model.yml and _product_midel.yml. 
Basic tests such as positive values for orders, costs etc. Unique and not_null tests for primary keys such as order_id, session-id, product_id. 

5. Run the orders snapshot model using dbt snapshot and query it in snowflake to see how the data has changed since last week. 
Which orders changed from week 1 to week 2? 

```
select * from orders_snapshot
where order_id in ('b4eec587-6bca-4b2a-b3d3-ef2db72c4a4f',
'e42ba9a9-986a-4f00-8dd2-5cf8462c74ea',
'265f9aae-561a-4232-a78a-7052466e46b7') ```

All three orders status moved from 'preparing' to 'shipped'