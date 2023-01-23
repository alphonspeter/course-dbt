{{
  config(
    materialized='view'
  )
}}

Select 
    USER_ID
    ,FIRST_NAME
    ,LAST_NAME
    ,EMAIL
    ,PHONE_NUMBER
    ,CREATED_AT
    ,UPDATED_AT
    ,COALESCE(users.ADDRESS_ID, addresses.ADDRESS_ID) as ADDRESS_ID

    ,ADDRESS
    ,ZIPCODE
    ,STATE
    COUNTRY

from {{ ref('stg_postgres_users') }} as users
left join {{ ref('stg_postgres_addresses') }} as addresses on users.ADDRESS_ID = addresses.ADDRESS_ID