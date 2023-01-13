with src_order_items as
  (select * from {{ source ('postgres', 'order_items') }})

select * from src_order_items