-- Add columns needed for KPI analysis
ALTER TABLE tasks ADD (
    priority      VARCHAR2(10)  DEFAULT 'medium',
    due_date      DATE,
    completed_at  TIMESTAMP,
    tags          VARCHAR2(200)
);

-- Add check constraint for valid priorities
ALTER TABLE tasks ADD CONSTRAINT chk_task_priority
    CHECK (priority IN ('low', 'medium', 'high', 'critical'));

-- Add check constraint for valid statuses (expanded)
ALTER TABLE tasks DROP CONSTRAINT chk_task_status;
ALTER TABLE tasks ADD CONSTRAINT chk_task_status
    CHECK (status IN ('open', 'in_progress', 'blocked', 'completed', 'cancelled'));

COMMIT;

-- Verify
SELECT column_name, data_type, nullable
FROM   user_tab_columns
WHERE  table_name = 'TASKS'
ORDER  BY column_id;

DELETE FROM tasks;
COMMIT;

-- ============================================================
-- 36 REALISTIC TASKS
-- ============================================================
-- Spread across 14 days with varied statuses, priorities, assignees
-- Includes cancelled tasks and overdue tasks for exercise coverage

INSERT INTO tasks (title, description, status, priority, assigned_to, created_at, due_date, completed_at, tags) VALUES
('Fix login bug', 'Users cannot log in with SSO after password reset', 'completed', 'high', 1, TIMESTAMP '2026-05-01 09:00:00', DATE '2026-05-03', TIMESTAMP '2026-05-02 14:30:00', 'bug,sso,auth'),
('Design new dashboard', 'Create mockups for analytics page with KPI cards', 'in_progress', 'medium', 3, TIMESTAMP '2026-05-01 10:00:00', DATE '2026-05-10', NULL, 'design,ui,dashboard'),
('Update dependencies', 'Upgrade numpy and pandas to latest stable', 'completed', 'low', 2, TIMESTAMP '2026-05-01 11:00:00', DATE '2026-05-05', TIMESTAMP '2026-05-04 16:00:00', 'maintenance,deps'),
('API rate limiting', 'Implement rate limiting on public endpoints', 'open', 'high', 1, TIMESTAMP '2026-05-02 09:00:00', DATE '2026-05-08', NULL, 'api,security,backend'),
('Write unit tests for auth', 'Cover login, logout, token refresh flows', 'in_progress', 'medium', 2, TIMESTAMP '2026-05-02 10:00:00', DATE '2026-05-09', NULL, 'testing,auth,qa'),
('Database backup script', 'Automate daily backup to S3 with retention', 'completed', 'medium', 1, TIMESTAMP '2026-05-02 11:00:00', DATE '2026-05-04', TIMESTAMP '2026-05-03 10:00:00', 'devops,backup,s3'),
('Mobile responsive nav', 'Menu does not collapse on screens < 768px', 'blocked', 'high', 3, TIMESTAMP '2026-05-03 09:00:00', DATE '2026-05-07', NULL, 'bug,mobile,ui,css'),
('User profile page', 'Allow users to edit avatar and bio', 'open', 'low', 3, TIMESTAMP '2026-05-03 10:00:00', DATE '2026-05-15', NULL, 'feature,profile,frontend'),
('Optimize slow query', 'Report generation takes 45 seconds', 'completed', 'critical', 1, TIMESTAMP '2026-05-03 11:00:00', DATE '2026-05-04', TIMESTAMP '2026-05-03 18:00:00', 'performance,sql,optimization'),
('Set up CI/CD pipeline', 'GitHub Actions for test + deploy', 'in_progress', 'medium', 2, TIMESTAMP '2026-05-04 09:00:00', DATE '2026-05-12', NULL, 'devops,cicd,github'),
('Error tracking integration', 'Connect Sentry for production error alerts', 'open', 'medium', 1, TIMESTAMP '2026-05-04 10:00:00', DATE '2026-05-11', NULL, 'monitoring,sentry,ops'),
('Dark mode toggle', 'Add theme switcher with CSS variables', 'completed', 'low', 3, TIMESTAMP '2026-05-04 11:00:00', DATE '2026-05-06', TIMESTAMP '2026-05-05 15:00:00', 'feature,ui,theming'),
('Password strength meter', 'Visual indicator for password complexity', 'open', 'low', 2, TIMESTAMP '2026-05-05 09:00:00', DATE '2026-05-14', NULL, 'feature,auth,frontend'),
('Export to CSV', 'Allow users to download report as CSV', 'in_progress', 'medium', 3, TIMESTAMP '2026-05-05 10:00:00', DATE '2026-05-13', NULL, 'feature,export,reporting'),
('Redis caching layer', 'Cache frequent queries to reduce DB load', 'open', 'high', 1, TIMESTAMP '2026-05-05 11:00:00', DATE '2026-05-10', NULL, 'backend,redis,performance'),
('Email notification service', 'Send task assignment emails via SendGrid', 'completed', 'medium', 2, TIMESTAMP '2026-05-06 09:00:00', DATE '2026-05-08', TIMESTAMP '2026-05-07 12:00:00', 'feature,email,notifications'),
('Audit log table', 'Track all changes to tasks with timestamps', 'in_progress', 'medium', 1, TIMESTAMP '2026-05-06 10:00:00', DATE '2026-05-15', NULL, 'feature,audit,logging'),
('Two-factor auth', 'Add TOTP support for admin accounts', 'open', 'critical', 2, TIMESTAMP '2026-05-06 11:00:00', DATE '2026-05-09', NULL, 'feature,security,auth'),
('Load testing script', 'Simulate 1000 concurrent users with k6', 'completed', 'medium', 1, TIMESTAMP '2026-05-07 09:00:00', DATE '2026-05-08', TIMESTAMP '2026-05-07 17:00:00', 'testing,performance,k6'),
('Documentation site', 'Set up MkDocs for API documentation', 'open', 'low', 3, TIMESTAMP '2026-05-07 10:00:00', DATE '2026-05-20', NULL, 'docs,mkdocs,technical-writing'),
('Fix memory leak', 'Node process grows to 2GB after 24 hours', 'blocked', 'critical', 1, TIMESTAMP '2026-05-07 11:00:00', DATE '2026-05-09', NULL, 'bug,performance,memory'),
('Webhook integrations', 'Allow third-party services to subscribe to events', 'open', 'medium', 2, TIMESTAMP '2026-05-08 09:00:00', DATE '2026-05-16', NULL, 'feature,api,integrations'),
('Search autocomplete', 'Typeahead search with debounced API calls', 'in_progress', 'low', 3, TIMESTAMP '2026-05-08 10:00:00', DATE '2026-05-14', NULL, 'feature,search,frontend'),
('GDPR data export', 'Allow users to download all their data', 'open', 'high', 1, TIMESTAMP '2026-05-08 11:00:00', DATE '2026-05-12', NULL, 'compliance,gdpr,privacy'),
('Slack bot integration', 'Post task updates to team Slack channel', 'completed', 'low', 2, TIMESTAMP '2026-05-09 09:00:00', DATE '2026-05-11', TIMESTAMP '2026-05-10 11:00:00', 'feature,slack,bot'),
('Database migration tool', 'Evaluate Flyway vs Liquibase for schema changes', 'open', 'medium', 1, TIMESTAMP '2026-05-09 10:00:00', DATE '2026-05-17', NULL, 'research,db,migrations'),
('Image upload resizing', 'Resize avatars to 256x256 on upload', 'in_progress', 'low', 3, TIMESTAMP '2026-05-09 11:00:00', DATE '2026-05-13', NULL, 'feature,images,processing'),
('Session timeout bug', 'Users stay logged in after 30 days', 'open', 'high', 2, TIMESTAMP '2026-05-10 09:00:00', DATE '2026-05-11', NULL, 'bug,auth,sessions'),
('Analytics event tracking', 'Track page views and clicks with Mixpanel', 'completed', 'medium', 3, TIMESTAMP '2026-05-10 10:00:00', DATE '2026-05-12', TIMESTAMP '2026-05-11 09:00:00', 'feature,analytics,tracking'),
('Kubernetes deployment', 'Migrate from EC2 to EKS with Helm charts', 'open', 'critical', 1, TIMESTAMP '2026-05-10 11:00:00', DATE '2026-05-15', NULL, 'devops,k8s,infrastructure');

