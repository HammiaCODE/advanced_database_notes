
### `sql_challenges/challenge-01/README.md`

```md
# SQL Challenge 01 – SQL Bolt

## Problem
Exercises 1 to 5 rom SQL Bolt

## Schema
```sql
CREATE TABLE orders (
  id BIGINT PRIMARY KEY,
  customer_id BIGINT,
  created_at TIMESTAMP,
  status TEXT
);

── sql_challenges/
│   ├── challenge-01/
│   │   ├── README.md
│   │   ├── solution.sql
│   │   └── notes.md