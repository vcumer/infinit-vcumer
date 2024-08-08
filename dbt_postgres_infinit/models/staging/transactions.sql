{{-
    config(
        partition_by={
          'field': 'transaction_time',
          'data_type': 'timestamp',
          'granularity': 'day'
        }
    )
}}

WITH
    ranked_data AS (
    SELECT
        transaction_id,
        product_id,
        client_id,
        quantity,
        price,
        timestamp,
        row_number() OVER(PARTITION BY meta_entity_id ORDER BY meta_processing_time DESC) AS rank
    FROM
        {{ source('infinit', 'transactions') }}
    )
SELECT
    transaction_id,
    product_id,
    client_id,
    quantity                                            AS product_quantity_sold,
    price * quantity                                    AS turnover,
    timestamp                                           AS transaction_time,
    timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'CET'     AS transaction_datetime
FROM ranked_data
WHERE
    rank = 1
