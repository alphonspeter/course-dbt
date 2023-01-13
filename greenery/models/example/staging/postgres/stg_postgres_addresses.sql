with src_addresses as
  (select * from {{ source ('postgres', 'addresses') }})

select * from src_addresses
