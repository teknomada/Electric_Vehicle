-- USE EV_RESEARCH;
CREATE OR REPLACE TABLE EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL AS
SELECT
    value[8]::STRING  AS vin,            -- Index 8 is VIN (1-10)
    value[9]::STRING  AS county,         -- Index 9 is County
    value[10]::STRING AS city,           -- Index 10 is City
    value[11]::STRING AS state,          -- Index 11 is State
    value[13]::NUMBER AS model_year,     -- Index 13 is Model Year
    value[14]::STRING AS make,           -- Index 14 is Make
    value[15]::STRING AS model,          -- Index 15 is Model
    value[16]::STRING AS ev_type         -- Index 16 is Electric Vehicle Type
FROM 
    EV_RESEARCH.PUBLIC.EV_DATA_LANDING,
    LATERAL FLATTEN(input => json_raw:data);