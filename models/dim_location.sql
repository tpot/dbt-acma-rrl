WITH

    site AS (
        SELECT DISTINCT
            point_geom,
            state,
            postcode,
            elevation
        FROM {{ ref('rrl_site') }}
    )

SELECT
    ROW_NUMBER() OVER (ORDER BY point_geom) AS location_id,
    point_geom,
    state,
    postcode,
    elevation
FROM site
