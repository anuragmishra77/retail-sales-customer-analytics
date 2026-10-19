-- RFM snapshot: recency measured from the day after the last observed sale.
WITH ref AS (SELECT MAX(invoice_date)::DATE+1 AS snapshot_date FROM analytics.v_sales_lines),
rfm AS (
 SELECT customer_id,(SELECT snapshot_date FROM ref)-MAX(invoice_date)::DATE AS recency_days,
 COUNT(DISTINCT invoice_no) AS frequency,SUM(line_revenue) AS monetary
 FROM analytics.v_sales_lines WHERE customer_id IS NOT NULL GROUP BY customer_id
)
SELECT *,NTILE(5) OVER(ORDER BY recency_days DESC) AS recency_score,
 NTILE(5) OVER(ORDER BY frequency) AS frequency_score,NTILE(5) OVER(ORDER BY monetary) AS monetary_score FROM rfm;

-- Cohort retention by first purchase month.
WITH cm AS (SELECT DISTINCT customer_id,DATE_TRUNC('month',invoice_date)::DATE AS activity_month
 FROM analytics.v_sales_lines WHERE customer_id IS NOT NULL),
fm AS (SELECT customer_id,MIN(activity_month) AS cohort_month FROM cm GROUP BY customer_id),
ca AS (
 SELECT f.cohort_month,c.activity_month,
 (EXTRACT(YEAR FROM c.activity_month)-EXTRACT(YEAR FROM f.cohort_month))*12+
 EXTRACT(MONTH FROM c.activity_month)-EXTRACT(MONTH FROM f.cohort_month) AS cohort_age_month,
 COUNT(DISTINCT c.customer_id) AS active_customers
 FROM cm c JOIN fm f USING(customer_id) GROUP BY 1,2,3
), cs AS (SELECT cohort_month,COUNT(*) AS cohort_customers FROM fm GROUP BY 1)
SELECT ca.*,cs.cohort_customers,100.0*active_customers/NULLIF(cohort_customers,0) AS retention_pct
FROM ca JOIN cs USING(cohort_month) ORDER BY ca.cohort_month,ca.cohort_age_month;

WITH p AS (SELECT DATE_TRUNC('month',invoice_date)::DATE AS month,SUM(line_revenue) AS revenue
 FROM analytics.v_sales_lines GROUP BY 1)
SELECT month,revenue,SUM(revenue) OVER(ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM p ORDER BY month;