-- ============================================================
-- ADDITIONAL TASKS FOR EXERCISE COVERAGE
-- ============================================================
-- Cancelled tasks (for completion_rate calculation in EXERCISE 3)
INSERT INTO tasks (title, description, status, priority, assigned_to, created_at, due_date, completed_at, tags) VALUES ('Legacy API deprecation', 'Sunset the v1 API endpoints', 'cancelled', 'low', 2, TIMESTAMP '2026-05-01 08:00:00', DATE '2026-05-20', NULL, 'api,deprecation,legacy'),
('Manual data migration', 'One-time script to migrate old records', 'cancelled', 'medium', 1, TIMESTAMP '2026-05-02 08:00:00', DATE '2026-05-10', NULL, 'migration,data,one-time'),
('Third-party auth provider', 'Integrate with Okta for enterprise SSO', 'cancelled', 'high', 3, TIMESTAMP '2026-05-03 08:00:00', DATE '2026-05-18', NULL, 'auth,sso,enterprise'),

-- Overdue tasks (for EXERCISE 5 — overdue report with severity)
('Security audit remediation', 'Fix findings from Q1 penetration test', 'open', 'critical', 1, TIMESTAMP '2026-05-01 09:00:00', DATE '2026-05-05', NULL, 'security,audit,compliance'),
('Customer data retention policy', 'Implement automatic data purging', 'in_progress', 'high', 2, TIMESTAMP '2026-05-02 09:00:00', DATE '2026-05-06', NULL, 'compliance,gdpr,data'),
('Payment gateway integration', 'Add Stripe support for subscriptions', 'blocked', 'medium', 3, TIMESTAMP '2026-05-03 09:00:00', DATE '2026-05-07', NULL, 'payments,stripe,billing'),
('Performance regression fix', 'Query latency spike after last deploy', 'open', 'critical', 1, TIMESTAMP '2026-05-04 09:00:00', DATE '2026-05-08', NULL, 'performance,regression,sql');

