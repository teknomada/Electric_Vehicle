USE EV_RESEARCH;EV_RESEARCH.PUBLIC.BRONZE_EV_RAW
-- 2. Create the Iceberg Table using external Volume
--  Iceberg tables don't support VARIANT. Store JSON as STRING instead:
    CREATE OR REPLACE ICEBERG TABLE BRONZE_EV_RAW (
        raw_json STRING,
        ingested_at TIMESTAMP_NTZ
    )
    EXTERNAL_VOLUME = 'iceberg_external_volume'
    CATALOG = 'SNOWFLAKE'
    BASE_LOCATION = 'ev-data-bucket-bronze';