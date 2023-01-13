with src_promos as
  (select * from {{ source ('postgres', 'promos') }})

select * from src_promos