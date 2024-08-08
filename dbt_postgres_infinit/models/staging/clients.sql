WITH
    ranked_data AS (
    SELECT
        client_id,
        name,
        email,
        row_number() OVER(PARTITION BY meta_entity_id ORDER BY meta_processing_time DESC) AS rank
    FROM
        {{ source('infinit', 'clients') }}
    )
SELECT
    client_id,
    name        AS client_name,
    email       AS client_email
FROM ranked_data
WHERE
    rank = 1