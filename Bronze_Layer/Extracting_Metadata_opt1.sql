-- Create a table to store the dataset's high-level properties
CREATE OR REPLACE TABLE EV_RESEARCH.RAW.DATASET_PROPERTIES AS
SELECT
    json_raw:meta.view.id::STRING          AS dataset_id,
    json_raw:meta.view.name::STRING        AS dataset_name,
    json_raw:meta.view.attribution::STRING AS data_source,
    -- Convert Unix timestamp (seconds) to Snowflake Timestamp
    TO_TIMESTAMP_NTZ(json_raw:meta.view.rowsUpdatedAt::INT) AS last_updated_at,
    json_raw:meta.view.description::STRING AS description
FROM 
    EV_RESEARCH.RAW.EV_DATA_LANDING;
