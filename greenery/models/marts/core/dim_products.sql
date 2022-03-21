{{
  config(
    materialized='table'
  )
}}


WITH counts AS(
SELECT
  product_guid,
  SUM(quantity) AS total_orders
  MIN()
FROM {{ ref('stg_order_items') }}
LEFT JOIN
GROUP BY 1
)
SELECT
  stg_products.product_guid,
  name,
  price,
  inventory,
  counts.total_orders AS total_purchased_count
FROM {{ ref('stg_products') }}
LEFT JOIN counts ON stg_products.product_guid = counts.product_guid