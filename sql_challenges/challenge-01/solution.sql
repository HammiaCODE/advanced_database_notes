-- Lesson 04: Setup
-- Create a simple accounts table for the transfer demo

DROP TABLE accounts PURGE;

CREATE TABLE accounts (
    account_id   NUMBER PRIMARY KEY,
    owner_name   VARCHAR2(50) NOT NULL,
    balance      NUMBER(10,2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO accounts VALUES (1, 'Alice',  1000.00);
INSERT INTO accounts VALUES (2, 'Bob',     500.00);
INSERT INTO accounts VALUES (3, 'Charlie', 250.00);
COMMIT;

-- Verify starting state
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
-- Expected: Alice=1000, Bob=500, Charlie=250

-- Lesson 04: Class Exercises
-- Students: work through these in order. Don't skip the verify steps.

-- ============================================================
-- EXERCISE 1: Manual transaction (warm-up)
-- ============================================================
-- Before: verify balances. After COMMIT: verify again.
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;

-- Transfer $50 from Charlie (3) to Alice (1) using BEGIN / COMMIT manually.
UPDATE accounts SET balance = balance - 50 WHERE account_id = 3;
UPDATE accounts SET balance = balance + 50 WHERE account_id = 1;

-- Verify before committing (only visible in this session)
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
-- Alice: 1050, Charlie: 200
-- Make it permanent
COMMIT;

-- Now everyone can see it
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;

-- ============================================================
-- EXERCISE 2: Catch yourself with ROLLBACK
-- ============================================================
-- Use ROLLBACK to undo. Verify balances restored.

-- Your SQL here:
-- Start a transfer of $10,000 from Bob (2) to Charlie (3).
UPDATE accounts SET balance = balance - 10,000 WHERE account_id = 2;
UPDATE accounts SET balance = balance + 10,000 WHERE account_id = 3;

-- Before committing, check the balances. Does Bob have enough?
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
-- Bob: 500, Charlie: 10,200

-- Undo it — ROLLBACK takes us back to the last COMMIT
ROLLBACK;

SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
-- Alice: 1050, Bob: 500, Charlie: 200 — back to post-COMMIT state
 

-- ============================================================
-- EXERCISE 3: SAVEPOINT checkpoint
-- ============================================================
-- Your SQL here:
-- 1. Add $25 to Alice's balance
UPDATE accounts SET balance = balance + 25 WHERE account_id = 1;
-- 2. Set a savepoint
SAVEPOINT after_alice;
-- 3. Deduct $25 from Charlie's balance (wrong account — you meant Bob)
UPDATE accounts SET balance = balance - 25 WHERE account_id = 3;  
-- 4. Rollback to savepoint
ROLLBACK TO SAVEPOINT after_alice;
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;

-- 5. Deduct $25 from Bob's balance instead
UPDATE accounts SET balance = balance - 25 WHERE account_id = 2;  

-- 6. Commit
SELECT account_id, owner_name, balance FROM accounts ORDER BY account_id;
COMMIT;
 

-- ============================================================
-- EXERCISE 4: Write your own stored procedure
-- ============================================================
-- Create a procedure called deposit_funds(p_account_id, p_amount)
-- It should:
-- 1. Validate that p_amount > 0 (raise error if not)
-- 2. Add p_amount to the account balance
-- 3. COMMIT on success
-- 4. ROLLBACK + re-raise on any error
-- Test it with: EXEC deposit_funds(3, 75);

-- Your SQL here:
-- ============================================================
-- PART 1: Create the stored procedure
-- ============================================================

CREATE OR REPLACE PROCEDURE deposit_funds(
    p_to_account    IN  NUMBER,
    p_amount        IN  NUMBER
) AS
    v_from_value  NUMBER;
BEGIN
    -- Check sufficient funds before doing anything
    SELECT val INTO v_from_value
    FROM accounts
    WHERE account_id = p_to_account;

    IF p_amount > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'You cant deposit zeros' || p_to_account);
    END IF;

    -- Perform the transfer
    UPDATE accounts SET val = val + p_amount WHERE account_id = p_to_account;

    -- Commit only if both succeed
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Deposit complete: $' || p_amount ||
                         ' to account ' || p_to_account);
EXCEPTION
    WHEN OTHERS THEN
        -- Something went wrong — undo everything
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Deposit failed. All changes rolled back.');
        RAISE;  -- re-raise the error so the caller knows it failed
END;
/

-- ============================================================
-- PART 2: Call the procedure
-- ============================================================

-- Check starting state
SELECT account_id, owner_name, val FROM accounts ORDER BY account_id;

-- Depositing $75 to Charlie (35)
SET SERVEROUTPUT ON;
EXEC deposit_funds(3, 75);

-- Verify
SELECT account_id, owner_name, val FROM accounts ORDER BY account_id;
 

-- ============================================================
-- EXERCISE 5: Discussion
-- ============================================================
-- Answer these in words (no SQL needed):

-- Q1: You're building a patient appointment booking system.
-- A booking requires:
--   a) Reserve the time slot
--   b) Create the appointment record
--   c) Send a confirmation notification
-- Which of these should be inside the transaction? Which should be outside? Why?
-- (A) and (B) should be inside while (C) should be outside. (A) and (B) need to be inside because those are the ones doing the actions and (C) should be outside to confirm that the operation was successful


-- Q2: Your stored procedure calls COMMIT at the end.
-- A developer calls your procedure from inside their own larger transaction.
-- What problem does this create?
-- If they need to rollback it might cause problems

-- Q3: You have a function called calculate_copay() and a procedure called post_payment().
-- A colleague wants to use calculate_copay() inside a SELECT statement.
-- Can they? Can they do the same with post_payment()? Why or why not?
-- You can't directly call a stored procedure from inside a SELECT statement, the only things that can be called from a SELECT statement are functions and views
-- One can convert the stored proccedure into any of the latter to use it.
 