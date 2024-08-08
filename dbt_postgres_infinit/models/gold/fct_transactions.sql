{{
    config(
        indexes=[{'columns': ['client_name']},
                 {'columns': ['brand']},
                 {'columns': ['model']}]
    )
}}


SELECT
    transaction_id,
    transaction_datetime,
    client_name,
    model,
    brand,
    product_quantity_sold,
    turnover,
    price * product_quantity_sold AS market_value
FROM {{ ref('transactions') }}
LEFT JOIN {{ ref('clients') }} USING (client_id)
LEFT JOIN {{ ref('cars') }} USING (product_id)

