
## Week 2 Questions:

## What is our overall conversion rate?
62.46% conversion rate
~~~~sql
WITH counts AS(
SELECT
  SUM(CASE
        WHEN checkout = 1 THEN 1
        ELSE 0
      END) AS checkouts,
  COUNT(DISTINCT session_guid) AS total_sessions
FROM dbt_sydney_b.fct_user_sessions
)
SELECT
  ROUND((checkouts::numeric/total_sessions::numeric)*100,2) AS conversion_rate
FROM counts;
~~~~

## What is our conversion rate by product?
~~~~sql



~~~~