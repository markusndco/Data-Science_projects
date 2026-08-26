# 🏥 Healthcare Infusion Analytics Pipeline

An end-to-end **healthcare data analytics and data engineering project** built using **Python, SQL, Pandas, DuckDB, and Excel/XLSB data**.

The project transforms raw operational infusion-center data into a structured analytical model that can answer patient-volume, treatment, medication, location, operational-performance, and data-quality questions.

The workflow covers the complete analytical lifecycle:

**Raw XLSB Data → Data Profiling → DuckDB Ingestion → Data Modeling → Validation → SQL Analytics → Operational Reporting**

---

## 🎯 Project Objective

Healthcare operational data often exists across multiple source tables containing patient, appointment, medication, authorization, and treatment information.

The objective of this project was to build a reproducible analytics workflow capable of:

* Identifying patients who actually received infusions
* Measuring completed treatment volumes
* Analyzing drug administration by location and month
* Tracking weekly infusion operations
* Measuring week-over-week operational changes
* Evaluating PIV attempt patterns
* Identifying data-quality issues
* Creating a reusable analytical fact table for downstream reporting

---

## 🏗️ Architecture

```text
Raw XLSB Workbook
        │
        ▼
Python / Pandas
Data Inspection & Profiling
        │
        ▼
DuckDB Raw Tables
        │
        ▼
Join & Relationship Validation
        │
        ▼
Data Cleaning / Transformation
        │
        ▼
fact_infusions
Analytical Fact Table
        │
        ▼
SQL Analytical Queries
        │
        ├── Patient Volume Analysis
        ├── Treatment Completion Analysis
        ├── Drug / Location Analysis
        ├── Monthly Trends
        ├── Weekly Operations
        └── Data Quality Monitoring
        │
        ▼
CSV Analytical Outputs
```

---

## 📊 Source Data

The source dataset is provided as an **Excel Binary Workbook (`.xlsb`)** containing multiple operational tables.

Python and `pyxlsb` are used to inspect the workbook, identify available sheets, examine schemas, and load the source data.

The ingestion process standardizes column names while intentionally preserving the underlying source rows and columns.

---

## 🧱 Analytical Data Model

A centralized analytical table named:

```sql
fact_infusions
```

is created in DuckDB.

The table combines information from:

* Appointments
* Patients
* Order series
* Drug information
* Treatment status
* Location
* PIV attempts
* Medication administration
* Authorization attributes

The appointment dataset is treated as the primary **infusion event grain**.

---

## 🔑 Business Logic

### Successful Treatment Definition

A treatment is considered successfully administered when:

```text
meds_administered = 'Yes'
```

This is converted into a reusable analytical flag:

```sql
CASE
    WHEN meds_administered = 'Yes' THEN 1
    ELSE 0
END AS medication_administered_flag
```

This provides a consistent treatment definition across all downstream analyses.

### Drug Mapping

Patients may have multiple order-series records.

To prevent multiple order-series records from duplicating appointment rows, the latest order series is selected per patient using:

```sql
ROW_NUMBER() OVER (
    PARTITION BY patient_id
    ORDER BY order_series_created_date DESC,
             order_series_id DESC
)
```

Only the latest record is subsequently joined to the infusion fact table.

### Date Conversion

Excel serial dates are converted into analytical dates using the Excel date origin:

```sql
DATE '1899-12-30' + CAST(date_column AS INTEGER)
```

Additional dimensions are generated for:

* Infusion date
* Infusion month
* Infusion week

---

## 🔍 Analytical Questions

### 1. How many unique patients received infusions each month?

Monthly patient volume is calculated using:

```sql
COUNT(DISTINCT patient_id)
```

and restricted to treatments where medication was actually administered.

This provides a monthly view of active infusion patients.

---

### 2. How many treatments were successfully completed during Q1 2026?

The analysis isolates administered treatments between:

```text
2026-01-01
and
2026-03-31
```

using the medication-administration flag.

---

### 3. Which drug and location had the highest administration volume?

Drug and location combinations are aggregated using administered infusion counts.

Because the source dataset does **not contain an actual administered-volume field**, the number of successfully administered infusions is explicitly used as the available proxy for administration volume.

---

### 4. Which drug/location combination led each month?

Monthly drug/location combinations are aggregated and ranked using:

```sql
ROW_NUMBER() OVER (
    PARTITION BY infusion_month
    ORDER BY total_administered_infusions DESC
)
```

This identifies the highest-volume combination for every month.

---

### 5. Weekly Operations Report

A reusable weekly operational dataset is generated containing:

* Infusion week
* Location
* Drug
* Total infusions
* Unique patients
* Average PIV attempts per infusion
* Prior-week infusion count
* Week-over-week percentage change

Week-over-week comparisons are calculated using SQL window functions:

```sql
LAG(total_infusions) OVER (
    PARTITION BY location, drug_name
    ORDER BY infusion_week
)
```

This creates a reporting-ready dataset for monitoring changes in infusion-center activity.

---

## 🧪 Data Quality Validation

Data quality is treated as a separate analytical requirement rather than assuming that source-system records are internally consistent.

Validation includes checks for:

* Missing patient IDs
* Missing infusion dates
* Missing locations
* Missing drug mappings
* Missing PIV attempts
* Negative PIV attempts
* Completed appointments where medication was not administered
* Medication administered when appointment status was not complete

Join diagnostics are also performed across:

```text
Appointments ↔ Patients
Appointments ↔ Order Series
Order Series ↔ Authorization
```

