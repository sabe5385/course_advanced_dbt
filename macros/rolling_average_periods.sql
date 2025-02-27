{% macro rolling_average_periods(column_name, partition_by, order_by='created_at', periods=6) %}
    avg( {{ column_name }} ) OVER (
                PARTITION BY {{ partition_by }}
                ORDER BY {{ order_by }}
                ROWS BETWEEN {{ periods }} PRECEDING AND CURRENT ROW
            ) AS avg_{{ periods }}_periods_{{ column_name }}
{% endmacro %}
