# SQL execution order
1. `01_schema.sql` creates raw staging and analytical tables.
2. Import source rows into `staging.online_retail_raw` (PostgreSQL COPY reads CSV, not XLSX; export the worksheet to CSV first).
3. `02_data_quality_checks.sql` profiles anomalies.
4. `03_cleaning_views.sql` creates non-destructive views.
5. Run `04_basic_analysis.sql`, `05_intermediate_analysis.sql`, and `06_advanced_analysis.sql`.
Review all assumptions and reconcile totals before reporting findings.
