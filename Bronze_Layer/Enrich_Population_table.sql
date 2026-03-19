CREATE OR REPLACE TABLE EV_RESEARCH.RAW.EV_POPULATION_FINAL AS
SELECT
    -- Metadata fields (repeated for each row)
    json_raw:meta.view.id::STRING          AS source_dataset_id,
    json_raw:meta.view.attribution::STRING AS data_provider,
    
    -- Data fields (from the array)
    value[8]::STRING  AS vin,
    value[9]::STRING  AS county,
    value[10]::STRING AS city,
    value[11]::STRING AS state,
    value[13]::NUMBER AS model_year,
    value[14]::STRING AS make,
    value[15]::STRING AS model,
    value[16]::STRING AS ev_type,
    value[22]::STRING AS location_point  -- Extracting the "POINT (...)" string
FROM 
    EV_RESEARCH.RAW.EV_DATA_LANDING,
    LATERAL FLATTEN(input => json_raw:data);
