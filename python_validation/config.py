conn = snowflake.connector.connect(
    user='USERNAME',
    password='PASSWORD',
    account='USERACCOUNT',  
    warehouse='COMPUTE_WH',     
    database='SALES',
    schema='OBJECTS'
)

cur = conn.cursor()
print("✅ Connected to Snowflake successfully!")