This helps detect potential relationship problems before downstream metrics are trusted.

---

## 📈 Example Analytical Results

The completed pipeline produced several operational findings from the supplied dataset.

### Q1 2026

**1,041 successfully administered treatments** were identified during Q1 2026.

### Monthly Unique Infusion Patients

| Month         | Unique Patients |
| ------------- | --------------: |
| December 2025 |              42 |
| January 2026  |             134 |
| February 2026 |             269 |
| March 2026    |             400 |
| April 2026    |             228 |

### Highest Drug / Location Combination

The highest overall observed combination was:

**LEQEMBI — Sarasota**

with **129 administered infusions**.

These results represent the supplied case-study dataset and should not be interpreted as real-world clinical or operational benchmarks.

---

## ⚠️ Important Analytical Assumptions

Several assumptions were required because of limitations in the supplied source data.

1. **Appointments represent infusion events.**
2. `meds_administered = 'Yes'` defines a successfully administered treatment.
3. The dataset does not contain actual administered medication volume.
4. **Administered infusion count** is therefore used as the available proxy for administered volume.
5. The latest order-series record per patient is used for drug mapping to prevent duplicate appointment records.
6. Missing PIV-attempt values are preserved and surfaced through data-quality reporting rather than silently imputed.

These assumptions are explicitly documented to maintain analytical transparency and reproducibility.

---

## 🛠️ Technology Stack

**Languages**

* Python
* SQL

**Data Processing**

* Pandas
* pyxlsb

**Analytical Database**

* DuckDB

**Techniques**

* Data profiling
* Data cleaning
* Relational joins
* Fact-table modeling
* Window functions
* CTEs
* Conditional aggregation
* Time-series aggregation
* Week-over-week analysis
* Data-quality validation

**Outputs**

* DuckDB analytical database
* CSV reports
* Reusable SQL queries

---

## 📂 Suggested Repository Structure

```text
Healthcare-Infusion-Analytics-DuckDB/
│
├── README.md
│
├── data/
│   └── README.md
│
├── src/
│   ├── inspect_xlsb.py
│   ├── load_to_duckdb.py
│   ├── inspect_db.py
│   ├── check_joins.py
│   ├── explore_drugs_dates.py
│   ├── create_fact_infusions.py
│   └── run_assessment_queries.py
│
├── sql/
│   └── assessment_queries.sql
│
├── output/
│   ├── 01_unique_patients_by_month.csv
│   ├── 02_completed_treatments_q1_2026.csv
│   ├── 03_highest_drug_location_overall.csv
│   ├── 04_highest_drug_location_by_month.csv
│   ├── 05_weekly_operations_report.csv
│   └── 06_data_quality_summary.csv
│
└── requirements.txt
```

---

## 🔄 Pipeline Workflow

### Step 1 — Inspect Source Workbook

```bash
python src/inspect_xlsb.py
```

Identifies workbook sheets, columns, dimensions, and sample records.

### Step 2 — Load Raw Data into DuckDB

```bash
python src/load_to_duckdb.py
```

Creates standardized DuckDB tables from the XLSB source.

### Step 3 — Inspect Database

```bash
python src/inspect_db.py
```

Reviews generated schemas and sample records.

### Step 4 — Validate Relationships

```bash
python src/check_joins.py
```

Tests relationships between appointments, patients, order series, and authorization data.

### Step 5 — Build Analytical Fact Table

```bash
python src/create_fact_infusions.py
```

Creates the reusable:

```text
fact_infusions
```

analytical layer.

### Step 6 — Execute Analytics

```bash
python src/run_assessment_queries.py
```

Executes the business queries and exports reporting datasets to CSV.

---

## 💡 Key Engineering Decisions

### Why DuckDB?

DuckDB provides an efficient analytical SQL engine that runs locally without requiring database infrastructure.

It makes this project:

* Portable
* Reproducible
* SQL-native
* Lightweight
* Easy to execute locally

### Why Build a Fact Table?

Rather than repeatedly rebuilding joins for every business question, the pipeline creates a centralized `fact_infusions` table.

This separates:

```text
Source ingestion
        ↓
Transformation
        ↓
Analytical modeling
        ↓
Business reporting
```

and creates a reusable foundation for additional analytics or BI dashboards.

---

## 🚀 Potential Extensions

The analytical layer could be extended into:

* Power BI / Tableau / Sigma dashboards
* Infusion-center capacity analysis
* Drug utilization forecasting
* Patient treatment-frequency analysis
* Location-level operational benchmarking
* PIV-attempt monitoring
* Appointment cancellation/no-show analysis
* Authorization workflow analysis
* Automated data-quality alerts
* Cloud-based ELT pipelines

---

## 🧠 Skills Demonstrated

This project demonstrates practical experience with:

`Python` `SQL` `DuckDB` `Pandas` `Data Engineering` `ETL` `Data Modeling` `Healthcare Analytics` `Window Functions` `Data Quality` `Operational Analytics` `Business Intelligence`

---

## 👤 Author

**Aryan Sharma**

Data Scientist | Data Analytics | Machine Learning | Data Engineering

[GitHub](https://github.com/markusndco) | [LinkedIn](https://www.linkedin.com/in/aryansharma250)

---

## 📘 Disclaimer

This repository is intended as a **portfolio and analytical case-study project**.

The analysis reflects the structure and assumptions of the supplied case dataset. Any healthcare-related metrics are analytical examples and should not be interpreted as clinical recommendations.
