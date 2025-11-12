-- Create a storage integration to securely connect Snowflake with Azure Blob Storage
CREATE or replace STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '423af215-5fbc-4e62-b53e-b00d8f9afd4e'
  STORAGE_ALLOWED_LOCATIONS = ('azure://salesdata21.blob.core.windows.net/salescoffee');

-- Verify the storage integration and share the generated Azure consent URL for activation
DESC STORAGE INTEGRATION azure_int;

-- Create an external Azure stage using the storage integration
CREATE or replace STAGE my_azure_stage
  STORAGE_INTEGRATION = azure_int
  URL = 'azure://salesdata21.blob.core.windows.net/salescoffee/'
  file_format='my_csv_format';

-- List the files in the Azure stage to verify connectivity
list @my_azure_stage;

-- Create a target table to load data from the Azure stage
Create or replace table salesrecord (order_date date,datetime timestamp,cash_type varchar(10),money number(10,1),coffee_name varchar(25));

-- Create a file format for the CSV files stored in Azure Blob Storage
create or replace file format my_csv_format
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    ;
-- Describe the Azure stage to verify configuration
DESC STAGE my_azure_stage;

-- Create a notification integration to receive events when new files are uploaded to the Azure stage
CREATE NOTIFICATION INTEGRATION azure_event_int
ENABLED = true
TYPE = QUEUE
NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://salesdata21.queue.core.windows.net/snowpipequeue'
AZURE_TENANT_ID = '423af215-5fbc-4e62-b53e-b00d8f9afd4e';

-- Verify and activate the notification integration (authorization required from Azure side)
DESC NOTIFICATION INTEGRATION azure_event_int;

-- Create a Snowpipe to automatically ingest new files from the Azure stage
create or replace pipe sales_pipe 
    AUTO_INGEST = true
    integration = 'AZURE_EVENT_INT'
    as copy into salesrecord from @my_azure_stage
    file_format='my_csv_format';

-- List all notification integrations in the account
show notification integrations;

-- Create a final table to hold transformed data
Create or replace table salesrecordfinal (order_date date,datetime timestamp,cash_type varchar(10),money number(10,1),coffee_name varchar(105),  total number(10,2));

-- Create a stream to track new records loaded into the staging table (salesrecord)
CREATE OR REPLACE STREAM sales_stream
ON TABLE salesrecord
APPEND_ONLY = TRUE;

-- Create a task to automate data transformation and load into the final table
CREATE OR REPLACE TASK transform_sales_task
WAREHOUSE = compute_wh
SCHEDULE = 'USING CRON 0 * * * * UTC'  -- runs every hour
AS
INSERT INTO salesrecordfinal
SELECT 
    ORDER_DATE,
    DATETIME,
    CASH_TYPE,
    MONEY,
    COFFEE_NAME,
    MONEY * 1.05 AS TOTAL  -- example transformation
FROM sales_stream;

-- Activate the transformation task
ALTER TASK transform_sales_task RESUME;

-- Verify that data has successfully loaded into the salesrecord table
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.COPY_HISTORY
WHERE TABLE_NAME = 'SALESRECORD'
ORDER BY LAST_LOAD_TIME DESC;

-- Display all configured pipes
SHOW PIPES;

-- Adjust column length if the source file contains longer values
ALTER TABLE SALESRECORD MODIFY COLUMN COFFEE_NAME VARCHAR(100);

-- View records from the staging table
select * from salesrecord;

-- View records from the final transformed table
select * from salesrecordfinal;

-- Check the total number of records in the staging table
select count(*) from salesrecord;

-- Check the total number of records in the final table
select count(*) from salesrecordfinal;







