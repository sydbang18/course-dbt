{{
  config(
    materialized='table'
  )
}}

WITH product_counts AS(
SELECT
    stg_order_items.order_guid,
    COUNT(DISTINCT product_guid) AS unique_product_count,
    SUM(quantity) AS total_product_count
FROM  {{ ref('stg_order_items') }}
GROUP BY 1
), delivery_state AS(
SELECT
  stg_orders.order_guid,
  CASE
    WHEN delivered_at > estimated_delivery_at THEN 'Late'
    WHEN delivered_at < estimated_delivery_at THEN 'Early'
    WHEN delivered_at = estimated_delivery_at THEN 'On Time'
    WHEN status = 'preparing' OR status = 'shipped' THEN 'In Progress'
    ELSE null
  END AS fulfillment_state
FROM {{ ref('stg_orders') }}
)
SELECT
    stg_orders.order_guid,
    stg_orders.user_guid,
    stg_orders.created_at,
    stg_orders.status,
    stg_orders.order_cost,
    stg_orders.order_total,
    stg_orders.shipping_service,
    stg_orders.promo_id AS order_promo_code,
    product_counts.total_product_count,
    product_counts.unique_product_count,
    delivery_state.fulfillment_state
FROM {{ ref('stg_orders') }}
LEFT JOIN  product_counts ON stg_orders.order_guid = product_counts.order_guid
LEFT JOIN delivery_state ON stg_orders.order_guid = delivery_state.order_guid
