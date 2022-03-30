{{
  config(
    materialized='table'
  )
}}

SELECT
    event_guid,
    session_guid,
    user_guid,
    created_at,
    page_url,
    event_type,
    order_guid,
    stg_events.product_guid,
    dim_products.product_name
FROM {{ ref('stg_events') }}
LEFT JOIN {{ ref('dim_products') }} ON dim_products.product_guid = stg_events.product_guid