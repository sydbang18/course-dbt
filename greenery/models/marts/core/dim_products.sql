{{
  config(
    materialized='table'
  )
}}


WITH counts AS(
SELECT
  product_guid,
  SUM(quantity) AS total_orders,
  MIN(created_at) AS first_ordered_at
FROM {{ ref('stg_orders') }}
LEFT JOIN {{ ref('stg_order_items') }} ON stg_order_items.order_guid = stg_orders.order_guid
GROUP BY 1
)
SELECT
  stg_products.product_guid,
  name,
  price,
  inventory,
  counts.total_orders AS total_purchased_count,
  counts.first_ordered_at
FROM {{ ref('stg_products') }}
LEFT JOIN counts ON stg_products.product_guid = counts.product_guid