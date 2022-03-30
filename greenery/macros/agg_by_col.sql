{% macro agg_by_col(table_name, column_name) %}

    {% set query %}
        select distinct {{ column_name }} from {{ table_name }}
    {% endset %}

    {# Ensures this macro does not fail in the parse phase of dbt run #}
    {% if execute %}
        {% set results = run_query(query).columns[0].values() %}

        {% for col in results %}
            sum(case when {{ column_name }} = '{{ col }}' then 1 else 0 end) as {{ col }}
            {% if not loop.last %},{% endif %}  {# adds comma to each row apart from last #}
        {% endfor %}
    {% else %}

    {% endif %}

{% endmacro %}