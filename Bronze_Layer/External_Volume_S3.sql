USE EV_RESEARCH;
-- 3. 
-- 3.1 Create the External Volume
CREATE OR REPLACE EXTERNAL VOLUME iceberg_external_volume
   STORAGE_LOCATIONS =
      (
         (
            NAME = 'my-s3-us-east-1'
            STORAGE_PROVIDER = 'S3'
            STORAGE_BASE_URL = 's3://ev-data-bucket-bronze'
            STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::931767208571:role/snowflake_role'
            STORAGE_AWS_EXTERNAL_ID = 'iceberg_table_external_id'
        )
      )
      ALLOW_WRITES = TRUE;
-------
