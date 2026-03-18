--USE EV_RESEARCH;
-- Define the JSON file format
--CREATE OR REPLACE STAGE ev_stage
--  FILE_FORMAT = (TYPE = 'JSON' STRIP_OUTER_ARRAY = FALSE);
-- Create an internal stage
CREATE OR REPLACE STAGE EV_RESEARCH.RAW.ev_stage
  FILE_FORMAT = (FORMAT_NAME = 'my_json_format');

  -- Define the JSON file format
--CREATE OR REPLACE FILE FORMAT my_json_format
--    TYPE = 'JSON'
--    STRIP_OUTER_ARRAY = FALSE;

-- Create an internal stage
--CREATE OR REPLACE STAGE ev_stage
--    FILE_FORMAT = my_json_format;