-- sqlldr user/pass control=sql/02_load.ctl skip=1
LOAD DATA INFILE 'data/expenses_clean.csv' APPEND INTO TABLE stg_expense
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' TRAILING NULLCOLS
(expense_id, txn_date DATE "YYYY-MM-DD", merchant, amount, txn_type, year_month, category)
