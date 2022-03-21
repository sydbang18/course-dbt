{{
  config(
    materialized='table'
  )
}}


WITH orders AS(
SELECT
    user_guid,
    COUNT(*) AS total_orders_count,
    MIN(created_at) AS first_order_at,
    MAX(created_at) AS latest_order_at,
    SUM(order_cost) AS lifetime_order_costs_in_USD
    --??? whats the diff between order_cost and order_total
    --why is order_total less than order_cost??? one would assume order_total includes shipping
    --DATEDIFF('DAYS',MIN(created_at), GETDATE()) AS days_since_first_order
    --GETDATE() doesn't work here? urking me -__-
FROM {{ ref('stg_orders') }}
GROUP BY 1
)
SELECT
    stg_users.user_guid,
    stg_users.email,
    stg_users.phone_number,
    stg_users.created_at,
    stg_users.updated_at,
    stg_users.address_guid,
    orders.total_orders_count,
    orders.first_order_at,
    orders.latest_order_at,
    orders.lifetime_order_costs_in_USD
    --orders.days_since_first_order
FROM {{ ref('stg_users') }}
LEFT JOIN orders ON stg_users.user_guid = orders.user_guid