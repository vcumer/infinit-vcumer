WITH
    ranked_data AS (
    SELECT
        car_id,
        car_make,
        car_model,
        price,
        row_number() OVER(PARTITION BY meta_entity_id ORDER BY meta_processing_time DESC) AS rank
    FROM
        {{ source('infinit', 'cars') }}
    )
SELECT
    car_id      AS product_id,
    car_make    AS brand,
    car_model   AS model,
    price       AS price
FROM ranked_data
WHERE
    rank = 1