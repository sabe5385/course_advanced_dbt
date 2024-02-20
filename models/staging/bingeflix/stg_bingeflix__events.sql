{{
    config(
        materialized='incremental',
        unique_key='event_id'
    )
}}

WITH source AS (

    SELECT * FROM {{ source('bingeflix', 'events') }}

),

renamed AS (

    SELECT
        session_id,
        created_at,
        user_id,
        event_name,
        event_id

    FROM source

    {% if is_incremental() %}

     WHERE created_at > (SELECT DATEADD(DAYS, -3, TO_DATE(MAX(created_at))) FROM {{ this }})

    {% endif %}

)

SELECT * FROM renamed
