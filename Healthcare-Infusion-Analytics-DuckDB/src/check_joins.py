import duckdb

con = duckdb.connect("sage_assessment.duckdb")

checks = {
    "appointment_patient_match": """
        SELECT
            COUNT(*) AS total_appointments,
            COUNT(p.patients_patient_id) AS matched_patients,
            COUNT(*) - COUNT(p.patients_patient_id) AS unmatched_appointments
        FROM appointments a
        LEFT JOIN patients p
            ON a.appointments_order_series_id = p.patients_patient_id
    """,

    "appointment_order_series_match_by_patient": """
        SELECT
            COUNT(*) AS joined_rows
        FROM appointments a
        LEFT JOIN order_series os
            ON a.appointments_order_series_id = os.order_series_patients_id
    """,

    "raw_appointment_count": """
        SELECT COUNT(*) AS raw_appointment_count
        FROM appointments
    """,

    "patients_with_multiple_order_series": """
        SELECT
            order_series_patients_id,
            COUNT(*) AS order_series_count,
            COUNT(DISTINCT order_series_formulary_brand_name) AS distinct_drug_count
        FROM order_series
        GROUP BY order_series_patients_id
        HAVING COUNT(*) > 1
        ORDER BY order_series_count DESC
        LIMIT 20
    """,

    "order_series_authorization_match": """
        SELECT
            COUNT(*) AS total_order_series,
            COUNT(la.latest_authorization_order_series_id) AS matched_authorizations,
            COUNT(*) - COUNT(la.latest_authorization_order_series_id) AS unmatched_order_series
        FROM order_series os
        LEFT JOIN latest_authorization la
            ON CAST(os.order_series_order_series_id AS VARCHAR) = la.latest_authorization_order_series_id
    """,

    "meds_administered_values": """
        SELECT
            appointments_meds_administered,
            COUNT(*) AS row_count
        FROM appointments
        GROUP BY appointments_meds_administered
        ORDER BY row_count DESC
    """,

    "appointment_status_values": """
        SELECT
            appointments_status,
            COUNT(*) AS row_count
        FROM appointments
        GROUP BY appointments_status
        ORDER BY row_count DESC
    """,

    "city_values": """
        SELECT
            appointments_city,
            COUNT(*) AS row_count
        FROM appointments
        GROUP BY appointments_city
        ORDER BY row_count DESC
    """
}

for name, sql in checks.items():
    print("\n" + "=" * 100)
    print(name)
    print("=" * 100)
    print(con.execute(sql).fetchdf())

con.close()