-- ============================================================

-- Drop tables if they exist (clean start)
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS team;

-- ============================================================
-- TEAMS
-- ============================================================
CREATE TABLE teams (
    id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR2(50)  NOT NULL UNIQUE,
    description VARCHAR2(200),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- USERS
-- ============================================================
CREATE TABLE users (
    id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username    VARCHAR2(50)  NOT NULL UNIQUE,
    email       VARCHAR2(100) NOT NULL,
    full_name   VARCHAR2(100),
    team_id     NUMBER,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_team
        FOREIGN KEY (team_id) REFERENCES teams(id)
);

-- ============================================================
-- TASKS
-- ============================================================
CREATE TABLE tasks (
    id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title        VARCHAR2(200) NOT NULL,
    description  VARCHAR2(1000),
    status       VARCHAR2(20)  DEFAULT 'open',
    assigned_to  NUMBER,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP,
    CONSTRAINT fk_tasks_user
        FOREIGN KEY (assigned_to) REFERENCES users(id)
);

-- ============================================================
-- SEED DATA
-- ============================================================

-- Teams
INSERT INTO teams (name, description) VALUES ('Engineering', 'Software development team');
INSERT INTO teams (name, description) VALUES ('Product', 'Product management team');

-- Users
INSERT INTO users (username, email, full_name, team_id)
    VALUES ('alice_dev', 'alice@example.com', 'Alice Smith', 1);
INSERT INTO users (username, email, full_name, team_id)
    VALUES ('bob_dev', 'bob@example.com', 'Bob Jones', 1);
INSERT INTO users (username, email, full_name, team_id)
    VALUES ('carol_pm', 'carol@example.com', 'Carol White', 2);

-- Tasks
INSERT INTO tasks (title, description, status, assigned_to)
    VALUES ('Fix login bug', 'Users cannot log in with SSO', 'open', 1);
INSERT INTO tasks (title, description, status, assigned_to)
    VALUES ('Design new dashboard', 'Create mockups for analytics page', 'in_progress', 3);
INSERT INTO tasks (title, description, status, assigned_to)
    VALUES ('Update dependencies', 'Upgrade numpy and pandas', 'open', 2);

COMMIT;

-- ============================================================
-- VERIFY
-- ============================================================
SELECT 'Teams:' AS section, name FROM teams
UNION ALL
SELECT 'Users:' AS section, username FROM users
UNION ALL
SELECT 'Tasks:' AS section, title FROM tasks;

-----

DELETE FROM LOGS
WHERE
        LOG_ID = :LOG_ID
    AND TABLE_TYPE = :TABLE_TYPE
    AND ROW_ID = :ROW_ID
    AND RECORDED_ACTION = :RECORDED_ACTION
    AND FIELD_NAME = :FIELD_NAME
    AND OLD_VALUE = :OLD_VALUE
    AND NEW_VALUE = :NEW_VALUE
    AND CHANGED_AT = :CHANGED_AT
    AND CHANGED_BY_USER_ID = :CHANGED_BY_USER_ID;

DELETE FROM LOGS
WHERE
        LOG_ID = :LOG_ID
    AND TABLE_TYPE = :TABLE_TYPE
    AND ROW_ID = :ROW_ID
    AND RECORDED_ACTION = :RECORDED_ACTION
    AND FIELD_NAME = :FIELD_NAME
    AND OLD_VALUE = :OLD_VALUE
    AND NEW_VALUE = :NEW_VALUE
    AND CHANGED_AT = :CHANGED_AT
    AND CHANGED_BY_USER_ID = :CHANGED_BY_USER_ID;


-- Questions
--1. What relationships should `Comment` have?
-- Comment needs to be related to the Task and Users tables because the comments are left on tasks by the users
--2. Should `Task` have a `comments` relationship?
-- No because while every comment is related to a task not all tasks have a comment
--3. What should happen to comments when a task is deleted?
-- It should be deleted too

--Questions
--1. What does `upgrade()` do?
-- It upgrades to the number of version given
--2. What does `downgrade()` do?
-- It downgrades to the number of version given
--3. What happens if you downgrade this migration?
-- It deletes the comment table

--Exercise 3 Printouts
--Task count: 3
--Task "Setup CI/CD pipeline" closed.
--Deleting task: "Write deployment docs"
--Task deleted successfully.

--Remaining tasks:
--- Setup CI/CD pipeline | priority=1 | status=closed
--- Configure monitoring | priority=2 | status=open

--Exercise 4 Printouts--
--Rollback ejecutado correctamente.

--## Questions
--1. What happens to the column?
-- It's deleted
--2. What happens to the data?
-- Also deleted

--# Exercise 5 — Concept Check (5 min)

--Answer briefly:
--1. Why use ORM instead of raw SQL?
-- ORM lets you make changes automatically and also it lets you revert or upgrade the schema
--2. Why use migrations?
-- Because migrations create a history which allows you to upgrade or downgrade to other versions if necessary
--3. When would you rollback?
-- In case you made an error in the information or if something is broken in the schema
--4. Difference between `add()` and `commit()`?
-- Add() just adds the changes, while commit() is a more permanent change
--5. Why are relationships useful?
-- To connect tables and their foreign keys