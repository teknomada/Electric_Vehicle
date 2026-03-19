USE EV_RESEARCH;
-- 1. Create the Stage for your local file
CREATE OR REPLACE STAGE ev_raw_stage;
-- 2. (Execute in SnowSQL) Upload local file: 
PUT 'file://C:/Users/User/Documents/SnowFlake/ElectricVehiclePopulationData.json' @ev_raw_stage;
