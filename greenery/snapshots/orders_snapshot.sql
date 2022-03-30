{% snapshot orders_snapshot %}

{{
    config(
      target_database='dbt',
      target_schema='snapshots',
      unique_key='order_guid',

      strategy='timestamp',
      updated_at='updated_at',
    )
}}

select * from {{ source('tutorial', 'orders') }}

{% endsnapshot %}