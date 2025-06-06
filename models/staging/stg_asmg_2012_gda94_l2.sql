{{ config(materialized='view') }}
SELECT *
FROM {{ source('stg_asmg_2012_gda94_l2', 'stg_asmg_2012_gda94_l2') }}
