-- Revenue under the documented positive-sales definition.
SELECT SUM(line_revenue) AS sales_revenue FROM analytics.v_sales_lines;

SELECT COUNT(DISTINCT invoice_no) AS orders, COUNT(DISTINCT customer_id) AS identified_customers,
 SUM(quantity) AS units_sold FROM analytics.v_sales_lines;

SELECT DATE_TRUNC('month',invoice_date)::DATE AS month,SUM(line_revenue) AS revenue
FROM analytics.v_sales_lines GROUP BY 1 ORDER BY 1;

SELECT stock_code,MAX(description) AS product_description,SUM(line_revenue) AS revenue,SUM(quantity) AS units_sold
FROM analytics.v_sales_lines GROUP BY stock_code ORDER BY revenue DESC LIMIT 10;

SELECT country,SUM(line_revenue) AS revenue,COUNT(DISTINCT invoice_no) AS orders
FROM analytics.v_sales_lines GROUP BY country ORDER BY revenue DESC;
