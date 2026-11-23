# Personal Expense Tracker & Budget Dashboard
Python cleaning + categorisation -> Oracle star schema + PL/SQL budget check -> Power BI dashboard.

## Run order (from repo root)
1. `pip install pandas numpy` then `python python/clean_expenses.py` (creates data/*.csv, prints reconciliation)
2. Oracle: run `sql/01_ddl.sql`; `sqlldr user/pass control=sql/02_load.ctl skip=1`; then `03_populate.sql`, `04_views.sql`, `05_budget_check.sql`
3. Power BI: follow `powerbi/BUILD_STEPS.md` and save `ExpenseDashboard.pbix`

## Edge cases
- Uncategorised: mapped to "Uncategorised", tracked as a KPI.
- Refunds: stored as negative amounts, netted into spend.
- Month-end: timestamps normalised to date so 23:59 rows stay in the right month; reconciliation proves totals.

See docs/schema.md (ER diagram + KPIs), docs/insights.md, data/data_quality_report.csv.
