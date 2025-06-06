SELECT *
FROM {{ source('stg_rrl_device_details', 'stg_rrl_device_details') }}
