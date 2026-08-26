import duckdb

con = duckdb.connect("sage_assessment.duckdb")

sql = """
CREATE OR REPLACE TABLE fact_infusions AS

WITH order_series_clean AS (
    SELECT
        order_series_patients_id AS patient_id,
        CAST(order_series_order_series_id AS BIGINT) AS order_series_id,
        DATE '1899-12-30' + CAST(order_series_created_date AS INTEGER) AS order_series_created_date,
        order_series_formulary_brand_name AS drug_name,
        order_series_auth_required AS auth_required
    FROM order_series
),

latest_order_series_per_patient AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY patient_id
            ORDER BY order_series_created_date DESC, order_series_id DESC
        ) AS rn
    FROM order_series_clean
),

appointments_clean AS (
    SELECT
        appointments_order_series_id AS patient_id,
        CAST(appointments_id AS BIGINT) AS appointment_id,
        DATE '1899-12-30' + CAST(appointments_created_date AS INTEGER) AS appointment_created_date,
        DATE '1899-12-30' + CAST(appointments_start_date AS INTEGER) AS infusion_date,
        DATE_TRUNC('month', DATE '1899-12-30' + CAST(appointments_start_date AS INTEGER)) AS infusion_month,
        DATE_TRUNC('week', DATE '1899-12-30' + CAST(appointments_start_date AS INTEGER)) AS infusion_week,
        appointments_city AS location,
        appointments_status AS appointment_status,
        DATE '1899-12-30' + CAST(appointments_checked_in_time AS INTEGER) AS checked_in_date,
        appointments_piv_attempts AS piv_attempts,
        appointments_meds_administered AS meds_administered,
        CASE
            WHEN appointments_meds_administered = 'Yes' THEN 1
            ELSE 0
        END AS medication_administered_flag
    FROM appointments
    WHERE appointments_start_date IS NOT NULL
),

patients_clean AS (
    SELECT
        patients_patient_id AS patient_id,
        patients_age AS age,
        patients_sex AS sex
    FROM patients
)

SELECT
    a.appointment_id,
    a.patient_id,
    p.age,
    p.sex,
    a.appointment_created_date,
    a.infusion_date,
    a.infusion_month,
    a.infusion_week,
    a.location,
    a.appointment_status,
    a.checked_in_date,
    a.piv_attempts,
    a.meds_administered,
    a.medication_administered_flag,
    os.order_series_id,
    os.order_series_created_date,
    os.drug_name,
    os.auth_required
FROM appointments_clean a
LEFT JOIN patients_clean p
    ON a.patient_id = p.patient_id
LEFT JOIN latest_order_series_per_patient os
    ON a.patient_id = os.patient_id
   AND os.rn = 1
"""

con.execute(sql)

print("Created fact_infusions")

print("\nRow count:")
print(con.execute("SELECT COUNT(*) AS row_count FROM fact_infusions").fetchdf())

print("\nSample:")
print(con.execute("SELECT * FROM fact_infusions LIMIT 10").fetchdf())

print("\nCheck successful treatments:")
print(con.execute("""
    SELECT
        meds_administered,
        medication_administered_flag,
        COUNT(*) AS row_count
    FROM fact_infusions
    GROUP BY meds_administered, medication_administered_flag
    ORDER BY row_count DESC
""").fetchdf())

print("\nCheck drug nulls:")
print(con.execute("""
    SELECT
        COUNT(*) AS total_rows,
        SUM(CASE WHEN drug_name IS NULL THEN 1 ELSE 0 END) AS rows_missing_drug
    FROM fact_infusions
""").fetchdf())

con.close()