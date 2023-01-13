1.How many users do we have? -130
```select count(distinct user_id) from stg_postgres_users```


2.On average, how many orders do we receive per hour? -- 7.52 orders
```
select 
    count(DISTINCT order_id) as "total orders",
    (DATEDIFF(day,min(created_at), max(created_at))+1) as days,
    count(DISTINCT order_id)/((DATEDIFF(day,min(created_at), max(created_at))+1)*24) as average
from RAW.PUBLIC.ORDERS
```
3.On average, how long does an order take from being placed to being delivered? -- 3.89 ~~ approx 4 days

```with delivery_not_null as 
(select * from stg_postgres_orders 
where delivered_at is not null)
select 
count(*) as total_orders,
sum(datediff(day, created_at, delivered_at)) as total_days,
sum(datediff(day, created_at, delivered_at)) / count(*) as average_days_to_deliver
from delivery_not_null```

4.How many users have only made one purchase? Two purchases? Three+ purchases? 
one_order -	25
two_orders -	28
three_or_more_orders -	71

```with source_cte as (
select o.user_id as user, count(distinct order_id) as total_orders from stg_postgres_orders o
left join stg_postgres_users u on u.user_id = o.user_id
group by 1)

select  (case when total_orders = 1 then 'one_order'
             when total_orders = 2 then 'two_orders'
             when total_orders >=3 then 'three_or_more_orders' end) as no_of_orders, count(*) as total_orders
 from source_cte
 group by 1
 order by count(*)```

5.On average, how many unique sessions do we have per hour? -- approx 40 sessions

```WITH HOURS AS (
select HOUR(CREATED_AT) as hour, count(distinct session_id) as sessions  
from stg_postgres_events
GROUP BY 1
ORDER BY 1 ASC)
Select sum(sessions)/ count(hour) as average_sessions from hours ```


