-- connects orders to users -- not all users will have an order : also we check order placement dates from order table
Select 
     users.USER_ID
    ,MIN(orders.CREATED_AT) AS First_Order_Date
    ,MAX(orders.CREATED_AT) AS Last_Order_Date
    ,COUNT(orders.ORDER_ID) AS Orders
    
    ,SUM(ORDER_COST) AS Total_Order_Cost
    ,SUM(SHIPPING_COST) AS Total_Shipping_Cost
    ,SUM(ORDER_TOTAL) AS Order_and_Shipping_Total

from {{ ref('stg_postgres_users') }} as users
left join {{ ref('stg_postgres_orders') }} as orders on users.user_id = orders.user_id
group by 1

