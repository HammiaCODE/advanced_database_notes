
### `sql_challenges/challenge-02/README.md`

```md
# SQL Challenge 02 - Aggregation

## Problem
Practice of using aggregations in SQLBolt

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
│   ├── challenge-02/
│   │   └── README.md