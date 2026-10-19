from pathlib import Path
import pandas as pd

path = Path("data/Online Retail.xlsx")
if not path.exists():
    raise SystemExit("Dataset not found. Download Online Retail.xlsx from the official UCI dataset page and place it in data/.")
df = pd.read_excel(path)
required = {"InvoiceNo", "StockCode", "Description", "Quantity", "InvoiceDate", "UnitPrice", "CustomerID", "Country"}
missing = required - set(df.columns)
if missing:
    raise SystemExit(f"Unexpected schema; missing columns: {sorted(missing)}")
print(f"Rows: {len(df):,}; columns: {len(df.columns)}")
print("\nTypes:")
print(df.dtypes)
print("\nMissing values:")
print(df.isna().sum().sort_values(ascending=False))
print(f"\nExact duplicate rows: {df.duplicated().sum():,}")
print(f"Cancellation invoice rows: {df['InvoiceNo'].astype(str).str.startswith('C').sum():,}")
print(f"Non-positive quantities: {(df['Quantity'] <= 0).sum():,}")
print(f"Non-positive unit prices: {(df['UnitPrice'] <= 0).sum():,}")
print(f"Date range: {df['InvoiceDate'].min()} to {df['InvoiceDate'].max()}")
print(df[["Quantity", "UnitPrice"]].describe())
