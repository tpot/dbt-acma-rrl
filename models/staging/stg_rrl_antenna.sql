SELECT *
FROM {{ source('stg_rrl_antenna', 'stg_rrl_antenna') }}
