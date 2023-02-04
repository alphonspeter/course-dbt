1. Which orders changed from week 3 to week 4? 
```
select order_id, status, dbt_valid_from, dbt_valid_to from orders_snapshot where 
order_id in (SELECT order_id FROM ORDERS_SNAPSHOT
WHERE DBT_VALID_TO ::DATE = '2023-02-03') 
order by order_id, dbt_valid_to asc
```

0e9b8ee9-ad0a-42f4-a778-e1dd3e6f6c51, df91aa85-bfc7-4c31-93ef-4cee8d00a343, 841074bf-571a-43a6-963c-ba7cbdb26c85 : all three orders updates from 'preparing' to 'shipped' 

2. How are our users moving through the product funnel? Which steps in the funnel have largest drop off points?
```
select sum(PAGE_VIEW_OCCURENCE)    AS "Page Views",
        sum(ADD_TO_CART_OCCURENCE) / sum(PAGE_VIEW_OCCURENCE) * 100 as "Conversion Rate 1",  -- 52% 
        sum(ADD_TO_CART_OCCURENCE) AS "Add to Carts",
        sum(CHECKOUT_OCCURENCE)/sum(ADD_TO_CART_OCCURENCE) * 100 as "Conversion Rate 2", -- 36%
        sum(CHECKOUT_OCCURENCE)     AS "Check outs"
  from fact_event_types_per_session ;
```

But using the above code, Conversion rate 2 wont make sense as a session can have many "add to carts" and still only one or zero "check outs". So the more products you add to cart it drives the CR2 down as there is only one checkout if you buy the order. 


So we have to calculate "add to cart" in distinct and non-distcint ways using stg_postgres_events
```
With Base as (select count( case when event_type = 'page_view' then e.session_id end) as total_page_views
    , count( case when event_type = 'add_to_cart'then e.session_id end) as total_add_to_carts
    , count( distinct case when event_type = 'add_to_cart'then e.session_id end) as total_add_to_carts_distinct
    ,count( distinct case when event_type = 'checkout' then e.session_id end) as total_checkouts -- dont matter distinct /not (its always one event)
 from stg_postgres_events e)
 
select  total_page_views, 
        total_add_to_carts/ total_page_views * 100 as "Cconversion Rate 1",  -- 52% same as above
        total_add_to_carts,
        total_add_to_carts_distinct,
        total_checkouts  / total_add_to_carts_distinct * 100 as "Conversion Rate 2", -- 77% 
        total_checkouts
from base; 
```

3. Exposure has been added in the Marketing folder 

4. if your organization is thinking about using dbt, how would you pitch the value of dbt/analytics engineering to a decision maker at your organization?
if your organization is using dbt, what are 1-2 things you might do differently / recommend to your organization based on learning from this course?
if you are thinking about moving to analytics engineering, what skills have you picked that give you the most confidence in pursuing this next step?

Our team already uses DBT: it was mainly done by engineering: moving from a business analyts to anaylitical engineer means we get more control over the data we use to serve our stakeholders. 
DBT/ analytical engineering is great in the sense of version control, defining metrics, understanding dependecies etc with ease. 
Skills i have picked is understanding structure of a completely new dbt project: how to check errors while creating models, where to place the .yml files and how to optimise or reduce DRY codes using macros. 

5. How would you go about setting up a production/scheduled dbt run of your project in an ideal state? 

We currently use airflow to orchestrate the runs for tables and DBT cloud for main models. 
Schedule should be based on parent timings: i ebelieve we can set this in cron setup in DBT
I would like to see Metadata like artifacts --> sources.json for freshness check, run_results.json for checking performances of models over time
Also Exposures seems great to see the downstream effects if I plan to make changes to a model in my instance. 