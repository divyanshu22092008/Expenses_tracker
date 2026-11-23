CREATE OR REPLACE VIEW v_monthly_spend AS
SELECT d.year_month, c.category_name, SUM(f.amount) net_spend,
       SUM(CASE WHEN f.txn_type='REFUND' THEN -f.amount END) refunds
FROM fact_expense f JOIN dim_date d ON d.date_id=f.date_id JOIN dim_category c ON c.category_id=f.category_id
GROUP BY d.year_month, c.category_name;

CREATE OR REPLACE VIEW v_budget_status AS
SELECT v.year_month, v.category_name, v.net_spend, b.budget_amt,
       ROUND(v.net_spend/b.budget_amt*100,1) util_pct,
       CASE WHEN v.net_spend>b.budget_amt THEN 'BREACH' ELSE 'OK' END flag
FROM v_monthly_spend v JOIN dim_category c ON c.category_name=v.category_name
JOIN budget b ON b.category_id=c.category_id AND b.year_month=v.year_month;

-- reconciliation: compare with data/reconciliation.csv
SELECT year_month, SUM(net_spend) FROM v_monthly_spend GROUP BY year_month ORDER BY 1;
