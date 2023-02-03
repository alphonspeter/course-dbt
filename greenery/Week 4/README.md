1. Which orders changed from week 3 to week 4? 
```
select order_id, status, dbt_valid_from, dbt_valid_to from orders_snapshot where 
order_id in (SELECT order_id FROM ORDERS_SNAPSHOT
WHERE DBT_VALID_TO ::DATE = '2023-02-03') 
order by order_id, dbt_valid_to asc
```

0e9b8ee9-ad0a-42f4-a778-e1dd3e6f6c51, df91aa85-bfc7-4c31-93ef-4cee8d00a343, 841074bf-571a-43a6-963c-ba7cbdb26c85 : all three orders updates from 'preparing' to 'shipped' 

2. Exposure has been added in the Marketing folder 

3. if your organization is thinking about using dbt, how would you pitch the value of dbt/analytics engineering to a decision maker at your organization?
if your organization is using dbt, what are 1-2 things you might do differently / recommend to your organization based on learning from this course?
if you are thinking about moving to analytics engineering, what skills have you picked that give you the most confidence in pursuing this next step?

Our team already uses DBT: it was mainly done by engineering: moving from a business analyts to anaylitical engineer means we get more control over the data we use to serve our stakeholders. 
DBT/ analytical engineering is great in the sense of version control, defining metrics, understanding dependecies etc with ease. 
Skills i have picked is understanding structure of a completely new dbt project: how to check errors while creating models, where to place the .yml files and how to optimise or reduce DRY codes using macros. 

4. How would you go about setting up a production/scheduled dbt run of your project in an ideal state? 

We currently use airflow to orchestrate the runs for tables and DBT cloud for main models. 
Schedule should be based on parent timings: i ebelieve we can set this in cron setup in DBT
I would like to see Metadata like artifacts --> sources.json for freshness check, run_results.json for checking performances of models over time
Also Exposures seems great to see the downstream effects if I plan to make changes to a model in my instance. 