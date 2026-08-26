import duckdb
import pandas as pd

pd.set_option("display.max_columns", None)
pd.set_option("display.width", 200)

con = duckdb.connect("sage_assessment.duckdb")

df = con.execute("""
    SELECT
        COUNT(*) AS total_fact_rows,
        SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END) AS missing_patient_id_rows,
        SUM(CASE WHEN infusion_date IS NULL THEN 1 ELSE 0 END) AS missing_infusion_date_rows,
        SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END) AS missing_location_rows,
        SUM(CASE WHEN drug_name IS NULL THEN 1 ELSE 0 END) AS missing_drug_rows,
        SUM(CASE WHEN piv_attempts IS NULL THEN 1 ELSE 0 END) AS missing_piv_attempt_rows,
        SUM(CASE WHEN piv_attempts < 0 THEN 1 ELSE 0 END) AS negative_piv_attempt_rows,
        SUM(CASE WHEN appointment_status = 'Complete' AND meds_administered = 'No' THEN 1 ELSE 0 END) AS complete_without_meds_administered_rows,
        SUM(CASE WHEN appointment_status <> 'Complete' AND meds_administered = 'Yes' THEN 1 ELSE 0 END) AS meds_administered_without_complete_status_rows
    FROM fact_infusions
""").fetchdf()

print(df.to_string(index=False))

con.close()