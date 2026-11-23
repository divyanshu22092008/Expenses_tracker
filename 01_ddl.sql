CREATE TABLE dim_category(category_id NUMBER PRIMARY KEY, category_name VARCHAR2(40) UNIQUE);
CREATE TABLE dim_date(date_id NUMBER PRIMARY KEY, full_date DATE UNIQUE, year_month VARCHAR2(7), is_month_end CHAR(1));
CREATE TABLE budget(category_id NUMBER REFERENCES dim_category, year_month VARCHAR2(7),
  budget_amt NUMBER(12,2), PRIMARY KEY(category_id, year_month));
CREATE TABLE stg_expense(expense_id NUMBER, txn_date DATE, merchant VARCHAR2(60), amount NUMBER(12,2),
  txn_type VARCHAR2(10), year_month VARCHAR2(7), category VARCHAR2(40));
CREATE TABLE fact_expense(expense_id NUMBER PRIMARY KEY, date_id NUMBER REFERENCES dim_date,
  category_id NUMBER REFERENCES dim_category, merchant VARCHAR2(60), amount NUMBER(12,2), txn_type VARCHAR2(10));
CREATE TABLE budget_alert(category_id NUMBER, year_month VARCHAR2(7), spend NUMBER(12,2),
  budget_amt NUMBER(12,2), alert_ts TIMESTAMP DEFAULT SYSTIMESTAMP);
