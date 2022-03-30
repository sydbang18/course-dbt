{{
  config(
    materialized='table'
  )
}}

WITH users AS(
SELECT
    *
FROM {{ ref('dim_users')}}
), session_lengths AS(
SELECT
    session_guid,
    MIN(created_at) AS session_started_at,
    MAX(created_at) AS session_ended_at
FROM {{ ref('fct_events') }}
GROUP BY 1
), user_sessions AS(
SELECT
    session_guid,
    product_guid,
    product_name,
    created_at,
    user_guid,
    {{ agg_by_col('events', 'event_type') }}
FROM {{ ref('fct_events') }}
{{ dbt_utils.group_by(5) }}
)
SELECT
    user_sessions.session_guid,
    user_sessions.user_guid,
    user_sessions.product_guid,
    user_sessions.product_name,
    users.email,
    user_sessions.page_view,
    user_sessions.add_to_cart,
    user_sessions.checkout,
    user_sessions.package_shipped,
    EXTRACT(epoch from (session_lengths.session_ended_at::timestamp - session_lengths.session_started_at::timestamp)) / 60 AS session_length_minutes
FROM user_sessions
LEFT JOIN users ON users.user_guid = user_sessions.user_guid
LEFT JOIN  session_lengths ON session_lengths.session_guid = user_sessions.session_guid