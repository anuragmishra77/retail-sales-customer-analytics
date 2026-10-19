# Data dictionary

| Source field | Meaning | Notes |
|---|---|---|
| InvoiceNo | Invoice identifier | Values beginning with C indicate cancellation under source convention; validate before excluding |
| StockCode | Product code | Keep as text |
| Description | Product description | May be missing or inconsistent |
| Quantity | Units on invoice line | Negative values may represent returns |
| InvoiceDate | Invoice timestamp | Use date_trunc for monthly trends |
| UnitPrice | Unit price | Not product cost |
| CustomerID | Customer identifier | May be missing |
| Country | Country field in source | Do not assume it means shipping destination |

Derived line_revenue = quantity * unit_price is a signed line value, not profit. The source does not provide cost, margin, product category or customer demographics.
