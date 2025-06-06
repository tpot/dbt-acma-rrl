WITH

    freq AS (
        SELECT DISTINCT frequency
        FROM {{ ref('stg_rrl_device_details') }}
        WHERE frequency IS NOT NULL
    )

-- noqa: disable=all
SELECT
    ROW_NUMBER() OVER (ORDER BY frequency) AS frequency_id,
    frequency,
    -- Abbreviated frequency
    CASE
        WHEN frequency < 1_000_000         THEN frequency / 1_000
        WHEN frequency < 1_000_000_000     THEN frequency / 1_000_000
        WHEN frequency < 1_000_000_000_000 THEN frequency / 1_000_000_000
        ELSE frequency / 1_000_000_000_000
    END AS display,
    CASE
        WHEN frequency < 1_000_000         THEN 'kHz'
        WHEN frequency < 1_000_000_000     THEN 'MHz'
        WHEN frequency < 1_000_000_000_000 THEN 'GHz'
        ELSE 'THz'
    END AS display_units,
    --- ITU band
    CASE
        WHEN frequency <= 30                THEN 'ELF'
        WHEN frequency <= 300               THEN 'SLF'
        WHEN frequency <= 3_000             THEN 'ULF'
        WHEN frequency <= 30_000            THEN 'VLF'
        WHEN frequency <= 300_000           THEN 'LF'
        WHEN frequency <= 3_000_000         THEN 'MF'
        WHEN frequency <= 30_000_000        THEN 'HF'
        WHEN frequency <= 300_000_000       THEN 'VHF'
        WHEN frequency <= 3_000_000_000     THEN 'UHF'
        WHEN frequency <= 30_000_000_000    THEN 'SHF'
        WHEN frequency <= 300_000_000_000   THEN 'EHF'
        WHEN frequency <= 3_000_000_000_000 THEN 'THF'
    END AS itu_band,
    -- IEEE radar band name
    CASE
        WHEN
            frequency     >= 0.003 * 1_000_000_000
            AND frequency <  0.03  * 1_000_000_000
            THEN 'HF'
        WHEN
            frequency     >= 0.03 * 1_000_000_000
            AND frequency <  0.3  * 1_000_000_000
            THEN 'VHF'
        WHEN
            frequency     >= 0.3 * 1_000_000_000
            AND frequency <  1   * 1_000_000_000
            THEN 'UHF'
        WHEN
            frequency     >= 1 * 1_000_000_000
            AND frequency <  2 * 1_000_000_000
            THEN 'L'
        WHEN
            frequency     >= 2 * 1_000_000_000::int64
            AND frequency <  4 * 1_000_000_000::int64
            THEN 'S'
        WHEN
            frequency     >= 4 * 1_000_000_000::int64
            AND frequency <  8 * 1_000_000_000::int64
            THEN 'C'
        WHEN
            frequency     >= 8  * 1_000_000_000::int64
            AND frequency <  12 * 1_000_000_000::int64
            THEN 'X'
        WHEN
            frequency     >= 12 * 1_000_000_000::int64
            AND frequency <  18 * 1_000_000_000::int64
            THEN 'Ku'
        WHEN
            frequency     >= 18 * 1_000_000_000::int64
            AND frequency <  27 * 1_000_000_000::int64
            THEN 'K'
        WHEN
            frequency     >= 27 * 1_000_000_000::int64
            AND frequency <  40 * 1_000_000_000::int64
            THEN 'Ka'
        WHEN
            frequency     >= 40 * 1_000_000_000::int64
            AND frequency <  75 * 1_000_000_000::int64
            THEN 'V'
        WHEN
            frequency     >= 75  * 1_000_000_000::int64
            AND frequency <  110 * 1_000_000_000::int64
            THEN 'W'
        WHEN
            frequency     >= 110 * 1_000_000_000::int64
            AND frequency <  300 * 1_000_000_000::int64
            THEN 'G'
    END AS ieee_radar_band,
    -- NATO old-style band name
    CASE
        WHEN
            frequency     >= 100 * 1_000_000
            AND frequency <  150 * 1_000_000
            THEN 'I'
        WHEN
            frequency     >= 150 * 1_000_000
            AND frequency <  225 * 1_000_000
            THEN 'G'
        WHEN
            frequency     >= 225 * 1_000_000
            AND frequency <  390 * 1_000_000
            THEN 'P'
        WHEN
            frequency     >= 390   * 1_000_000
            AND frequency <  1_550 * 1_000_000
            THEN 'L'
        WHEN
            frequency     >= 1_550 * 1_000_000::int64
            AND frequency <  3_900 * 1_000_000::int64
            THEN 'S'
        WHEN
            frequency     >= 3_900 * 1_000_000::int64
            AND frequency <  6_200 * 1_000_000::int64
            THEN 'C'
        WHEN
            frequency     >= 6_200  * 1_000_000::int64
            AND frequency <  10_900 * 1_000_000::int64
            THEN 'X'
        WHEN
            frequency     >= 10_900 * 1_000_000::int64
            AND frequency <  20_000 * 1_000_000::int64
            THEN 'Ku'
        WHEN
            frequency     >= 20_000 * 1_000_000::int64
            AND frequency <  36_000 * 1_000_000::int64
            THEN 'Ka'
        WHEN
            frequency     >= 36_000 * 1_000_000::int64
            AND frequency <  46_000 * 1_000_000::int64
            THEN 'Q'
        WHEN
            frequency     >= 46_000 * 1_000_000::int64
            AND frequency <  56_000 * 1_000_000::int64
            THEN 'V'
        WHEN
            frequency     >= 56_000  * 1_000_000::int64
            AND frequency <  100_000 * 1_000_000::int64
            THEN 'W'
    END AS nato_old_band,
    -- NATO new-style band name
    CASE
        WHEN
            frequency     >= 0   * 1_000_000
            AND frequency <  250 * 1_000_000
            THEN 'A'
        WHEN
            frequency     >= 250 * 1_000_000
            AND frequency <  500 * 1_000_000
            THEN 'B'
        WHEN
            frequency     >= 500   * 1_000_000
            AND frequency <  1_000 * 1_000_000
            THEN 'C'
        WHEN
            frequency     >= 1_000 * 1_000_000
            AND frequency <  2_000 * 1_000_000
            THEN 'D'
        WHEN
            frequency     >= 2_000 * 1_000_000::int64
            AND frequency <  3_000 * 1_000_000::int64
            THEN 'E'
        WHEN
            frequency     >= 3_000 * 1_000_000::int64
            AND frequency <  4_000 * 1_000_000::int64
            THEN 'F'
        WHEN
            frequency     >= 4_000 * 1_000_000::int64
            AND frequency <  6_000 * 1_000_000::int64
            THEN 'G'
        WHEN
            frequency     >= 6_000 * 1_000_000::int64
            AND frequency <  8_000 * 1_000_000::int64
            THEN 'H'
        WHEN
            frequency     >= 8_000  * 1_000_000::int64
            AND frequency <  10_000 * 1_000_000::int64
            THEN 'I'
        WHEN
            frequency     >= 10_000 * 1_000_000::int64
            AND frequency <  20_000 * 1_000_000::int64
            THEN 'J'
        WHEN
            frequency     >= 20_000 * 1_000_000::int64
            AND frequency <  40_000 * 1_000_000::int64
            THEN 'K'
        WHEN
            frequency     >= 40_000 * 1_000_000::int64
            AND frequency <  60_000 * 1_000_000::int64
            THEN 'L'
        WHEN
            frequency     >= 40_000  * 1_000_000::int64
            AND frequency <  100_000 * 1_000_000::int64
            THEN 'M'
    END AS nato_new_band
FROM freq
-- noqa: enable=all
