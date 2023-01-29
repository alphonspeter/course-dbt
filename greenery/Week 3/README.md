1) What is our overall conversion rate? -- 62.45%

We can derive this answer from stg_postgres_events direct
```
select count(distinct session_id) as total_sessions,
count (distinct case when order_id is not null then session_id end) as sessions_with_purchase,
count (distinct case when order_id is not null then session_id end) / count(distinct session_id) * 100 as conversion_rate
from stg_postgres_events
```

2) What is our conversion rate by product?

The fact_product_measures table is made of two CTEs. 
Connecting events to products, we can see how many views, add to carts etc each product gets: its done this way as some products might not be in events data as they are not viewed. 
Then we connect orders data to order items so we can see per product the order ids: helps us to count total order per product. 
Connecting both CTEs we get below table. 
```
select f.product_id, p.name, sum(total_orders)/ sum(total_sessions) as conversion_rate from fact_product_measures f
left join stg_postgres_products p on f.product_id = p.product_id
group by 1,2
order by 1 
```
Running this query provides the conversion rate by product

3) Which orders changed from week 2 to week3?
```
select * from orders_snapshot
   where order_id in ( select order_id 
                        from orders_snapshot 
                        where dbt_valid_to :: date = '2023-01-29'
                     )
   order by order_id,  dbt_valid_from asc; 
```

--29d20dcd-d0c4-4bca-a52d-fc9363b5d7c6, c0873253-7827-4831-aa92-19c38372e58d, e2729b7d-e313-4a6f-9444-f7f65ae8db9a : all three orders changed from 'preparing' to 'shipped'
