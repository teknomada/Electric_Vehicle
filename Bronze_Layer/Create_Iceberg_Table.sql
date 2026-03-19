

CREATE OR REPLACE ICEBERG TABLE EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL_3 (
    source_dataset_id STRING,
    data_provider STRING,
    vin STRING,
    county STRING,
    city STRING,
    state STRING,
    model_year NUMBER(4,0),
    make STRING,
    model STRING,
    ev_type STRING,
    location_point STRING,
    ingested_at TIMESTAMP_NTZ
)
EXTERNAL_VOLUME = 'iceberg_external_volume'
CATALOG = 'SNOWFLAKE'
BASE_LOCATION = 'bronze/ev_raw_data/';

INSERT INTO EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL_3
SELECT
    json_raw:meta.view.id::STRING          AS source_dataset_id,
    json_raw:meta.view.attribution::STRING AS data_provider,
    value[8]::STRING  AS vin,
    value[9]::STRING  AS county,
    value[10]::STRING AS city,
    value[11]::STRING AS state,
    value[13]::NUMBER(4,0) AS model_year,
    value[14]::STRING AS make,
    value[15]::STRING AS model,
    value[16]::STRING AS ev_type,
    value[22]::STRING AS location_point,
    CURRENT_TIMESTAMP() AS ingested_at
FROM 
    EV_RESEARCH.PUBLIC.EV_DATA_LANDING,
    LATERAL FLATTEN(input => json_raw:data);
