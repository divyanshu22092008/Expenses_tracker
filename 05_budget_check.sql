SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE sp_budget_check(p_month VARCHAR2) AS
BEGIN
  DELETE FROM budget_alert WHERE year_month=p_month;
  INSERT INTO budget_alert(category_id,year_month,spend,budget_amt)
  SELECT c.category_id, s.year_month, s.net_spend, s.budget_amt
  FROM v_budget_status s JOIN dim_category c ON c.category_name=s.category_name
  WHERE s.year_month=p_month AND s.flag='BREACH';
  FOR r IN (SELECT * FROM budget_alert WHERE year_month=p_month) LOOP
    DBMS_OUTPUT.PUT_LINE('BREACH cat='||r.category_id||' spend='||r.spend||' budget='||r.budget_amt);
  END LOOP;
  COMMIT;
END;
/
EXEC sp_budget_check('2026-01');
