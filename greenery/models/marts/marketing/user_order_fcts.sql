{{
  config(
    materialized='table'
  )
}}


SELECT
  session_guid,
  dim_users.user_guid


FROM {{ ref('fct_orders') }}

--conversion rate is defined as the # of unique sessions
--with a purchase event / total number of unique sessions
--Conversion rate by product is defined as the # of unique
--sessions with a purchase event of that product / total number
--of unique sessions that viewed that product