import duckdb

db_path = "sage_assessment.duckdb"

con = duckdb.connect(db_path)

tables = con.execute("SHOW TABLES").fetchall()

print("Tables in database:")
for table in tables:
    print("-", table[0])

for table in tables:
    table_name = table[0]

    print("\n" + "=" * 80)
    print(f"TABLE: {table_name}")
    print("=" * 80)

    print("\nSchema:")
    print(con.execute(f"DESCRIBE {table_name}").fetchdf())

    print("\nSample rows:")
    print(con.execute(f"SELECT * FROM {table_name} LIMIT 10").fetchdf())

con.close()