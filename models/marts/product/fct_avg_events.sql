{{ config(materialized='table') }}

WITH num_events AS (
    SELECT
        created_at,
        COUNT(DISTINCT event_id) AS num_events

    FROM {{ ref('fct_events') }}
    GROUP BY 1
)

SELECT
    created_at,
    {{ rolling_average_periods('num_events', 'created_at', 'created_at', '6') }},
    {{ rolling_average_periods('num_events', 'created_at', 'created_at', '13') }},
    {{ rolling_average_periods('num_events', 'created_at', 'created_at', '27') }},
    {{ rolling_average_periods('num_events', 'created_at', 'created_at', '89') }}

FROM num_events
