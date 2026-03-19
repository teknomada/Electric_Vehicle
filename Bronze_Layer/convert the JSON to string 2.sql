--  Use a SELECT with TO_VARCHAR() to convert the JSON to string:
USE EV_RESEARCH;
    COPY INTO BRONZE_EV_RAW (RAW_JSON, INGESTED_AT)
    FROM (
        SELECT TO_VARCHAR($1), CURRENT_TIMESTAMP()
        FROM @ev_raw_stage/ElectricVehiclePopulationData.json
    )
    FILE_FORMAT = (TYPE = 'JSON' STRIP_OUTER_ARRAY = TRUE)
    ON_ERROR = 'CONTINUE';

 -- The STRIP_OUTER_ARRAY = TRUE is needed if your JSON file is an array of objects [{...}, {...}] — it loads each object as a separate row.

  --If it's newline-delimited JSON (one object per line), remove that option:

    --COPY INTO BRONZE_EV_RAW (raw_json)
    --FROM (
    --    SELECT TO_VARCHAR($1)
    --    FROM @ev_raw_stage/ElectricVehiclePopulationData.json
   -- )
   -- FILE_FORMAT = (TYPE = 'JSON');
