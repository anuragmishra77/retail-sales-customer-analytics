SELECT COUNT(*) AS raw_rows FROM staging.online_retail_raw;
SELECT
 COUNT(*) FILTER (WHERE invoice_no IS NULL OR BTRIM(invoice_no)='') AS missing_invoice,
 COUNT(*) FILTER (WHERE stock_code IS NULL OR BTRIM(stock_code)='') AS missing_stock_code,
 COUNT(*) FILTER (WHERE invoice_date IS NULL) AS missing_invoice_date,
 COUNT(*) FILTER (WHERE customer_id IS NULL OR BTRIM(customer_id)='') AS missing_customer_id,
 COUNT(*) FILTER (WHERE quantity IS NULL OR quantity<=0) AS nonpositive_quantity,
 COUNT(*) FILTER (WHERE unit_price IS NULL OR unit_price<=0) AS nonpositive_unit_price,
 COUNT(*) FILTER (WHERE UPPER(BTRIM(COALESCE(invoice_no,''))) LIKE 'C%') AS cancellation_invoice_rows
FROM staging.online_retail_raw;

-- Exact duplicates for review; do not delete automatically.
SELECT invoice_no,stock_code,description,quantity,invoice_date,unit_price,customer_id,country,COUNT(*) AS occurrences
FROM staging.online_retail_raw
GROUP BY invoice_no,stock_code,description,quantity,invoice_date,unit_price,customer_id,country
HAVING COUNT(*)>1 ORDER BY occurrences DESC;

SELECT CASE WHEN quantity<0 THEN 'negative quantity' WHEN unit_price<=0 THEN 'nonpositive price' WHEN quantity=0 THEN 'zero quantity' ELSE 'positive sales candidate' END AS pattern,
 COUNT(*) AS rows, SUM(quantity::NUMERIC*unit_price) AS signed_line_value
FROM staging.online_retail_raw GROUP BY 1 ORDER BY rows DESC;