COMMIT;

-- Verify counts
SELECT status, COUNT(*) AS task_count
FROM   tasks
GROUP  BY status
ORDER  BY task_count DESC;

-- ============================================================
-- EXERCISE 1: Define "Team Velocity"
-- ============================================================
--
-- Business context: Management wants to compare how fast each team
-- completes work. They ask for "team velocity."
--
-- YOUR TASK:
-- 1. Define the KPI contract in comments. What EXACTLY does "velocity" mean?
--    Is it tasks completed per day? Per person? Per story point?
--    (We do not have story points — how does that change the definition?)
        -- The velocity would be how much time elapses between task created and task completed, and check what team each user assigned belongs to
-- 2. Write a query that shows each team's velocity with your chosen definition.
-- 3. Add a column that flags teams with velocity below the overall average.
--
-- Edge case to consider: The Product team has fewer people than Engineering.
-- Should velocity be normalized per team member? What are the pros and cons?

-- [Write your contract here as a SQL comment]
    -- "Team velocity" = average number of completed tasks per team member during the last 30 days.
-- [Write your query below]
WITH team_members AS (
    SELECT
        t.id   AS team_id,
        t.name AS team_name,
        COUNT(u.id) AS member_count
    FROM teams t
    LEFT JOIN users u
        ON u.team_id = t.id
    GROUP BY t.id, t.name
),
completed_tasks AS (
    SELECT
        u.team_id,
        COUNT(task.id) AS completed_count
    FROM tasks task
    JOIN users u
        ON task.assigned_to = u.id
    WHERE task.status = 'completed'
      AND task.completed_at >= CURRENT_DATE - 30
    GROUP BY u.team_id
),
velocity_calc AS (
    SELECT
        tm.team_id,
        tm.team_name,
        tm.member_count,
        NVL(ct.completed_count, 0) AS completed_tasks,
        ROUND(
            NVL(ct.completed_count, 0) /
            NULLIF(tm.member_count, 0),
            2
        ) AS velocity
    FROM team_members tm
    LEFT JOIN completed_tasks ct
        ON tm.team_id = ct.team_id
)
SELECT
    vc.team_name,
    vc.member_count,
    vc.completed_tasks,
    vc.velocity,
    CASE
        WHEN vc.velocity <
             AVG(vc.velocity) OVER ()
        THEN 'BELOW_AVERAGE'
        ELSE 'OK'
    END AS velocity_flag
FROM velocity_calc vc
ORDER BY vc.velocity DESC;

-- ============================================================
-- EXERCISE 2: Define "On-Time Delivery Rate"
-- ============================================================
--
-- Business context: The product manager wants to know: "Do we meet
-- our deadlines?" They ask for an "on-time delivery rate."
--
-- YOUR TASK:
-- 1. Define the KPI contract in comments. What does "on-time" mean?
--    Is it completed before due_date? Before end-of-day on due_date?
--    What about tasks with no due_date?
-- 2. Write a query that calculates the on-time delivery rate.
-- 3. Break it down by priority (critical, high, medium, low).
-- 4. Add a column showing the average "lateness" in hours for overdue tasks.
--
-- Edge case to consider: A task completed at 23:59 on the due date
-- vs. 00:01 the next day. Should both be "late"? Neither? Only one?
-- How does your choice affect the metric?

