# Ingestion scripts

## Run ingestion 

## Strategy 

**Append only**: all ingestion runs will push normalized data to the corresponding tables in the data warehouse in append only mode. It will create duplicates that are then deduplicated by the following dbt models.     