# Setup

Requirements: PostgreSQL 15+, Python 3.10+, Git, and Power BI Desktop for dashboard authoring.

1. Download Online Retail.xlsx from https://archive.ics.uci.edu/dataset/352/online+retail and place it in data/ locally.
2. Create a virtual environment and run `python -m pip install -r requirements.txt`.
3. Run `python python/inspect_data.py`.
4. Create a PostgreSQL database and execute `sql/01_schema.sql`.
5. PostgreSQL COPY does not read XLSX. Export the worksheet to CSV, then use pgAdmin Import/Export or psql's \\copy to load columns in source order into staging.online_retail_raw. Do not import source_row_id; it is generated automatically.
6. Run the quality checks, inspect exclusions and validate row counts before running analytical queries.

Never treat query execution alone as proof of correctness. Reconcile raw rows, return/cancellation amounts and the default sales view.
