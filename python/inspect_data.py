"""Profile the official UCI Online Retail workbook without modifying raw data.

Run from the repository root:
    python -m pip install -r requirements.txt
    python python/inspect_data.py
"""
from __future__ import annotations

import json
from pathlib import Path

import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = ROOT / "data" / "Online Retail.xlsx"
REPORT_DIR = ROOT / "reports"
REQUIRED_COLUMNS = [
    "InvoiceNo", "StockCode", "Description", "Quantity",
    "InvoiceDate", "UnitPrice", "CustomerID", "Country",
]


def main() -> None:
    if not DATA_PATH.exists():
        raise SystemExit(
            "Dataset not found. Download 'Online Retail.xlsx' from "
            "https://archive.ics.uci.edu/dataset/352/online-retail and place it at "
            f"'{DATA_PATH}'. Do not commit the raw workbook to Git."
        )

    df = pd.read_excel(DATA_PATH)
    missing_columns = sorted(set(REQUIRED_COLUMNS) - set(df.columns))
    if missing_columns:
        raise SystemExit(f"Unexpected dataset schema; missing columns: {missing_columns}")

    # Parse dates for profiling only. The source workbook remains untouched.
    df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"], errors="coerce")
    invoice_text = df["InvoiceNo"].astype("string").str.strip()
    quantity = pd.to_numeric(df["Quantity"], errors="coerce")
    unit_price = pd.to_numeric(df["UnitPrice"], errors="coerce")

    missing_counts = df[REQUIRED_COLUMNS].isna().sum().to_dict()
    duplicate_rows = int(df.duplicated(subset=REQUIRED_COLUMNS).sum())
    cancellation_mask = invoice_text.str.upper().str.startswith("C", na=False)

    checks = {
        "row_count": int(len(df)),
        "column_count": int(len(df.columns)),
        "columns": list(df.columns),
        "date_min": None if df["InvoiceDate"].dropna().empty else str(df["InvoiceDate"].min()),
        "date_max": None if df["InvoiceDate"].dropna().empty else str(df["InvoiceDate"].max()),
        "missing_values_by_column": {k: int(v) for k, v in missing_counts.items()},
        "exact_duplicate_rows": duplicate_rows,
        "cancellation_invoice_rows": int(cancellation_mask.sum()),
        "negative_quantity_rows": int((quantity < 0).sum()),
        "zero_quantity_rows": int((quantity == 0).sum()),
        "negative_unit_price_rows": int((unit_price < 0).sum()),
        "zero_unit_price_rows": int((unit_price == 0).sum()),
        "invalid_invoice_date_rows": int(df["InvoiceDate"].isna().sum()),
        "distinct_invoice_numbers": int(df["InvoiceNo"].nunique(dropna=True)),
        "distinct_stock_codes": int(df["StockCode"].nunique(dropna=True)),
        "distinct_customer_ids_excluding_missing": int(df["CustomerID"].nunique(dropna=True)),
        "distinct_countries": int(df["Country"].nunique(dropna=True)),
        "top_10_countries_by_row_count": {
            str(k): int(v) for k, v in df["Country"].value_counts(dropna=False).head(10).items()
        },
        "quantity_summary": {
            k: (None if pd.isna(v) else float(v))
            for k, v in quantity.describe().to_dict().items()
        },
        "unit_price_summary": {
            k: (None if pd.isna(v) else float(v))
            for k, v in unit_price.describe().to_dict().items()
        },
        "notes": [
            "This is a raw-data profile, not a cleaned dataset.",
            "Cancellation invoices and negative quantities are flagged, not deleted.",
            "Revenue is not profit; UnitPrice * Quantity is a gross line-value proxy before business rules.",
            "Duplicate rows are reported, not automatically removed.",
        ],
    }

    REPORT_DIR.mkdir(exist_ok=True)
    json_path = REPORT_DIR / "initial_data_profile.json"
    missing_path = REPORT_DIR / "missing_values.csv"
    dtype_path = REPORT_DIR / "column_types.csv"

    json_path.write_text(json.dumps(checks, indent=2, ensure_ascii=False), encoding="utf-8")
    pd.DataFrame({
        "column": REQUIRED_COLUMNS,
        "missing_count": [int(df[c].isna().sum()) for c in REQUIRED_COLUMNS],
        "missing_percent": [round(float(df[c].isna().mean() * 100), 4) for c in REQUIRED_COLUMNS],
    }).to_csv(missing_path, index=False)
    pd.DataFrame({"column": df.columns, "dtype": [str(df[c].dtype) for c in df.columns]}).to_csv(
        dtype_path, index=False
    )

    print(f"Loaded: {DATA_PATH}")
    print(f"Rows: {len(df):,} | Columns: {len(df.columns)}")
    print(f"Date range: {checks['date_min']} to {checks['date_max']}")
    print(f"Exact duplicate rows: {duplicate_rows:,}")
    print(f"Cancellation invoice rows: {checks['cancellation_invoice_rows']:,}")
    print(f"Negative quantity rows: {checks['negative_quantity_rows']:,}")
    print(f"Zero/negative unit-price rows: {checks['zero_unit_price_rows'] + checks['negative_unit_price_rows']:,}")
    print("\nMissing values by column:")
    print(pd.Series(missing_counts).sort_values(ascending=False).to_string())
    print("\nTop countries by row count:")
    print(pd.Series(checks["top_10_countries_by_row_count"]).to_string())
    print(f"\nReports saved under: {REPORT_DIR.relative_to(ROOT)}/")


if __name__ == "__main__":
    main()