-- [Write your contract here as a SQL comment]
    -- "On-Time Delivery Rate" = percentage of completed tasks finished on or before their due date.
-- [Write your query below]
WITH completed_tasks AS (
    SELECT
        id,
        priority,
        due_date,
        completed_at,

        CASE
            WHEN completed_at <= (CAST(due_date AS TIMESTAMP)
                                  + INTERVAL '23:59:59' HOUR TO SECOND)
            THEN 1
            ELSE 0
        END AS is_on_time,

        CASE
            WHEN completed_at > (CAST(due_date AS TIMESTAMP)
                                 + INTERVAL '23:59:59' HOUR TO SECOND)
            THEN
                (
                    (CAST(completed_at AS DATE) - due_date) * 24
                )
            ELSE NULL
        END AS lateness_hours

    FROM tasks
    WHERE status = 'completed'
      AND completed_at IS NOT NULL
      AND due_date IS NOT NULL
)

SELECT
    priority,

    COUNT(*) AS total_completed_tasks,

    SUM(is_on_time) AS on_time_tasks,

    ROUND(
        (SUM(is_on_time) / COUNT(*)) * 100,
        2
    ) AS on_time_delivery_rate_pct,

    ROUND(
        AVG(lateness_hours),
        2
    ) AS avg_lateness_hours

FROM completed_tasks
GROUP BY priority
ORDER BY
    CASE priority
        WHEN 'critical' THEN 1
        WHEN 'high'     THEN 2
        WHEN 'medium'   THEN 3
        WHEN 'low'      THEN 4
    END;

-- ============================================================
-- EXERCISE 3: Improve "Tasks per Team" (KPI 2 from class)
-- ============================================================
--
-- FLAW: The original query counts ALL tasks assigned to users in a team,
-- including completed and cancelled tasks. A team with 50 completed tasks
-- and 0 open tasks looks "busy" but has no current workload.
--
-- YOUR TASK:
-- 1. Rewrite the query to show THREE columns per team:
--    - total_tasks (all time)
--    - active_tasks (open + in_progress + blocked)
--    - completion_rate (completed / total, excluding cancelled)
-- 2. Add a "health score" column: a CASE expression that labels each team
--    as 'Overloaded' (active_tasks > 10), 'Healthy' (5-10), or 'Underutilized' (< 5).
-- 3. Order by active_tasks DESC so the busiest teams appear first.

-- Original (from 03_kpi_queries.sql — KPI 2):
-- SELECT t.name AS team_name,
--        COUNT(ts.id) AS task_count
-- FROM   teams t
-- LEFT   JOIN users u ON u.team_id = t.id
-- LEFT   JOIN tasks ts ON ts.assigned_to = u.id
-- GROUP  BY t.id, t.name
-- ORDER  BY task_count DESC;
--
-- Technique: LEFT JOIN chain. We start from teams (the dimension table)
-- and LEFT JOIN through users to tasks. This ensures teams with zero
-- tasks still appear (count = 0), which an INNER JOIN would hide.

-- [Write your improved query below]
WITH base AS (
    SELECT
        t.name AS team_name,

        COUNT(ts.id) AS total_tasks,

        SUM(
            CASE
                WHEN ts.status IN ('open', 'in_progress', 'blocked')
                THEN 1 ELSE 0
            END
        ) AS active_tasks,

        SUM(
            CASE
                WHEN ts.status = 'completed'
                THEN 1 ELSE 0
            END
        ) AS completed_tasks,

        SUM(
            CASE
                WHEN ts.status <> 'cancelled'
                THEN 1 ELSE 0
            END
        ) AS non_cancelled_tasks

    FROM teams t
    LEFT JOIN users u
        ON u.team_id = t.id
    LEFT JOIN tasks ts
        ON ts.assigned_to = u.id
    GROUP BY t.name
)

SELECT
    team_name,
    total_tasks,
    active_tasks,

    ROUND(
        (completed_tasks / NULLIF(non_cancelled_tasks, 0)) * 100,
        2
    ) AS completion_rate,

    CASE
        WHEN active_tasks > 10 THEN 'Overloaded'
        WHEN active_tasks BETWEEN 5 AND 10 THEN 'Healthy'
        ELSE 'Underutilized'
    END AS health_score

FROM base
ORDER BY active_tasks DESC, team_name;

