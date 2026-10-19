-- Non-destructive flags: preserve all raw records.
CREATE OR REPLACE VIEW analytics.v_transaction_quality AS
SELECT r.*,
 (UPPER(BTRIM(COALESCE(invoice_no,''))) LIKE 'C%') AS is_cancellation_invoice,
 (quantity<0) AS is_negative_quantity,
 (unit_price<=0) AS is_nonpositive_unit_price,
 (customer_id IS NULL OR BTRIM(customer_id)='') AS is_missing_customer
FROM staging.online_retail_raw r;

-- Default positive-sales view, not a net-sales/refunds view.
CREATE OR REPLACE VIEW analytics.v_sales_lines AS
SELECT source_row_id, invoice_no, stock_code, description, quantity, invoice_date, unit_price,
 NULLIF(BTRIM(customer_id),'') AS customer_id, country,
 quantity::NUMERIC*unit_price AS line_revenue
FROM analytics.v_transaction_quality
WHERE NOT is_cancellation_invoice AND quantity>0 AND unit_price>0 AND invoice_date IS NOT NULL;
