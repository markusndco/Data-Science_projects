import duckdb

con = duckdb.connect("sage_assessment.duckdb")

queries = {
    "drug_values": """
        SELECT
            order_series_formulary_brand_name AS drug_name,
            COUNT(*) AS row_count,
            COUNT(DISTINCT order_series_patients_id) AS unique_patients
        FROM order_series
        GROUP BY order_series_formulary_brand_name
        ORDER BY row_count DESC
    """,

    "patients_with_multiple_distinct_drugs": """
        SELECT
            order_series_patients_id AS patient_id,
            COUNT(*) AS order_series_count,
            COUNT(DISTINCT order_series_formulary_brand_name) AS distinct_drug_count,
            STRING_AGG(DISTINCT order_series_formulary_brand_name, ', ') AS drugs
        FROM order_series
        GROUP BY order_series_patients_id
        HAVING COUNT(DISTINCT order_series_formulary_brand_name) > 1
        ORDER BY distinct_drug_count DESC, order_series_count DESC
    """,

    "date_ranges_converted": """
        SELECT
            MIN(DATE '1899-12-30' + CAST(appointments_start_date AS INTEGER)) AS min_start_date,
            MAX(DATE '1899-12-30' + CAST(appointments_start_date AS INTEGER)) AS max_start_date,
            MIN(DATE '1899-12-30' + CAST(appointments_created_date AS INTEGER)) AS min_created_date,
            MAX(DATE '1899-12-30' + CAST(appointments_created_date AS INTEGER)) AS max_created_date
        FROM appointments
        WHERE appointments_start_date IS NOT NULL
    """,

    "completed_vs_administered_cross_tab": """
        SELECT
            appointments_status,
            appointments_meds_administered,
            COUNT(*) AS row_count
        FROM appointments
        GROUP BY
            appointments_status,
            appointments_meds_administered
        ORDER BY
            appointments_status,
            appointments_meds_administered
    """,

    "authorization_join_fixed": """
        SELECT
            COUNT(*) AS total_order_series,
            COUNT(la.latest_authorization_order_series_id) AS matched_authorizations,
            COUNT(*) - COUNT(la.latest_authorization_order_series_id) AS unmatched_order_series
        FROM order_series os
        LEFT JOIN latest_authorization la
            ON CAST(os.order_series_order_series_id AS BIGINT)
             = CAST(la.latest_authorization_order_series_id AS BIGINT)
    """
}

for name, sql in queries.items():
    print("\n" + "=" * 100)
    print(name)
    print("=" * 100)
    print(con.execute(sql).fetchdf())

con.close()