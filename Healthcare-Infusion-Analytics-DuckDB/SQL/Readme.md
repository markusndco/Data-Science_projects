# 🗄️ SQL

This folder contains the **analytical SQL queries** used to answer the project's business and operational questions.

## What's Here

Queries cover:

- Monthly patient volume
- Successfully administered treatments
- Drug and location utilization
- Monthly performance rankings
- Weekly operational trends
- Week-over-week analysis
- Data quality checks

## Goal

Separate the **business and analytical logic** from the Python pipeline so the calculations remain transparent, reusable, and easy to validate.

> SQL is executed against the curated `fact_infusions` analytical table in DuckDB.
