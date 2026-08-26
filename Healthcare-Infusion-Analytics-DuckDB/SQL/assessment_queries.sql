-- Sage Infusion Data Analyst Assessment
-- Analyst: Aryan Sharma
-- Notes:
-- 1. Each XLSB sheet was loaded as a raw DuckDB table.
-- 2. appointments is treated as the infusion event table.
-- 3. meds_administered = 'Yes' is used as the definition of successfully completed treatment.
-- 4. The dataset does not include an actual administered volume column, so count of administered infusions is used as the available proxy for administered volume.
-- 5. To avoid duplicate appointment rows, drug_name is mapped using the latest order_series record per patient.

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
   AND os.rn = 1;


-- 1. Unique patients who received infusions by month

SELECT
    infusion_month,
    COUNT(DISTINCT patient_id) AS unique_patients_received_infusions
FROM fact_infusions
WHERE medication_administered_flag = 1
GROUP BY infusion_month
ORDER BY infusion_month;


-- 2. Successfully completed treatments in Q1-2026

SELECT
    COUNT(*) AS completed_treatments_q1_2026
FROM fact_infusions
WHERE medication_administered_flag = 1
  AND infusion_date >= DATE '2026-01-01'
  AND infusion_date < DATE '2026-04-01';


-- 3. Highest administered drug/location overall
-- Note: count of administered infusions is used as proxy because no administered volume field exists.

SELECT
    drug_name,
    location,
    COUNT(*) AS total_administered_infusions
FROM fact_infusions
WHERE medication_administered_flag = 1
GROUP BY
    drug_name,
    location
ORDER BY total_administered_infusions DESC
LIMIT 1;


-- 4. Highest administered drug/location by month

WITH monthly_drug_location AS (
    SELECT
        infusion_month,
        drug_name,
        location,
        COUNT(*) AS total_administered_infusions
    FROM fact_infusions
    WHERE medication_administered_flag = 1
    GROUP BY
        infusion_month,
        drug_name,
        location
),

ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY infusion_month
            ORDER BY total_administered_infusions DESC
        ) AS rn
    FROM monthly_drug_location
)

SELECT
    infusion_month,
    drug_name,
    location,
    total_administered_infusions
FROM ranked
WHERE rn = 1
ORDER BY infusion_month;


-- 5. Weekly Operations report

WITH weekly_summary AS (
    SELECT
        infusion_week,
        location,
        drug_name,
        COUNT(*) AS total_infusions,
        COUNT(DISTINCT patient_id) AS unique_patients,
        AVG(piv_attempts) AS avg_piv_attempts_per_infusion
    FROM fact_infusions
    WHERE medication_administered_flag = 1
    GROUP BY
        infusion_week,
        location,
        drug_name
),

weekly_with_prior AS (
    SELECT
        *,
        LAG(total_infusions) OVER (
            PARTITION BY location, drug_name
            ORDER BY infusion_week
        ) AS prior_week_infusions
    FROM weekly_summary
)

SELECT
    infusion_week,
    location,
    drug_name,
    total_infusions,
    unique_patients,
    ROUND(avg_piv_attempts_per_infusion, 2) AS avg_piv_attempts_per_infusion,
    prior_week_infusions,
    CASE
        WHEN prior_week_infusions IS NULL OR prior_week_infusions = 0
        THEN NULL
        ELSE ROUND(
            100.0 * (total_infusions - prior_week_infusions) / prior_week_infusions,
            2
        )
    END AS wow_change_pct
FROM weekly_with_prior
ORDER BY
    infusion_week,
    location,
    drug_name;


-- 6. Data quality summary

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
FROM fact_infusions;