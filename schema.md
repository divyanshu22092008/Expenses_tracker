# Star schema
```mermaid
erDiagram
  dim_date ||--o{ fact_expense : date_id
  dim_category ||--o{ fact_expense : category_id
  dim_category ||--o{ budget : category_id
  fact_expense { number expense_id PK
    number date_id FK
    number category_id FK
    string merchant
    number amount
    string txn_type }
  dim_date { number date_id PK
    date full_date
    string year_month
    char is_month_end }
  dim_category { number category_id PK
    string category_name }
  budget { number category_id FK
    string year_month
    number budget_amt }
  budget_alert { number category_id
    string year_month
    number spend
    number budget_amt
    timestamp alert_ts }
```
Amount is signed: refunds are negative.

# KPIs
| KPI | Definition |
|---|---|
| Net Spend | SUM(purchases) - SUM(refunds) |
| Budget Utilisation % | Net Spend / monthly category budget |
| Breach Flag | Utilisation > 100% |
| MoM Change % | (This month - last month) / last month |
| Uncategorised % | Uncategorised rows / all rows |
