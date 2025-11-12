\# ☁️ Cloud Data Quality Project



> Automated Azure-to-Snowflake data pipeline with real-time ETL and quality validation



[Azure](https://azure.microsoft.com/)

[Snowflake](https://www.snowflake.com/)

[Python](https://www.python.org/)



---



\##  Overview



Event-driven data pipeline that automatically ingests coffee sales data from Azure Blob Storage into Snowflake, applies business transformations, and validates data quality.



\*\*Key Achievement:\*\* 100% automated pipeline with zero manual intervention, built entirely on free tier ($0 cost).



---



\##  Architecture

```

Azure Blob Storage (CSV Upload)

&nbsp;      ↓

Snowpipe (Event-driven Auto-Ingest)

&nbsp;      ↓

Staging Table (Raw Data)

&nbsp;      ↓

Stream (Change Capture)

&nbsp;      ↓

Task (Hourly Transformation: +5% Markup)

&nbsp;      ↓

Final Table (Transformed Data)

&nbsp;      ↓

Python Validation (4 Quality Tests)

```



[View detailed architecture diagram →](docs/Architecture_Diagram_Data_Pipeline.png)



---



\##  Key Features



| Feature | Technology | Benefit |

|---------|-----------|---------|

| \*\*Auto-Ingestion\*\* | Snowpipe + Azure Event Grid | Files load automatically on upload |

| \*\*Real-Time ETL\*\* | Snowflake Streams \& Tasks | Processes data hourly, zero manual work |

| \*\*Data Quality\*\* | Python (pandas, numpy) | 4 automated tests catch errors |

| \*\*Business Logic\*\* | SQL Transformation | Applies 5% service charge markup |



---



\##  Data Flow



\*\*Input (CSV):\*\*

```csv

date,datetime,cash\_type,money,coffee\_name

2025-02-08,2025-02-08 14:26:04,cash,15.0,Tea

2025-02-08,2025-02-08 14:33:04,card,20.0,Espresso

```



\*\*Transformation:\*\* `TOTAL = MONEY \* 1.05` (5% markup)



\*\*Output (Snowflake Final Table):\*\*

| ORDER\_DATE | DATETIME | CASH\_TYPE | MONEY | COFFEE\_NAME | TOTAL |

|------------|----------|-----------|-------|-------------|-------|

| 2025-02-08 | 14:26:04 | cash | 15.0 | Tea | \*\*15.75\*\* |

| 2025-02-08 | 14:33:04 | card | 20.0 | Espresso | \*\*21.00\*\* |



---



\##  Data Quality Validation



| Test | Purpose | Pass Criteria |

|------|---------|---------------|

| \*\*Row Count\*\* | Detect data loss | Staging rows = Final rows |

| \*\*Null Check\*\* | Data completeness | 0 nulls in critical columns |

| \*\*Business Logic\*\* | Calculation accuracy | TOTAL = MONEY × 1.05 |

| \*\*Data Consistency\*\* | Integrity check | Common columns match exactly |



\*\*All tests pass with 100% accuracy\*\* 



[View validation results →](python_validation/DataValidation.ipynb)



---



\##  Tech Stack



\*\*Cloud Platform:\*\* Azure Blob Storage, Snowflake  

\*\*Languages:\*\* SQL, Python  

\*\*Tools:\*\* Jupyter Notebook, Anaconda, Git  

\*\*Libraries:\*\* pandas, numpy, snowflake-connector-python  

\*\*Automation:\*\* Snowpipe (event-driven), Snowflake Tasks (CRON scheduled)



---



\##  Setup Instructions



\### Prerequisites

\- Azure account (free tier)

\- Snowflake account (trial)

\- Python 3.8+ with Anaconda/Jupyter



\### 1. Azure Configuration

1\. Create Resource Group: `rg\_data\_pipeline`

2\. Create Storage Account: `salesdata21`

3\. Create Container: `salescoffee`

4\. Upload sample CSV files from `/data` folder



\### 2. Snowflake Setup

```sql

-- Run the complete setup script

-- File: snowflake/sales.sql

-- Creates: storage integration, notification integration, stage, tables, pipe, stream, task

```



\### 3. Python Validation

```bash

\# Install dependencies

pip install -r "python_validation/requirements.txt"



\# Configure credentials

\# Create config.py with your Snowflake credentials





\# Run validation notebook

jupyter notebook

# Open: python_validation/DataValidation.ipynb

```



---



##  Project Structure

```

cloud-data-quality-project_sample/

├── README.md                       # This file

├── data/

│   └── salescoffee211.csv

│    └── salescoffee222.csv

├── docs/

│   ├── Architecture_Diagram_Data_Pipeline.png   # System architecture

│   ├── screenshots/               # Implementation proof

|        └──01Azure_Resource_Group.png

|        └──02Azure_Storage_Account.png

|        └──03Azure_Container.png

|        └──04Storage_integration.png

|        └──05Azure_External_Stage.png

|        └──06Notification_Integration.png

|        └──07Table_Description_Salesrecord.png

|        └──08Table_Description_Salesrecordfinal.png

|        └──09Pipe_Status.png

|        └──10Data_Salesrecord.png

|        └──11Data_Salesrecordfinal.png

|        └──12Datavalidation_Report.png

├── python_validation/

│   ├── DataValidation.ipynb       # Validation notebook with outputs

│   ├── requirements.txt           # Python dependencies

│   └── config.py               # Credentials (not in repo)

└── snowflake/

&nbsp;   └── sales.sql                  # Complete Snowflake setup

```



---



\## 📈 Results



\### Metrics

\-  \*\*100% Automation\*\* - Zero manual data loading

\-  \*\*Real-Time Processing\*\* - Data available within 1 hour

\-  \*\*100% Data Accuracy\*\* - All validation tests pass

\-  \*\*Cost Efficient\*\* - $0 total cost (free tier only)



\### Sample Output

```

============================================================

DATA VALIDATION REPORT

============================================================



TEST 1: Row Count

&nbsp; Staging: 524 rows

&nbsp; Final:   524 rows

&nbsp; Result:  PASS



TEST 2: Null Value Check

&nbsp; Staging Table:

&nbsp;   ORDER\_DATE: 0 nulls \[PASS]

&nbsp;   DATETIME: 0 nulls \[PASS]

&nbsp;   MONEY: 0 nulls \[PASS]

&nbsp;   CASH\_TYPE: 0 nulls \[PASS]

&nbsp;   COFFEE\_NAME: 0 nulls \[PASS]



&nbsp; Final Table:

&nbsp;   ORDER\_DATE: 0 nulls \[PASS]

&nbsp;   DATETIME: 0 nulls \[PASS]

&nbsp;   MONEY: 0 nulls \[PASS]

&nbsp;   CASH\_TYPE: 0 nulls \[PASS]

&nbsp;   COFFEE\_NAME: 0 nulls \[PASS]

&nbsp;   TOTAL: 0 nulls \[PASS]



TEST 3: Business Logic Validation

&nbsp; Formula: TOTAL = MONEY \* 1.05

&nbsp; Errors: 0

&nbsp; Result: PASS



TEST 4: Data Consistency Check

&nbsp; Comparing 5 columns: CASH\_TYPE, COFFEE\_NAME, DATETIME, MONEY, ORDER\_DATE

&nbsp; Result: PASS - All common data matches



============================================================

END OF REPORT

============================================================



```



[View complete validation output →](docs/screenshots/)



---





\##  Skills Demonstrated



\*\*Cloud Architecture\*\*

\- Azure-Snowflake integration

\- Event-driven architecture

\- Cloud resource management



\*\*Data Engineering\*\*

\- ETL pipeline design

\- Real-time data processing

\- Stream processing



\*\*Data Quality\*\*

\- Automated validation frameworks

\- Test-driven development

\- Error detection and handling



\*\*Tools \& Technologies\*\*

\- SQL (DDL, DML, stored procedures)

\- Python (pandas, numpy, jupyter)

\- Git version control



---



\##  Future Enhancements



\- \[ ] Monitoring dashboard (Tableau/Power BI)

\- \[ ] Airflow orchestration

\- \[ ] Email alerts for validation failures

\- \[ ] dbt for transformations

\- \[ ] Support JSON/Parquet

\- \[ ] Data lineage tracking



---



\##  Learning Outcomes



\### Challenges Solved

\- Azure-Snowflake authentication and integration  

\- Event-driven automation with Azure Event Grid  

\- Floating-point precision handling in validations  

\- Cost optimization within free tier limits  



\### Key Takeaways

\- Event-driven architecture reduces manual intervention

\- Data validation is critical for production pipelines

\- Cloud services can be powerful even on free tier

\- Proper credential management is essential



---



\##  Author



\*\*Anusree Sivaraj\*\*  



[LinkedIn](https://www.linkedin.com/in/anusree-sivaraj/)

[GitHub](https://github.com/anusreesivaraj21/cloud-data-quality-project\_sample)



---





Built as a learning project to demonstrate:

\- Cloud data engineering fundamentals

\- ETL pipeline automation

\- Data quality best practices



\*\*If this project helped you learn, please star the repo!\*\* 



---



\*\*Total Development Time:\*\* 2 weeks  

\*\*Total Cost:\*\* $0 (Free tier only)  

\*\*Lines of Code:\*\* ~500 (SQL + Python)

