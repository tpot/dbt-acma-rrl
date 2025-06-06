{{ config(materialized='view') }}
SELECT *
FROM {{ ref('stg_rrl_site') }}
