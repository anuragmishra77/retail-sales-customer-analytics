# Assumptions and policies

1. Preserve source rows in staging; never delete raw records during cleaning.
2. line_revenue = quantity * unit_price; this is not profit.
3. The default sales view excludes cancellation invoice identifiers, non-positive quantity/price rows and rows without invoice timestamp. Returns and excluded rows remain available for separate analysis.
4. InvoiceNo is treated as the order identifier for distinct-order KPIs, subject to validation; one invoice can have many product lines.
5. Customer analyses exclude missing CustomerID; sales analyses may include those transactions.
6. Exact duplicate-looking rows are flagged for review, not automatically deleted.
7. No product categories or profit claims without additional validated data.
8. Findings must be calculated from the actual source and include period, KPI definition and limitations.
