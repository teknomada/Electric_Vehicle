-- Silver Layer: EV Data Cleaning
-- 1) Impute null MODEL using mode by MAKE, MODEL_YEAR, EV_TYPE
-- 2) Impute null LOCATION_POINT using mode by CITY+STATE, fallback to COUNTY+STATE

CREATE OR REPLACE DYNAMIC TABLE EV_RESEARCH.PUBLIC.SILVER_EV_CLEANED
  TARGET_LAG = '1 hour'
  WAREHOUSE = COMPUTE_WH
AS
WITH mode_model AS (
    SELECT make, model_year, ev_type, model AS mode_model
    FROM (
        SELECT make, model_year, ev_type, model,
            ROW_NUMBER() OVER (PARTITION BY make, model_year, ev_type ORDER BY COUNT(*) DESC) AS rn
        FROM EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL_3
        WHERE model IS NOT NULL
        GROUP BY make, model_year, ev_type, model
    )
    WHERE rn = 1
),
mode_loc_city AS (
    SELECT city, state, location_point AS mode_loc
    FROM (
        SELECT city, state, location_point,
            ROW_NUMBER() OVER (PARTITION BY city, state ORDER BY COUNT(*) DESC) AS rn
        FROM EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL_3
        WHERE location_point IS NOT NULL AND city IS NOT NULL
        GROUP BY city, state, location_point
    )
    WHERE rn = 1
),
mode_loc_county AS (
    SELECT county, state, location_point AS mode_loc
    FROM (
        SELECT county, state, location_point,
            ROW_NUMBER() OVER (PARTITION BY county, state ORDER BY COUNT(*) DESC) AS rn
        FROM EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL_3
        WHERE location_point IS NOT NULL AND county IS NOT NULL
        GROUP BY county, state, location_point
    )
    WHERE rn = 1
)
SELECT
    e.source_dataset_id,
    e.data_provider,
    e.vin,
    e.county,
    e.city,
    e.state,
    e.model_year,
    e.make,
    COALESCE(e.model, mm.mode_model) AS model,
    e.ev_type,
    COALESCE(e.location_point, lc.mode_loc, lco.mode_loc) AS location_point,
    e.ingested_at
FROM EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL_3 e
LEFT JOIN mode_model mm
    ON e.make = mm.make
    AND e.model_year = mm.model_year
    AND e.ev_type = mm.ev_type
    AND e.model IS NULL
LEFT JOIN mode_loc_city lc
    ON e.city = lc.city
    AND e.state = lc.state
    AND e.location_point IS NULL
LEFT JOIN mode_loc_county lco
    ON e.county = lco.county
    AND e.state = lco.state
    AND e.location_point IS NULL;