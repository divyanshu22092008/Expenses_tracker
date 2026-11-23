INSERT INTO dim_category SELECT ROWNUM, category FROM (SELECT DISTINCT category FROM stg_expense);
INSERT INTO dim_date SELECT ROWNUM, d, TO_CHAR(d,'YYYY-MM'), CASE WHEN d=LAST_DAY(d) THEN 'Y' ELSE 'N' END
  FROM (SELECT DISTINCT txn_date d FROM stg_expense);
INSERT INTO fact_expense
  SELECT s.expense_id, d.date_id, c.category_id, s.merchant, s.amount, s.txn_type
  FROM stg_expense s JOIN dim_date d ON d.full_date=s.txn_date
                     JOIN dim_category c ON c.category_name=s.category;
-- sample budgets (INR 8000 per category per month)
INSERT INTO budget SELECT c.category_id, m.ym, 8000
  FROM dim_category c CROSS JOIN (SELECT DISTINCT year_month ym FROM dim_date) m
  WHERE c.category_name<>'Uncategorised';
COMMIT;
