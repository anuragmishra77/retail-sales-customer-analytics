# DAX starter measures
Assume the model contains SalesLines with line_revenue, invoice_no, customer_id and quantity columns. Adjust names to your model.

```DAX
Revenue = SUM ( SalesLines[line_revenue] )
Orders = DISTINCTCOUNT ( SalesLines[invoice_no] )
Units Sold = SUM ( SalesLines[quantity] )
Identified Customers = CALCULATE ( DISTINCTCOUNT ( SalesLines[customer_id] ), SalesLines[customer_id] <> BLANK() )
Average Order Value = DIVIDE ( [Revenue], [Orders] )
```

Validate filter behavior and reconcile each measure with PostgreSQL before publication.
