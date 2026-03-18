
-- Define the JSON file format
CREATE OR REPLACE FILE FORMAT my_json_format
    TYPE = 'JSON'
    STRIP_OUTER_ARRAY = FALSE;

