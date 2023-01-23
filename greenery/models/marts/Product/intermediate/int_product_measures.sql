{{
  config(
    materialized='view'
  )
}}

    with product_event_data as (
    SELECT 
    p.product_id
    , date (e.created_at)      as event_date 
    , count(distinct case when event_type = 'page_view' then e.event_id end) as total_page_views
    , count(distinct case when event_type = 'add_to_cart'then e.event_id end) as total_add_to_carts
    , count(distinct session_id) as total_sessions
    FROM {{ ref('stg_postgres_products') }} p
    left join {{ ref('stg_postgres_events') }} e on e.product_id = p.product_id
    group by 1,2
    order by 1,2 asc
)

, order_item_data as (
    SELECT 
    oi.product_id
    , date (o.created_at)      as order_created_date 
    , count(distinct oi.order_id) as total_orders
    FROM {{ ref('stg_postgres_order_items') }}  oi
    left join {{ ref('stg_postgres_orders') }}  o on o.order_id = oi.order_id
    group by 1,2
    order by 1,2 asc
)

select 
    coalesce(pe.product_id, oi.product_id) as product_id
    , coalesce(pe.event_date, oi.order_created_date) as date 
    , total_page_views
    , total_add_to_carts
    , total_sessions
    , coalesce(total_orders, 0) as total_orders
    from product_event_data pe
    full join order_item_data as oi on oi.product_id = pe.product_id and oi.order_created_date = pe.event_date
