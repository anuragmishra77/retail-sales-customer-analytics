# Power BI dashboard plan

Create the PBIX in Power BI Desktop after SQL data checks pass.

## Page 1 — Executive overview
KPI cards: Revenue, Orders, Identified Customers, Units Sold; monthly revenue line chart; country and top-product bar charts; date/country slicers.

## Page 2 — Product performance
Product revenue, units sold, monthly product trend and Pareto contribution. Do not show profit without validated cost data.

## Page 3 — Customer analytics
Top identified customers, RFM distribution, repeat-customer rate and cohort retention. State that customer KPIs exclude missing CustomerID.

## Page 4 — Geographic analysis
Revenue, orders, average order value and monthly trends by country.

Use validated SQL views, a calendar table and clear relationships. Reconcile Power BI totals with PostgreSQL before publishing. A PBIX is not created by these documentation files; it must be built in Power BI Desktop.
