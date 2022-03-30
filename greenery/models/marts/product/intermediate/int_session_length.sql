{{
  config(
    materialized='view'
  )
}}

SELECT
    session_guid,
    MIN(created_at) AS session_started_at,
    MAX(created_at) AS session_ended_at
FROM {{ ref('fct_events') }}
GROUP BY 1