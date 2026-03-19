# Electric_Vehicle
Technical DE Demo Exercise
## This repo shows the process to:
1. Analyze the Dataset
2. Implement a Medallion Architecture
3. Perform Data Quality checks
4. Orchestration Mechanism to run end-to-end pipeline
5. Store data in Open Table format in AWS
6. How to share the data in the Gold Layer with other Snowfñakes accounts
7. Build a Streamlit app to respond queries submitted in Natural Language

## Analyze the dataset
- SQL-Describe()
Here are the results, equivalent to pandas.describe():
1. Numeric column stats (count, mean, std, min, percentiles, max):
2. Categorical column stats (count, unique, top, freq):


## Implement Medallion Architecture 
### Bronze Layer 
- Ingest the data (json file ) and store raw data
- Create Snow flake table 


### Silver Layer
- Clean the data (Parse, Duplicates, Null values)
- Dynamic table(s) for automated refresh


### Gold Layer
- Business ready aggregates for later use in Streamlit app (NLP to SQL)

## Data Quality Checks
- Referential Integrity
- Across layer validation
- Data Lineage

## Orchestration

## Open Table Formats
- Iceberg Table in AWS S3 (parquet fromat) for open table interoperability

## Data Sharing

## Streamlite app
- Semantic Model
- Chat Interface




