-- EXERCISE 2
CREATE INDEX site_2 ON patient_visits(visit_date);

-- a) No it still uses table access full 
-- b) It changes the amount of rows it reads but otherwise it doesn't change much. It still does a table access full after the filter.
-- c) It checks more rows of course, but otherwise it has the same structure as the of the last question.
-- d) If the range is too big of course it's easier to just do a full table access. 

-- EXERCISE 3
CREATE INDEX idx_pv_patient_date ON patient_visits(patient_id, visit_date);

BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'PATIENT_VISITS', cascade => TRUE);
END;
/

EXPLAIN PLAN FOR
SELECT * FROM patient_visits
WHERE patient_id = 1234
  AND visit_date > SYSDATE - 90;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Questions:
-- a) Yes, it uses the idx_pv_patient_date in |*2|
-- b) When only doing a query for the date it does a table access full
--    Because the composite index is supposed to take in patient_id and visit_id values, it applies the leftmost prefix rule
-- c) The Leftmost Prefix rule states that the query will only work if the leftmost column is included

-- EXERCISE 4

-- This query CAN use the index:
EXPLAIN PLAN FOR
SELECT * FROM patient_visits WHERE patient_id = 5432;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- This one cannot — why?
EXPLAIN PLAN FOR
SELECT * FROM patient_visits WHERE TO_CHAR(patient_id) = '5432';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Questions:
-- a) Table Acess Full
-- b) The index is for int values, not char so it reads it differently
-- c) Remove the To_Char or make an index for to_char values


-- Exercise 5 — Discussion: real-world scenarios
--
-- For each scenario below, decide:
--   a) Would you add an index?
--   b) On which column(s)?
--   c) Any concerns?
-- ============================================================

-- Scenario A:
-- A reporting table gets loaded once per night (batch ETL).
-- During the day, analysts run SELECT queries by date range.
-- The table has 50 million rows.
-- → Index on date? Yes/No, why?
-- No, because it uses the date range so it isn't necessary as the range already grabs the information necessary


-- Scenario B:
-- An OLTP orders table gets 10,000 inserts per minute.
-- Support staff look up orders by customer_id or order_status.
-- order_status has 4 values: pending, processing, shipped, cancelled.
-- → What indexes would you add?
-- Yes, I would use a composite index with customer_id and order_status

-- Scenario C:
-- A patient table has an email column (unique per patient).
-- There are 5 million patients.
-- The app frequently does: WHERE email = 'user@example.com'
-- → What kind of index would be best here?
-- Yes, a single column index with the email column because its the one being accessed the most