## Databricks and Snowflake Capstone Project 2026:

# StoreLens

A small data pipeline I built for my Databricks & Snowflake capstone (Topic 05, Store Footfall vs Sales Conversion). It takes store door counter data and billing data, cleans both in Databricks, and serves one final table from Snowflake so store managers can see how many visitors actually buy something.

Aastha Thakur | Roll No. 23053944 | Submitted to Dr. Kanthi Kiran Sirra


## Project Overview

StoreLens is a retail analytics pipeline built using Databricks and Snowflake.

The project processes retail footfall and billing data through a three-layer
Medallion architecture:

Raw Data → Bronze → Silver → Gold → Snowflake → SQL Analytics

## Problem Statement

The project calculates reliable retail store conversion rates while handling:

- Faulty/offline footfall sensors
- Duplicate bills
- Unknown stores
- Out-of-hours bills
- Missing footfall readings

## Technology Stack

- Databricks
- PySpark
- Spark SQL
- Delta Lake
- Databricks Workflows
- Snowflake
- GitHub

## Pipeline Architecture

1. Raw CSV generation
2. Bronze ingestion
3. Silver cleaning and validation
4. Gold store-hour aggregation
5. CSV export
6. Snowflake stage
7. Snowflake loading
8. SQL business analysis

## Data Quality

- 12 stores
- 90 trading days
- 12 trading hours per day
- 12,960 store-hour records
- 86,859 raw bill records
- 540 faulty sensor readings
- Duplicate and invalid bills handled
- Gold and Silver revenue reconciled

## Trading Hours Rule

Valid trading hours are 10:00 through 21:00.

Bills are rejected when:

- hour < 10
- hour >= 22

This ensures that hour 21 remains a valid trading hour.

## Key Results

- Gold table: 12,960 rows
- Snowflake table: 12,960 rows
- Faulty sensor hours: 540
- Gold vs Silver revenue difference: approximately 4.54e-07
- Databricks pipeline runtime: 2 min 52 sec

## Repository Contents

- `Capstone Pipeline.ipynb` – Databricks pipeline
- `storelens_snowflake_sql.sql` – Snowflake analysis queries
- `q3_decile_conversion.csv` – Q3 footfall-decile conversion results
- `README.md` – Project documentation

## Author

Aastha Thakur  
Roll Number: 23053944
