SELECT
    * EXCLUDE (latitude, longitude),
    ST_Point(latitude, longitude) AS point_geom
FROM {{ source('stg_rrl_site', 'stg_rrl_site') }}
