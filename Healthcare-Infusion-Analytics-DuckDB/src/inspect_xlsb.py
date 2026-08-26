import pandas as pd

file_path = "Example Case Data - Data Analyst Role.xlsb"

xls = pd.ExcelFile(file_path, engine="pyxlsb")

print("Sheets found:")
for sheet in xls.sheet_names:
    print("-", sheet)

print("\n\nInspecting each sheet:")

for sheet in xls.sheet_names:
    print("\n" + "=" * 80)
    print(f"SHEET: {sheet}")
    print("=" * 80)

    df = pd.read_excel(file_path, sheet_name=sheet, engine="pyxlsb")

    print("\nColumns:")
    for col in df.columns:
        print("-", col)

    print("\nShape:")
    print(df.shape)

    print("\nFirst 5 rows:")
    print(df.head())