-- ============================================================
-- EXERCISE 4: Improve "Average Resolution Time" (KPI 5 from class)
-- ============================================================
--
-- FLAW: The original query averages ALL completed tasks together.
-- A critical bug fixed in 2 hours and a documentation update fixed in
-- 40 hours are averaged together. The metric hides priority differences.
--
-- YOUR TASK:
-- 1. Rewrite the query to show average resolution time BY PRIORITY.
-- 2. Add a column showing the MEDIAN resolution time per priority.
--    (Hint: Oracle 23ai supports PERCENTILE_CONT. Research it.)
-- 3. Add a column showing the FASTEST and SLOWEST resolution time per priority.
--    (Hint: MIN and MAX, but only if you want simple extremes.)
-- 4. Add a "target met" column: For each priority, define a target SLA
--    (critical = 24h, high = 72h, medium = 168h, low = 336h) and flag
--    whether the average meets the target.
--
-- Edge case: What if a priority has only 1 completed task? Is the average meaningful?
-- How should you communicate that in the result?

-- Original (from 03_kpi_queries.sql — KPI 5):
-- SELECT ROUND(AVG(
--            EXTRACT(DAY FROM (completed_at - created_at)) * 24 +
--            EXTRACT(HOUR FROM (completed_at - created_at)) +
--            EXTRACT(MINUTE FROM (completed_at - created_at)) / 60
--        ), 1) AS avg_resolution_hours,
--        COUNT(*) AS completed_task_count
-- FROM   tasks
-- WHERE  status = 'completed'
--   AND  completed_at IS NOT NULL;
--
-- Technique: EXTRACT from INTERVAL. Oracle timestamp subtraction
-- returns a DAY TO SECOND interval. We break it into components.
-- We also report the count — an average of 2 tasks is not meaningful.

-- [Write your improved query below]
WITH resolution_data AS (
    SELECT
        priority,

        (
            EXTRACT(DAY FROM (completed_at - created_at)) * 24 +
            EXTRACT(HOUR FROM (completed_at - created_at)) +
            EXTRACT(MINUTE FROM (completed_at - created_at)) / 60 +
            EXTRACT(SECOND FROM (completed_at - created_at)) / 3600
        ) AS resolution_hours

    FROM tasks
    WHERE status = 'completed'
      AND completed_at IS NOT NULL
)

SELECT
    priority,

    COUNT(*) AS completed_task_count,

    ROUND(
        AVG(resolution_hours),
        2
    ) AS avg_resolution_hours,

    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY resolution_hours),
        2
    ) AS median_resolution_hours,

    ROUND(
        MIN(resolution_hours),
        2
    ) AS fastest_resolution_hours,

    ROUND(
        MAX(resolution_hours),
        2
    ) AS slowest_resolution_hours,

    CASE priority
        WHEN 'critical' THEN 24
        WHEN 'high'     THEN 72
        WHEN 'medium'   THEN 168
        WHEN 'low'      THEN 336
    END AS sla_target_hours,

    CASE
        WHEN AVG(resolution_hours) <=
             CASE priority
                 WHEN 'critical' THEN 24
                 WHEN 'high'     THEN 72
                 WHEN 'medium'   THEN 168
                 WHEN 'low'      THEN 336
             END
        THEN 'TARGET_MET'
        ELSE 'TARGET_MISSED'
    END AS target_met,

    CASE
        WHEN COUNT(*) = 1
        THEN 'LOW_SAMPLE_SIZE'
        WHEN COUNT(*) < 5
        THEN 'SMALL_SAMPLE'
        ELSE 'SUFFICIENT_DATA'
    END AS data_quality_flag

FROM resolution_data

GROUP BY priority

ORDER BY
    CASE priority
        WHEN 'critical' THEN 1
        WHEN 'high'     THEN 2
        WHEN 'medium'   THEN 3
        WHEN 'low'      THEN 4
    END;

-- ============================================================
-- EXERCISE 5: Improve "Overdue Tasks" (KPI 7 from class)
-- ============================================================
--
-- FLAW: The original query is a simple COUNT. It tells you HOW MANY
-- tasks are overdue, but not HOW OVERDUE, WHO owns them, or WHAT
-- the business impact is. A critical task 1 day late is different
-- from a low-priority task 30 days late.
--
-- YOUR TASK:
-- 1. Rewrite the query as a detailed report (not just a count).
--    Include: task title, assignee, team, priority, due_date,
--    days_overdue (calculated), and a "severity" column.
-- 2. Define severity as:
--    - 'CRITICAL': priority = 'critical' AND days_overdue > 0
--    - 'HIGH': priority = 'high' AND days_overdue > 2
--    - 'MEDIUM': priority = 'medium' AND days_overdue > 5
--    - 'LOW': everything else overdue
-- 3. Order by severity (most urgent first), then by days_overdue DESC.
-- 4. Add a summary row at the bottom (using ROLLUP or UNION) showing
--    total overdue count and average days overdue per severity level.

