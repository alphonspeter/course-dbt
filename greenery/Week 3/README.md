1) What is our overall conversion rate? -- 62.45%
We can derive this answer from stg_postgres_events direct
```
select count(distinct session_id) as total_sessions,
count (distinct case when order_id is not null then session_id end) as sessions_with_purchase,
count (distinct case when order_id is not null then session_id end) / count(distinct session_id) * 100 as conversion_rate
from stg_postgres_events
```

2) What is our conversion rate by product?
The fact_product_measures table is made of two CTEs 
Connecting events to products, we can see how many views, add to carts etc each product gets: its done this way as some products might not be in events data as they are not viewed
Then we connect orders data to order items so we can see per product the order ids: helps us to count total order per product
Connecting both CTEs we get below table
```
select f.product_id, p.name, sum(total_orders)/ sum(total_sessions) as conversion_rate from fact_product_measures f
left join stg_postgres_products p on f.product_id = p.product_id
group by 1,2
order by 1 
```

