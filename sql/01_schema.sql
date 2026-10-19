CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS staging.online_retail_raw (
 source_row_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 invoice_no TEXT, stock_code TEXT, description TEXT, quantity INTEGER,
 invoice_date TIMESTAMP, unit_price NUMERIC(12,4), customer_id TEXT, country TEXT
);
CREATE TABLE IF NOT EXISTS analytics.customers (customer_id TEXT PRIMARY KEY);
CREATE TABLE IF NOT EXISTS analytics.products (stock_code TEXT PRIMARY KEY, description TEXT);
CREATE TABLE IF NOT EXISTS analytics.orders (
 invoice_no TEXT PRIMARY KEY, invoice_date TIMESTAMP, customer_id TEXT, country TEXT
);
CREATE TABLE IF NOT EXISTS analytics.order_items (
 order_item_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 invoice_no TEXT NOT NULL REFERENCES analytics.orders(invoice_no),
 stock_code TEXT, description TEXT, quantity INTEGER NOT NULL, unit_price NUMERIC(12,4) NOT NULL,
 line_revenue NUMERIC(14,4) GENERATED ALWAYS AS (quantity * unit_price) STORED
);
CREATE INDEX IF NOT EXISTS idx_raw_invoice_date ON staging.online_retail_raw(invoice_date);
CREATE INDEX IF NOT EXISTS idx_raw_customer_id ON staging.online_retail_raw(customer_id);
CREATE INDEX IF NOT EXISTS idx_raw_stock_code ON staging.online_retail_raw(stock_code);