-- Original (from 03_kpi_queries.sql — KPI 7):
-- SELECT COUNT(*) AS overdue_count
-- FROM   tasks
-- WHERE  due_date < TRUNC(SYSDATE)
--   AND  status NOT IN ('completed', 'cancelled')
--   AND  due_date IS NOT NULL;
--
-- Technique: TRUNC(SYSDATE) gives today at midnight. We compare dates
-- without time-of-day to avoid false positives (a task due "today"
-- at 23:59 should not be flagged at 09:00).
-- NULL check is defensive — always filter out unknown due dates.

-- [Write your improved query below]
WITH overdue_tasks AS (
    SELECT
        ts.id,
        ts.title,
        u.full_name AS assignee,
        t.name AS team_name,
        ts.priority,
        ts.due_date,

        TRUNC(SYSDATE) - TRUNC(ts.due_date) AS days_overdue,

        CASE
            WHEN ts.priority = 'critical'
                 AND (TRUNC(SYSDATE) - TRUNC(ts.due_date)) > 0
            THEN 'CRITICAL'

            WHEN ts.priority = 'high'
                 AND (TRUNC(SYSDATE) - TRUNC(ts.due_date)) > 2
            THEN 'HIGH'

            WHEN ts.priority = 'medium'
                 AND (TRUNC(SYSDATE) - TRUNC(ts.due_date)) > 5
            THEN 'MEDIUM'

            ELSE 'LOW'
        END AS severity

    FROM tasks ts
    LEFT JOIN users u
        ON ts.assigned_to = u.id
    LEFT JOIN teams t
        ON u.team_id = t.id
    WHERE ts.due_date IS NOT NULL
      AND ts.due_date < TRUNC(SYSDATE)
      AND ts.status NOT IN ('completed', 'cancelled')
),

final_data AS (

    SELECT
        severity,
        title,
        assignee,
        team_name,
        priority,
        due_date,
        days_overdue,
        NULL AS overdue_count,
        NULL AS avg_days_overdue,
        'DETAIL' AS row_type,

        1 AS sort_group,
        days_overdue AS sort_days

    FROM overdue_tasks

    UNION ALL

    SELECT
        severity,
        'TOTAL OVERDUE TASKS' AS title,
        NULL AS assignee,
        NULL AS team_name,
        NULL AS priority,
        NULL AS due_date,
        NULL AS days_overdue,

        COUNT(*) AS overdue_count,

        ROUND(AVG(days_overdue), 2) AS avg_days_overdue,

        'SUMMARY' AS row_type,

        2 AS sort_group,
        NULL AS sort_days

    FROM overdue_tasks
    GROUP BY severity
)

SELECT *
FROM final_data
ORDER BY
    CASE severity
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH' THEN 2
        WHEN 'MEDIUM' THEN 3
        WHEN 'LOW' THEN 4
    END,
    sort_group,
    sort_days DESC NULLS LAST;

-- ============================================================
-- EXERCISE 6: Fix the "Productivity Score"
-- ============================================================
--
-- BAD QUERY:
-- SELECT u.full_name, COUNT(ts.id) AS productivity_score
-- FROM users u
-- JOIN tasks ts ON ts.assigned_to = u.id
-- GROUP BY u.id, u.full_name
-- ORDER BY productivity_score DESC;
--
-- PROBLEM: ____________________________________________________
-- (What is wrong with this metric? Hint: Does it distinguish between
--  creating 10 tasks and completing 10 tasks? Does it handle unassigned
--  tasks? Does it account for task complexity or priority?)
--
-- REWRITE: Write a query that measures something actually meaningful.
-- Suggestion: "Completed tasks per day, weighted by priority."

-- [Write your analysis as a SQL comment]
    -- Counts ALL assigned tasks equally
    -- Does not measure outcomes
    -- Includes unfinished work
    -- Ignores time dimension
    -- Ignores task complexity / business impact
    -- Excludes unassigned tasks implicitly

-- [Write your rewritten query below]
WITH completed_tasks AS (
    SELECT
        u.id,
        u.full_name,
        t.name AS team_name,
        ts.completed_at,

        CASE ts.priority
            WHEN 'critical' THEN 5
            WHEN 'high'     THEN 3
            WHEN 'medium'   THEN 2
            WHEN 'low'      THEN 1
            ELSE 1
        END AS weighted_points

    FROM users u
    LEFT JOIN teams t
        ON u.team_id = t.id
    LEFT JOIN tasks ts
        ON ts.assigned_to = u.id

    WHERE ts.status = 'completed'
      AND ts.completed_at IS NOT NULL
),

