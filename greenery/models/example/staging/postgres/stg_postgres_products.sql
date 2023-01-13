with src_products as
  (select * from {{ source ('postgres', 'products') }})

select * from src_products