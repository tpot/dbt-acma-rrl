-- noqa: disable=references.quoting
SELECT
    ROW_NUMBER() OVER (ORDER BY "HCI_Level2") AS hcis_l2_id,
    "HCI_Level2" AS hcis_l2,
    "HCI_Level3" AS hcis_l3,
    "HCI_Level4" AS hcis_l4,
    geom
FROM {{ ref('stg_asmg_2012_gda94_l2') }}
