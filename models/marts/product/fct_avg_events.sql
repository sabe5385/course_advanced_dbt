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
    {{ rolling_average_periods('num_events', 'created_at', 'created_at', '7') }},
    {{ rolling_average_periods('num_events', 'created_at', 'created_at', '14') }},
    {{ rolling_average_periods('num_events', 'created_at', 'created_at', '28') }},
    {{ rolling_average_periods('num_events', 'created_at', 'created_at', '90') }}

FROM num_events
