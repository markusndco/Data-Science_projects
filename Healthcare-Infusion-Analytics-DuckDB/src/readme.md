# ⚙️ Source Code

This folder contains the **Python pipeline** responsible for processing the project from raw data to analytical outputs.

## What's Here

The scripts handle:

- XLSB workbook inspection
- Data ingestion with Pandas
- DuckDB table creation
- Schema inspection
- Join and relationship validation
- Date and field exploration
- `fact_infusions` construction
- Data quality validation
- Analytical query execution
- CSV output generation

## Goal

Create a **reproducible end-to-end analytics pipeline** that transforms raw operational healthcare data into a validated and reusable analytical model.

## Pipeline

```text
Raw XLSB
   ↓
Python / Pandas
   ↓
DuckDB Raw Tables
   ↓
Join & Data Validation
   ↓
fact_infusions
   ↓
SQL Analytics
   ↓
CSV Outputs
