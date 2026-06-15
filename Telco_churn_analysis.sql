/* =========================================================
   Telco Customer Churn Analysis
   Dataset: IBM Telco Customer Churn (via Kaggle)
   Tool: PostgreSQL / DBeaver
   Author: Divya (Bhat) Miller
   ========================================================= */


/* ---------------------------------------------------------
   SETUP: Create table and load data
   All columns loaded as VARCHAR to avoid import errors from
   empty strings in numeric fields; cast as needed in queries.
   --------------------------------------------------------- */

CREATE TABLE telco_customer_churn (
    "CustomerID" VARCHAR,
    "Count" VARCHAR,
    "Country" VARCHAR,
    "State" VARCHAR,
    "City" VARCHAR,
    "Zip Code" VARCHAR,
    "Lat Long" VARCHAR,
    "Latitude" VARCHAR,
    "Longitude" VARCHAR,
    "Gender" VARCHAR,
    "Senior Citizen" VARCHAR,
    "Partner" VARCHAR,
    "Dependents" VARCHAR,
    "Tenure Months" VARCHAR,
    "Phone Service" VARCHAR,
    "Multiple Lines" VARCHAR,
    "Internet Service" VARCHAR,
    "Online Security" VARCHAR,
    "Online Backup" VARCHAR,
    "Device Protection" VARCHAR,
    "Tech Support" VARCHAR,
    "Streaming TV" VARCHAR,
    "Streaming Movies" VARCHAR,
    "Contract" VARCHAR,
    "Paperless Billing" VARCHAR,
    "Payment Method" VARCHAR,
    "Monthly Charges" VARCHAR,
    "Total Charges" VARCHAR,
    "Churn Label" VARCHAR,
    "Churn Value" VARCHAR,
    "Churn Score" VARCHAR,
    "CLTV" VARCHAR,
    "Churn Reason" VARCHAR
);

COPY telco_customer_churn FROM '/Users/divyabhat/Downloads/Telco_customer_churn.csv'
WITH (FORMAT csv, HEADER true, NULL '');


/* ---------------------------------------------------------
   ORIENTATION: Basic exploration
   --------------------------------------------------------- */

-- Row count
SELECT COUNT(*) FROM telco_customer_churn;

-- Preview the data
SELECT *
FROM telco_customer_churn
LIMIT 5;

-- Column list
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'telco_customer_churn';

-- Understand churn-related columns
SELECT DISTINCT "Churn Label", "Churn Value", "Churn Score"
FROM telco_customer_churn
LIMIT 10;


/* ---------------------------------------------------------
   Q1: What percent of customers churned overall?
   --------------------------------------------------------- */

SELECT (SUM("Churn Value"::numeric) / COUNT(*)) * 100 AS percent_customers_churned
FROM telco_customer_churn;


/* ---------------------------------------------------------
   Q2: What are the most common reasons customers churned?
   --------------------------------------------------------- */

SELECT "Churn Reason", COUNT("Churn Reason") AS churn_reason_count
FROM telco_customer_churn
GROUP BY "Churn Reason"
ORDER BY churn_reason_count DESC;


/* ---------------------------------------------------------
   Q3: Does churn rate differ by contract type?
   --------------------------------------------------------- */

SELECT "Contract", (SUM("Churn Value"::numeric) / COUNT(*)) * 100 AS percent_churn
FROM telco_customer_churn
GROUP BY "Contract"
ORDER BY percent_churn DESC;


/* ---------------------------------------------------------
   Q4: Does churn rate differ by customer tenure?
   --------------------------------------------------------- */

-- Check tenure range first
SELECT MIN("Tenure Months"::numeric), MAX("Tenure Months"::numeric)
FROM telco_customer_churn;

-- Bucket tenure into 12-month bands and calculate churn rate
SELECT
    CASE
        WHEN "Tenure Months"::numeric BETWEEN 0 AND 12 THEN 'One year'
        WHEN "Tenure Months"::numeric BETWEEN 13 AND 24 THEN 'Two years'
        WHEN "Tenure Months"::numeric BETWEEN 25 AND 36 THEN 'Three years'
        WHEN "Tenure Months"::numeric BETWEEN 37 AND 48 THEN 'Four years'
        WHEN "Tenure Months"::numeric BETWEEN 49 AND 60 THEN 'Five years'
        WHEN "Tenure Months"::numeric BETWEEN 61 AND 72 THEN 'Six years'
    END AS tenure_bucket,
    SUM("Churn Value"::numeric) / COUNT(*) * 100 AS percent_churn
FROM telco_customer_churn
GROUP BY tenure_bucket
ORDER BY percent_churn DESC;


/* ---------------------------------------------------------
   Q5: Does churn rate differ by monthly charges?
   --------------------------------------------------------- */

-- Check monthly charges range first
SELECT MIN("Monthly Charges"::numeric), MAX("Monthly Charges"::numeric)
FROM telco_customer_churn;

-- Bucket monthly charges into $20 bands and calculate churn rate
SELECT
    CASE
        WHEN "Monthly Charges"::numeric BETWEEN 0 AND 20 THEN '0-20'
        WHEN "Monthly Charges"::numeric BETWEEN 20 AND 40 THEN '20-40'
        WHEN "Monthly Charges"::numeric BETWEEN 40 AND 60 THEN '40-60'
        WHEN "Monthly Charges"::numeric BETWEEN 60 AND 80 THEN '60-80'
        WHEN "Monthly Charges"::numeric BETWEEN 80 AND 100 THEN '80-100'
        WHEN "Monthly Charges"::numeric BETWEEN 100 AND 120 THEN '100-120'
    END AS monthly_pay_bucket,
    SUM("Churn Value"::numeric) / COUNT(*) * 100 AS percent_churn
FROM telco_customer_churn
GROUP BY monthly_pay_bucket
ORDER BY percent_churn DESC;


/* ---------------------------------------------------------
   Q6: Does churn rate differ by internet service type?
   --------------------------------------------------------- */

SELECT "Internet Service", COUNT(*) AS customer_count,
    (SUM("Churn Value"::numeric) / COUNT(*)) * 100 AS percent_customers_churned
FROM telco_customer_churn
GROUP BY "Internet Service"
ORDER BY percent_customers_churned DESC;


/* ---------------------------------------------------------
   Q7: Does having Tech Support affect churn?
   --------------------------------------------------------- */

-- Tech Support alone
SELECT "Tech Support", COUNT(*) AS customer_count,
    (SUM("Churn Value"::numeric) / COUNT(*)) * 100 AS percent_customers_churned
FROM telco_customer_churn
GROUP BY "Tech Support"
ORDER BY percent_customers_churned DESC;

-- Tech Support combined with Internet Service type
SELECT "Internet Service", "Tech Support", COUNT(*) AS customer_count,
    (SUM("Churn Value"::numeric) / COUNT(*)) * 100 AS percent_customers_churned
FROM telco_customer_churn
GROUP BY "Internet Service", "Tech Support"
ORDER BY percent_customers_churned DESC;
