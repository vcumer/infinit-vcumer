{{
    config(
        indexes=[{'columns': ['client_name']},
                 {'columns': ['brand']},
                 {'columns': ['model']}]
    )
}}

WITH
    monthly_data AS (
    SELECT
        DATE_TRUNC('month', transaction_datetime)       AS month,
        client_name,
        model,
        brand,
        COUNT(DISTINCT transaction_id)                  AS nb_transactions,
        SUM(product_quantity_sold)                      AS product_quantity_sold,
        SUM(turnover)                                   AS turnover,
        SUM(market_value)                               AS market_value
        -- AVG((turnover - market_value) / market_value)   AS avg_discount
    FROM {{ ref('fct_transactions') }}
    GROUP BY
        month,
        client_name,
        model,
        brand
    ),
    month_list AS (
    SELECT
        date_trunc('month', generate_series('2023-01-01'::timestamp,'2024-07-01'::timestamp, interval '1 month')) AS month
    ),
    all_months_data AS (
    SELECT DISTINCT
        m.month,
        client_name,
        model,
        brand
    FROM month_list AS m
    CROSS JOIN monthly_data
    )
SELECT
    month,
    client_name,
    model,
    brand,
    nb_transactions,
    lag(nb_transactions, 1) over (partition by  client_name, model, brand order by month) AS nb_transactions_last_month,
    product_quantity_sold,
    lag(product_quantity_sold, 1) over (partition by  client_name, model, brand order by month) AS product_quantity_sold_last_month,
    turnover,
    lag(turnover, 1) over (partition by  client_name, model, brand order by month) AS turnover_last_month,
    market_value,
    lag(market_value, 1) over (partition by  client_name, model, brand order by month) AS market_value_last_month
FROM all_months_data
LEFT JOIN monthly_data
USING (month, client_name, model, brand)
ORDER BY
    client_name,
    model,
    brand,
    month DESC
