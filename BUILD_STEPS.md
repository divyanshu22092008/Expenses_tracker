# Power BI build (create ExpenseDashboard.pbix from these steps)
1. Get Data > Oracle Database. Import fact_expense, dim_date, dim_category, budget, v_budget_status.
   (No Oracle? Import data/expenses_clean.csv instead.)
2. Model view: fact_expense[date_id]->dim_date, fact_expense[category_id]->dim_category,
   budget[category_id]->dim_category. Mark dim_date[full_date] as the date table.
3. Measures:
```DAX
Net Spend = SUM(fact_expense[amount])
Budget = SUM(budget[budget_amt])
Utilisation % = DIVIDE([Net Spend],[Budget])
Breach = IF([Utilisation %]>1,"BREACH","OK")
Breach Count = COUNTROWS(FILTER(v_budget_status, v_budget_status[flag]="BREACH"))
MoM % = VAR p=CALCULATE([Net Spend],DATEADD(dim_date[full_date],-1,MONTH)) RETURN DIVIDE([Net Spend]-p,p)
```
4. Visuals: donut (category_name by Net Spend); line (year_month vs Net Spend);
   cards (Net Spend, Utilisation %, Breach Count); table with red conditional format on Breach.
5. Slicers: year_month, category_name, txn_type. Drill-down hierarchies: Year>Month>Date and Category>Merchant.
6. Save as powerbi/ExpenseDashboard.pbix.
