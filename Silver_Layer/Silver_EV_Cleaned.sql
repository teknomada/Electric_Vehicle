{
  "metadata": {
    "kernelspec": {
      "name": "jupyter",
      "display_name": "Jupyter Notebook"
    }
  },
  "nbformat_minor": 5,
  "nbformat": 4,
  "cells": [
    {
      "id": "1cabf1dd-79c3-4804-85f6-f2f2a4df678c",
      "cell_type": "code",
      "metadata": {
        "language": "sql",
        "resultVariableName": "create_dt",
        "name": "Sliver_Layer_Impute_model_year = null",
        "title": "Sliver_Layer_Impute_model_year = null"
      },
      "source": "%%sql -r create_dt\n-- Silver Layer: EV Data Cleaning\n-- 1) Impute null MODEL using mode by MAKE, MODEL_YEAR, EV_TYPE\n-- 2) Impute null LOCATION_POINT using mode by CITY+STATE, fallback to COUNTY+STATE\n\nCREATE OR REPLACE DYNAMIC TABLE EV_RESEARCH.PUBLIC.SILVER_EV_CLEANED\n  TARGET_LAG = '1 hour'\n  WAREHOUSE = COMPUTE_WH\nAS\nWITH mode_model AS (\n    SELECT make, model_year, ev_type, model AS mode_model\n    FROM (\n        SELECT make, model_year, ev_type, model,\n            ROW_NUMBER() OVER (PARTITION BY make, model_year, ev_type ORDER BY COUNT(*) DESC) AS rn\n        FROM EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL_3\n        WHERE model IS NOT NULL\n        GROUP BY make, model_year, ev_type, model\n    )\n    WHERE rn = 1\n),\nmode_loc_city AS (\n    SELECT city, state, location_point AS mode_loc\n    FROM (\n        SELECT city, state, location_point,\n            ROW_NUMBER() OVER (PARTITION BY city, state ORDER BY COUNT(*) DESC) AS rn\n        FROM EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL_3\n        WHERE location_point IS NOT NULL AND city IS NOT NULL\n        GROUP BY city, state, location_point\n    )\n    WHERE rn = 1\n),\nmode_loc_county AS (\n    SELECT county, state, location_point AS mode_loc\n    FROM (\n        SELECT county, state, location_point,\n            ROW_NUMBER() OVER (PARTITION BY county, state ORDER BY COUNT(*) DESC) AS rn\n        FROM EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL_3\n        WHERE location_point IS NOT NULL AND county IS NOT NULL\n        GROUP BY county, state, location_point\n    )\n    WHERE rn = 1\n)\nSELECT\n    e.source_dataset_id,\n    e.data_provider,\n    e.vin,\n    e.county,\n    e.city,\n    e.state,\n    e.model_year,\n    e.make,\n    COALESCE(e.model, mm.mode_model) AS model,\n    e.ev_type,\n    COALESCE(e.location_point, lc.mode_loc, lco.mode_loc) AS location_point,\n    e.ingested_at\nFROM EV_RESEARCH.PUBLIC.EV_POPULATION_FINAL_3 e\nLEFT JOIN mode_model mm\n    ON e.make = mm.make\n    AND e.model_year = mm.model_year\n    AND e.ev_type = mm.ev_type\n    AND e.model IS NULL\nLEFT JOIN mode_loc_city lc\n    ON e.city = lc.city\n    AND e.state = lc.state\n    AND e.location_point IS NULL\nLEFT JOIN mode_loc_county lco\n    ON e.county = lco.county\n    AND e.state = lco.state\n    AND e.location_point IS NULL;",
      "outputs": [],
      "execution_count": null
    }
  ]
}