user_productivity AS (
    SELECT
        id,
        full_name,
        team_name,

        COUNT(*) AS completed_task_count,

        SUM(weighted_points) AS total_weighted_points,

        COUNT(DISTINCT TRUNC(completed_at)) AS active_work_days,

        ROUND(
            SUM(weighted_points) /
            NULLIF(COUNT(DISTINCT TRUNC(completed_at)), 0),
            2
        ) AS productivity_score

    FROM completed_tasks
    GROUP BY
        id,
        full_name,
        team_name
)

SELECT
    full_name,
    team_name,
    completed_task_count,
    total_weighted_points,
    active_work_days,
    productivity_score,

    CASE
        WHEN productivity_score >= 8
        THEN 'HIGH_PERFORMER'

        WHEN productivity_score >= 4
        THEN 'SOLID_PERFORMER'

        ELSE 'LOW_ACTIVITY'
    END AS productivity_band

FROM user_productivity

ORDER BY
    productivity_score DESC,
    total_weighted_points DESC,
    full_name;

-- ============================================================
-- EXERCISE 7: Fix the "Team Efficiency"
-- ============================================================
--
-- BAD QUERY:
-- SELECT t.name, AVG(ts.id) AS avg_task_id
-- FROM teams t
-- JOIN users u ON u.team_id = t.id
-- JOIN tasks ts ON ts.assigned_to = u.id
-- GROUP BY t.id, t.name;
--
-- PROBLEM: ____________________________________________________
-- (What is mathematically wrong here? What does "average task ID" mean?)
--
-- REWRITE: Write a query that measures actual team efficiency.
-- Suggestion: "Ratio of completed tasks to total tasks, per team."

-- [Write your analysis as a SQL comment]
    -- "AVG(ts.id)" is mathematically meaningless
    -- The metric has no operational meaning
    -- INNER JOIN hides teams with no tasks

-- [Write your rewritten query below]
SELECT
    COUNT(*) AS total_tasks,

    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_tasks,

    SUM(CASE WHEN status IN ('open','in_progress','blocked')
             THEN 1 ELSE 0 END) AS active_tasks,

    SUM(CASE
            WHEN due_date < CURRENT_DATE
             AND status NOT IN ('completed','cancelled')
            THEN 1 ELSE 0
        END) AS overdue_tasks,

    ROUND(
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END)
        /
        NULLIF(COUNT(*), 0) * 100,
        2
    ) AS completion_rate_pct

FROM tasks;

-- ============================================================
-- EXERCISE 8: Fix the "Urgency Index"
-- ============================================================
--
-- BAD QUERY:
-- SELECT title, priority * 10 + DUE_DATE AS urgency_index
-- FROM tasks
-- ORDER BY urgency_index DESC;
--
-- PROBLEM: ____________________________________________________
-- (What is wrong with adding a string and a number? What is wrong with
--  multiplying a VARCHAR by 10? What should the query actually do?)
--
-- REWRITE: Write a query that creates a real urgency score.
-- Suggestion: Assign numeric weights to priority (critical=4, high=3,
-- medium=2, low=1) and add days_until_due (negative if overdue).
-- A higher score = more urgent.

-- [Write your analysis as a SQL comment]
-- Invalid arithmetic with VARCHAR values
-- Invalid addition of NUMBER + DATE
-- No business interpretation

-- [Write your rewritten query below]
SELECT
    ts.id,
    ts.title,
    ts.status,
    ts.priority,
    ts.due_date,
    u.full_name AS assignee,
    t.name AS team_name,

    CASE ts.priority
        WHEN 'critical' THEN 4
        WHEN 'high'     THEN 3
        WHEN 'medium'   THEN 2
        WHEN 'low'      THEN 1
        ELSE 0
    END AS priority_weight,

    TRUNC(ts.due_date) - TRUNC(SYSDATE) AS days_until_due,

    (
        CASE ts.priority
            WHEN 'critical' THEN 4
            WHEN 'high'     THEN 3
            WHEN 'medium'   THEN 2
            WHEN 'low'      THEN 1
            ELSE 0
        END * 100
    )
    -
    (
        TRUNC(ts.due_date) - TRUNC(SYSDATE)
    ) AS urgency_score,

    CASE
        WHEN ts.priority = 'critical'
             AND TRUNC(ts.due_date) < TRUNC(SYSDATE)
        THEN 'IMMEDIATE_ACTION'

        WHEN TRUNC(ts.due_date) < TRUNC(SYSDATE)
        THEN 'OVERDUE'

        WHEN TRUNC(ts.due_date) = TRUNC(SYSDATE)
        THEN 'DUE_TODAY'

        WHEN (TRUNC(ts.due_date) - TRUNC(SYSDATE)) <= 2
        THEN 'DUE_SOON'

        ELSE 'SCHEDULED'
    END AS urgency_status

