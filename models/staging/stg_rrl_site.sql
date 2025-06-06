SELECT
    site_id,
    name,
    state,
    licensing_area_id,
    postcode,
    site_precision,
    elevation,
    hcis_l2,
    ST_Point(latitude, longitude) AS point_geom
FROM {{ source('stg_rrl_site', 'stg_rrl_site') }}
