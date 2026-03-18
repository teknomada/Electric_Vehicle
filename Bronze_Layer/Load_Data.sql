USE EV_RESEARCH ;
-- Load the data from the stage into our landing table
COPY INTO EV_DATA_LANDING
FROM @ev_stage/ElectricVehiclePopulationData.json
ON_ERROR = 'CONTINUE';