FROM tasks ts

LEFT JOIN users u
    ON ts.assigned_to = u.id

LEFT JOIN teams t
    ON u.team_id = t.id

WHERE ts.status NOT IN ('completed', 'cancelled')
  AND ts.due_date IS NOT NULL

ORDER BY
    urgency_score DESC,
    ts.priority DESC,
    ts.due_date ASC;

-- ============================================================
-- PART D: Bonus — Build a Summary Dashboard Query
-- ============================================================
--
-- Write a SINGLE query that returns one row with ALL of the following:
-- 1. total_tasks
-- 2. completed_tasks
-- 3. active_tasks (open + in_progress + blocked)
-- 4. overdue_tasks
-- 5. completion_rate_pct
-- 6. avg_resolution_hours
-- 7. avg_days_overdue (for overdue tasks only)
-- 8. most_common_priority (the priority with the most active tasks)
-- 9. busiest_team (team with the most active tasks)
--
-- Use CTEs to build this step by step. Start with a "base" CTE that
-- enriches tasks with derived columns, then build metric CTEs from it.
--
-- This is the pattern real BI tools use: one query, many metrics.

-- [Write your mega-query below]
WITH base AS (
    SELECT
        ts.id,
        ts.title,
        ts.status,
        ts.priority,
        ts.created_at,
        ts.completed_at,
        ts.due_date,

        u.id AS user_id,
        u.full_name,

        t.id AS team_id,
        t.name AS team_name,

        CASE
            WHEN ts.status IN ('open', 'in_progress', 'blocked')
            THEN 1 ELSE 0
        END AS is_active,

        CASE
            WHEN ts.status = 'completed'
            THEN 1 ELSE 0
        END AS is_completed,

        CASE
            WHEN ts.due_date < CURRENT_DATE
             AND ts.status NOT IN ('completed', 'cancelled')
            THEN 1 ELSE 0
        END AS is_overdue,

        CASE
            WHEN ts.due_date < CURRENT_DATE
             AND ts.status NOT IN ('completed', 'cancelled')
            THEN CURRENT_DATE - ts.due_date
            ELSE NULL
        END AS days_overdue,

        CASE
            WHEN ts.status = 'completed'
             AND ts.completed_at IS NOT NULL
            THEN (ts.completed_at - ts.created_at) * 24
            ELSE NULL
        END AS resolution_hours

    FROM tasks ts
    LEFT JOIN users u
        ON ts.assigned_to = u.id
    LEFT JOIN teams t
        ON u.team_id = t.id
),

task_metrics AS (
    SELECT
        COUNT(*) AS total_tasks,
        SUM(is_completed) AS completed_tasks,
        SUM(is_active) AS active_tasks,
        SUM(is_overdue) AS overdue_tasks,

        ROUND(
            SUM(is_completed)
            /
            NULLIF(COUNT(*), 0)
            * 100,
            2
        ) AS completion_rate_pct,

        ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours,
        ROUND(AVG(days_overdue), 2) AS avg_days_overdue
    FROM base
),

priority_rank AS (
    SELECT
        priority,
        COUNT(*) AS cnt,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
    FROM base
    WHERE is_active = 1
    GROUP BY priority
),

most_common_priority AS (
    SELECT priority AS most_common_priority
    FROM priority_rank
    WHERE rn = 1
),

team_rank AS (
    SELECT
        team_name,
        COUNT(*) AS cnt,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
    FROM base
    WHERE is_active = 1
      AND team_name IS NOT NULL
    GROUP BY team_name
),

busiest_team AS (
    SELECT team_name AS busiest_team
    FROM team_rank
    WHERE rn = 1
)

SELECT
    tm.total_tasks,
    tm.completed_tasks,
    tm.active_tasks,
    tm.overdue_tasks,
    tm.completion_rate_pct,
    tm.avg_resolution_hours,
    tm.avg_days_overdue,
    mcp.most_common_priority,
    bt.busiest_team
FROM task_metrics tm
CROSS JOIN most_common_priority mcp
CROSS JOIN busiest_team bt;