{{-
    config(
        materialized='view'
    )
}}

SELECT
    product_id,
    brand,
    model,
    price
FROM {{ ref('cars') }}