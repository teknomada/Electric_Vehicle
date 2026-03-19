USE EV_RESEARCH;
CREATE OR REPLACE FILE FORMAT my_json_format
    TYPE = 'JSON'
    STRIP_OUTER_ARRAY = FALSE;
-- Create an internal stage

CREATE OR REPLACE STAGE EV_RESEARCH.PUBLIC.ev_raw_stage
  FILE_FORMAT = (FORMAT_NAME = 'my_json_format');

