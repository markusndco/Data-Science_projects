import pandas as pd
import duckdb
import re

file_path = "Example Case Data - Data Analyst Role.xlsb"
db_path = "sage_assessment.duckdb"


def clean_name(name):
    name = str(name).strip().lower()
    name = name.replace(".", "_")
    name = re.sub(r"[^a-z0-9_]+", "_", name)
    name = re.sub(r"_+", "_", name)
    return name.strip("_")


def clean_dataframe(df):
    df = df.copy()

    # Clean column names only
    df.columns = [clean_name(col) for col in df.columns]

    # Do NOT drop any rows or columns
    return df


xls = pd.ExcelFile(file_path, engine="pyxlsb")
con = duckdb.connect(db_path)

for sheet in xls.sheet_names:
    print(f"Loading sheet: {sheet}")

    df = pd.read_excel(file_path, sheet_name=sheet, engine="pyxlsb")
    df = clean_dataframe(df)

    table_name = clean_name(sheet)

    con.register("temp_df", df)

    con.execute(f"""
        CREATE OR REPLACE TABLE {table_name} AS
        SELECT * FROM temp_df
    """)

    print(f"Created table: {table_name}")
    print(f"Rows: {len(df)}")
    print(f"Columns: {list(df.columns)}")
    print("-" * 80)

con.close()

print("Done. Created database:", db_path)