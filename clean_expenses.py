"""Run from repo root: python python/clean_expenses.py"""
import pandas as pd, numpy as np, random, os
random.seed(1); np.random.seed(1)
os.makedirs("data", exist_ok=True)

merch = {"Swiggy":"Food","Zomato":"Food","BigBazaar":"Groceries","Uber":"Transport",
         "IRCTC":"Transport","Netflix":"Entertainment","Airtel":"Bills","Amazon":"Shopping",
         "Apollo":"Health","UnknownShop":None}
rows=[]
for d in pd.date_range("2026-01-01","2026-03-31"):
    for _ in range(np.random.randint(1,4)):
        m=random.choice(list(merch)); rows.append([d,m,round(np.random.uniform(50,3000),2),"PURCHASE"])
for d in ["2026-01-31","2026-02-28","2026-03-31"]:   # month-end boundary rows
    rows.append([pd.Timestamp(d)+pd.Timedelta(hours=23,minutes=59),"Amazon",999.0,"PURCHASE"])
for i in random.sample(range(len(rows)),8):           # refunds
    r=rows[i].copy(); r[3]="REFUND"; rows.append(r)
raw=pd.DataFrame(rows,columns=["txn_date","merchant","amount","txn_type"])
raw.to_csv("data/expenses_raw.csv",index=False)

# clean
df=pd.read_csv("data/expenses_raw.csv",parse_dates=["txn_date"]).drop_duplicates()
df["merchant"]=df.merchant.str.strip().str.title()
df["amount"]=np.where(df.txn_type=="REFUND",-df.amount.abs(),df.amount.abs())
df["txn_date"]=df.txn_date.dt.normalize()
df["year_month"]=df.txn_date.dt.strftime("%Y-%m")
cmap={k.title():v for k,v in merch.items()}
df["category"]=df.merchant.map(cmap).fillna("Uncategorised")
df.insert(0,"expense_id",range(1,len(df)+1))
df.to_csv("data/expenses_clean.csv",index=False)

# reconcile
src=raw.assign(a=np.where(raw.txn_type=="REFUND",-raw.amount,raw.amount),
               ym=pd.to_datetime(raw.txn_date).dt.strftime("%Y-%m")).drop_duplicates()
chk=pd.DataFrame({"source":src.groupby("ym").a.sum().round(2),
                  "clean":df.groupby("year_month").amount.sum().round(2)})
chk["match"]=chk.source==chk.clean
chk.to_csv("data/reconciliation.csv"); print(chk)

# data-quality report
dq={"rows":len(df),"uncategorised_pct":round((df.category=="Uncategorised").mean()*100,1),
    "refund_rows":int((df.txn_type=="REFUND").sum()),"null_amounts":int(df.amount.isna().sum()),
    "month_end_rows":int(df.txn_date.dt.is_month_end.sum())}
pd.Series(dq).to_csv("data/data_quality_report.csv",header=["value"]); print(dq)

# insights inputs
g=df[df.txn_type=="PURCHASE"].amount.sum()
print("refund % of gross:",round(-df[df.txn_type=="REFUND"].amount.sum()/g*100,2))
print(df.groupby(["year_month","category"]).amount.sum().round(2).unstack(0))
