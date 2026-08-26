import duckdb
import pandas as pd

pd.set_option("display.max_columns", None)
pd.set_option("display.width", 250)

con = duckdb.connect("sage_assessment.duckdb")

df = con.execute("""
    SELECT *
    FROM fact_infusions
    LIMIT 50
""").fetchdf()

print(df.to_string(index=False))

con.close()