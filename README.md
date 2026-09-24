# StoreLens

A small data pipeline I built for my Databricks & Snowflake capstone (Topic 05, Store Footfall vs Sales Conversion). It takes store door counter data and billing data, cleans both in Databricks, and serves one final table from Snowflake so store managers can see how many visitors actually buy something.

Aastha Thakur | Roll No. 23053944 | Submitted to Dr. Kanthi Kiran Sirra

## Why I built it:
Store managers know their revenue, but not what share of visitors turn into bills. The raw data can't be used directly. Some door counters go offline or send unreadable values, and the billing export has duplicate bills and bills outside trading hours. If you divide bills by visitors on the raw data, the answer is wrong.

## How it works:
Raw CSV files -> Bronze -> Silver -> Gold -> one CSV export -> Snowflake stage -> COPY INTO -> SQL

- **Bronze:** the raw files, kept exactly as they arrived (all columns as text), with a few tracking columns added.
- **Silver:** types are fixed with try_cast. A counter that was offline is stored as NULL, not 0, because a dead sensor did not measure zero visitors. Duplicate bills and invalid bills are removed.
- **Gold:** one row per store, date and hour, with footfall, bills, revenue, conversion rate and a flag showing whether the counter reading can be trusted.
- **Snowflake:** the Gold table is loaded from a stage with COPY INTO, then I answer three questions in SQL: conversion per store per hour, the worst-converting hours, and whether conversion drops on the busiest days.

Built with Databricks (Free Edition), PySpark, Delta Lake, Databricks Jobs and Snowflake.

## What is in this repo
- `capstone_pipeline.py`: the Databricks notebook (data generation, Bronze, Silver, Gold, CSV export)
- `snowflake_queries.sql`: table and stage setup, COPY INTO, and the three queries
- `screenshots/`: screenshots from Databricks and Snowflake

## How to run it
1. Import `capstone_pipeline.py` into Databricks as a notebook.
2. Change `MY_ID` in the first cell to your own name (lowercase, no spaces).
3. Run all the cells, or run the notebook as a Databricks Job. It generates the data, builds the three layers and exports the Gold table as one CSV.
4. Download that CSV from the Volume.
5. In Snowflake, run the setup statements from `snowflake_queries.sql`.
6. Upload the CSV to the stage `my_capstone_stage`.
7. Run COPY INTO. Running it a second time should load nothing.
8. Run the three queries at the bottom of the SQL file.

No passwords or keys are stored in this repo.

## Results
The test results, data quality numbers and screenshots are in my project report (PDF).
