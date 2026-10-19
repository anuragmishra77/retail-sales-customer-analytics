# Retail Sales & Customer Analytics

End-to-end data analytics portfolio project using PostgreSQL, SQL, Python/Pandas and Power BI, based on the [UCI Online Retail dataset](https://archive.ics.uci.edu/dataset/352/online+retail).

## Business questions
- How does revenue change over time?
- Which products and countries contribute the most revenue?
- How much revenue comes from repeat customers?
- Which customers are high-value or potentially inactive?
- How concentrated is revenue across products and customers?

## Stack
- PostgreSQL: structured storage, data validation and analysis
- SQL: cleaning, KPIs, window functions, RFM and cohorts
- Python/Pandas: source inspection
- Power BI: interactive dashboard (created separately in Power BI Desktop)

## Data limitations
Download `Online Retail.xlsx` from the official UCI source. Do not commit raw data. **Revenue is not profit**: the source does not include product costs. Negative quantities, cancellation invoices, duplicate-looking rows and missing customer IDs require explicit handling. No findings are claimed until calculated from the actual data.

## Quick start
1. Install PostgreSQL 15+, Python 3.10+ and Git.
2. Download the dataset and place `Online Retail.xlsx` in `data/` locally (ignored by Git).
3. Install dependencies: `python -m pip install -r requirements.txt`.
4. Run `python python/inspect_data.py`.
5. Execute SQL files in order; see [setup guide](docs/setup.md).
6. Build the report using the [Power BI plan](powerbi/README.md).

## Attribution
Chen, D. (2015). *Online Retail* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5BW33. Dataset license: CC BY 4.0. Retain attribution.
