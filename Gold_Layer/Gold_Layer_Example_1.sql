-- Example Gold Layer: Aggregate Fact Table
CREATE OR REPLACE DYNAMIC TABLE EV_RESEARCH.PUBLIC.GOLD_EV_MARKET_SUMMARY
  TARGET_LAG = '5 minutes'
  WAREHOUSE = COMPUTE_WH
AS
SELECT
    make,
    model_year,
    COUNT(vin) AS total_vehicles,
    -- Calculate percentage of specific EV types
    ROUND(COUNT_IF(ev_type = 'Battery Electric Vehicle (BEV)') / NULLIF(COUNT(*), 0) * 100, 2) AS bev_pct
FROM 
    EV_RESEARCH.PUBLIC.SILVER_EV_CLEANED
GROUP BY 1, 2;

-- Gold Layer: EV Metrics by State and Model Year
CREATE OR REPLACE DYNAMIC TABLE EV_RESEARCH.PUBLIC.GOLD_EV_STATE_METRICS
  TARGET_LAG = '1 hour'
  WAREHOUSE = COMPUTE_WH
AS
SELECT
    state,
    model_year,
    COUNT(vin) AS total_vehicles,
    COUNT(DISTINCT make) AS unique_makes,
    COUNT(DISTINCT model) AS unique_models,
    COUNT_IF(ev_type = 'Battery Electric Vehicle (BEV)') AS bev_count,
    COUNT_IF(ev_type = 'Plug-in Hybrid Electric Vehicle (PHEV)') AS phev_count,
    ROUND(COUNT_IF(ev_type = 'Battery Electric Vehicle (BEV)') / NULLIF(COUNT(*), 0) * 100, 2) AS bev_pct,
    ROUND(COUNT_IF(ev_type = 'Plug-in Hybrid Electric Vehicle (PHEV)') / NULLIF(COUNT(*), 0) * 100, 2) AS phev_pct
FROM
    EV_RESEARCH.PUBLIC.SILVER_EV_CLEANED
GROUP BY state, model_year;