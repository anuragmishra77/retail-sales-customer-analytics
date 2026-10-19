# Dataset

## Source

Use the original **Online Retail** workbook from the UCI Machine Learning Repository:

- Official page: https://archive.ics.uci.edu/dataset/352/online-retail
- File: `Online Retail.xlsx`
- Published dataset size: 541,909 rows; transactions span 1 December 2010 through 9 December 2011.
- Citation: Chen, D. (2015). *Online Retail* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5BW33.
- License: CC BY 4.0. Preserve attribution if you reuse or adapt the dataset.

## Put the raw file here

Download the workbook from the official page and save it as:

```text
data/Online Retail.xlsx
```

Keep this original workbook unchanged. It is excluded from Git because it is a large source file; do not upload the raw workbook to this repository.

## Run the first data-quality profile

From the repository root:

```bash
python -m pip install -r requirements.txt
python python/inspect_data.py
```

The script does not clean or overwrite the source workbook. It reports missing values, duplicate rows, cancellation invoices, negative/zero quantities and prices, date range, distinct identifiers, and country counts. It writes generated files to `reports/`:

- `initial_data_profile.json`
- `missing_values.csv`
- `column_types.csv`

Do not write business findings into the project until you have run this against the downloaded workbook and reviewed the generated report. Cancellation rows, negative quantities, and duplicates are flagged for investigation, not automatically deleted.
