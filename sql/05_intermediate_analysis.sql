WITH order_totals AS (SELECT invoice_no,SUM(line_revenue) AS order_revenue FROM analytics.v_sales_lines GROUP BY invoice_no)
SELECT AVG(order_revenue) AS average_order_value,COUNT(*) AS orders FROM order_totals;

WITH monthly AS (
 SELECT DATE_TRUNC('month',invoice_date)::DATE AS month,SUM(line_revenue) AS revenue
 FROM analytics.v_sales_lines GROUP BY 1
), lagged AS (
 SELECT month,revenue,LAG(revenue) OVER(ORDER BY month) AS previous_month_revenue FROM monthly
)
SELECT month,revenue,previous_month_revenue,
 100.0*(revenue-previous_month_revenue)/NULLIF(previous_month_revenue,0) AS mom_growth_pct
FROM lagged ORDER BY month;

SELECT customer_id,SUM(line_revenue) AS lifetime_revenue,COUNT(DISTINCT invoice_no) AS orders,
 MAX(invoice_date) AS most_recent_order
FROM analytics.v_sales_lines WHERE customer_id IS NOT NULL
GROUP BY customer_id ORDER BY lifetime_revenue DESC LIMIT 10;

WITH c AS (SELECT customer_id,COUNT(DISTINCT invoice_no) AS n_orders FROM analytics.v_sales_lines
 WHERE customer_id IS NOT NULL GROUP BY customer_id)
SELECT COUNT(*) FILTER(WHERE n_orders>=2) AS repeat_customers,COUNT(*) AS identified_customers,
 100.0*COUNT(*) FILTER(WHERE n_orders>=2)/NULLIF(COUNT(*),0) AS repeat_customer_rate_pct FROM c;
