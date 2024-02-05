--This macro truncates date_time values to month

{% macro trunc_to_month(date_time) %}
    DATE(DATE_TRUNC('month', {{ date_time }}))

{% endmacro %}
