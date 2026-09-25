-- StoreLens: Snowflake serving + analysis queries
-- Loads the Gold store-hour table (exported from Databricks) via a named
-- stage and COPY INTO, then answers the three business questions.

CREATE DATABASE IF NOT EXISTS CAPSTONE_DB;
USE DATABASE CAPSTONE_DB;
USE SCHEMA PUBLIC;

CREATE OR REPLACE TABLE GOLD_STORE_HOUR (
  store_id STRING,
  city STRING,
  format STRING,
  trade_date DATE,
  hour INT,
  is_weekend BOOLEAN,
  footfall INT,
  bills INT,
  revenue FLOAT,
  conversion_rate FLOAT,
  sensor_ok BOOLEAN
);

CREATE OR REPLACE STAGE my_capstone_stage;

CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1;

-- Upload gold_store_hour.csv to @my_capstone_stage via Snowsight before
-- running this COPY INTO.
COPY INTO GOLD_STORE_HOUR
  FROM @my_capstone_stage
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Sanity check: confirm the load
SELECT * FROM CAPSTONE_DB.PUBLIC.GOLD_STORE_HOUR LIMIT 10;

-- Q1 is answered directly by the conversion_rate column already present
-- on every row of GOLD_STORE_HOUR (conversion rate per store per hour).

-- Q2: three worst-converting hours chain-wide, unfiltered
SELECT hour,
       SUM(bills) AS total_bills,
       SUM(footfall) AS total_footfall,
       ROUND(SUM(bills) / NULLIF(SUM(footfall), 0), 4) AS conversion_rate
FROM CAPSTONE_DB.PUBLIC.GOLD_STORE_HOUR
WHERE sensor_ok
GROUP BY hour
ORDER BY conversion_rate ASC
LIMIT 3;

-- Q2: same query with the closing hour excluded, for comparison
SELECT hour,
       SUM(bills) AS total_bills,
       SUM(footfall) AS total_footfall,
       ROUND(SUM(bills) / NULLIF(SUM(footfall), 0), 4) AS conversion_rate
FROM CAPSTONE_DB.PUBLIC.GOLD_STORE_HOUR
WHERE sensor_ok AND hour < 21
GROUP BY hour
ORDER BY conversion_rate ASC
LIMIT 3;

-- Q3: does conversion drop on the busiest days? (footfall decile analysis)
WITH d AS (
  SELECT store_id, trade_date, SUM(footfall) f, SUM(bills) b
  FROM CAPSTONE_DB.PUBLIC.GOLD_STORE_HOUR
  WHERE sensor_ok
  GROUP BY 1, 2
),
r AS (
  SELECT d.*, NTILE(10) OVER (PARTITION BY store_id ORDER BY f) AS decile
  FROM d
)
SELECT decile,
       COUNT(*) AS store_days,
       SUM(f) AS visitors,
       SUM(b) AS bills,
       ROUND(SUM(b) / NULLIF(SUM(f), 0), 4) AS conversion_rate
FROM r
GROUP BY decile
ORDER BY decile;
