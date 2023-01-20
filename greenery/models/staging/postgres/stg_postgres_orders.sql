with src_orders as
  (select * from {{ source ('postgres', 'orders') }})

select * from src_orders