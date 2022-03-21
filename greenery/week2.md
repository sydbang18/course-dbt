
## Week 2 Questions:

## What is our user repeat rate?
-- 79.8%
~~~~sql
--repeat users rate (ppl that purchased 2+ times)
WITH orders_per_user AS(
SELECT
  user_guid,
  COUNT(*) AS order_count
FROM dbt_sydney_b.stg_orders
GROUP BY 1
), repeat_customers AS(
SELECT
  user_guid,
  CASE
    WHEN order_count >= 2 THEN 1
    WHEN order_count < 2 THEN 0 
    ELSE NULL
  END AS repeat_customer
FROM orders_per_user
)
SELECT
 SUM(repeat_customer)::float/COUNT(*)::float AS repeat_rate
FROM repeat_customers

~~~~

## What are good indicators of a user who will likely purchase again? What about indicators of users who are NOT likely to purchase again? If you had more data, what features would you want to look into to answer this question?
Good indicators for users who are likely to purchase again would be users who;
- initially purchased using a promo code and then had an additional order without a promo code aka promo code worked as a converter
- received their order before the estimated_delivery_at indicating a positive fulfillment experience
- have a low order_total, indicating they may be inclined to order additional items
- high event session frequency


Good indicators for users who are NOT likely to purchase again would be users who;
- received their order late
- high total order cost or big order

If you had more data, what features would you want to look into to answer this question?
- Build out the dimensions below for deeper analysis
- Customer NPS survey data
- Channel used to order (app users tend to return at higher rates)
- Demographic information
- Effect of promo codes

## to add to dim_users
~~~~sql
/*
user_country,
promos_used,
orders_count,
first_user_activity_at,
days_since_first_activity,
first_order_at,
days_since_first_order,
latest_order_at
days_since_latest_order,
latest_activity_at,
days_since_latest_activity,
live_orders_count,
lifetime_order_value_in_USD,
first_ordered_product,
last_ordered_product,
most_products_in_one_order,
biggest_order_value_in_USD
*/
~~~~

## to add to dim_products
~~~~sql
/*
live_inventory,
lifetime_inventory,
avg_purchases_per_month,
order_count,
--orders include live orders
purchase_count,
-- purchased count only includes orders that were successfully fulfilled
lifetime_value_in_USD,
first_order_at,
first_purchase_at,
latest_order_at,
latest_purchase_at,
live_orders_count,
min_hours_to_fulfillment,
avg_hours_to_fulfillment,
max_hours_to_fulfillment,
most_delivered_to_country,
first_time_order_count
*/
~~~~
