import duckdb
from pathlib import Path

con = duckdb.connect("sage_assessment.duckdb")

output_dir = Path("output")
output_dir.mkdir(exist_ok=True)

queries = {
    "01_unique_patients_by_month": """
        SELECT
            infusion_month,
            COUNT(DISTINCT patient_id) AS unique_patients_received_infusions
        FROM fact_infusions
        WHERE medication_administered_flag = 1
        GROUP BY infusion_month
        ORDER BY infusion_month
    """,

    "02_completed_treatments_q1_2026": """
        SELECT
            COUNT(*) AS completed_treatments_q1_2026
        FROM fact_infusions
        WHERE medication_administered_flag = 1
          AND infusion_date >= DATE '2026-01-01'
          AND infusion_date < DATE '2026-04-01'
    """,

    "03_highest_drug_location_overall": """
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
        LIMIT 1
    """,

    "04_highest_drug_location_by_month": """
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
        ORDER BY infusion_month
    """,

    "05_weekly_operations_report": """
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
            drug_name
    """,

    "06_data_quality_summary": """
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
    """
}

for name, sql in queries.items():
    print("\n" + "=" * 100)
    print(name)
    print("=" * 100)

    df = con.execute(sql).fetchdf()
    print(df)

    output_path = output_dir / f"{name}.csv"
    df.to_csv(output_path, index=False)
    print(f"Saved to: {output_path}")

con.close()