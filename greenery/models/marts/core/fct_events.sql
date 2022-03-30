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
    product_guid
FROM {{ ref('stg_events') }}