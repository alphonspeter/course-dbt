with src_events as
  (select * from {{ source ('postgres', 'events') }})

select * from src_events