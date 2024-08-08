{{-
    config(
        materialized='view'
    )
}}

SELECT
    client_id,
    client_name,
    client_email
FROM {{ ref('clients') }}