with src_users as
  (select * from {{ source ('postgres', 'users') }})

select * from src_users