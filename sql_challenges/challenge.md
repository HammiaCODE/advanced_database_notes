
### `sql_challenges/challenge-01/README.md`

```md
# SQL Challenge 01 – Analytic Functions: Databases for Developers

## Problem
Complete "Analytic Functions: Databases for Developers" from FreeSQL

## Schema
```sql
select b.*,
       count(*) over (
         partition by shape
       ) bricks_per_shape,
       median ( weight ) over (
         partition by shape
       ) median_weight_per_shape
from   bricks b
order  by shape, weight, brick_id;


select b.brick_id, b.weight,
       round ( avg ( weight ) over (
         order by brick_id
       ), 2 ) running_average_weight
from   bricks b
order  by brick_id;


select b.*,
       min ( colour ) over (
         order by brick_id
         rows between 2 preceding and 1 preceding 
       ) first_colour_two_prev,
       count (*) over (
         order by weight
         range between current row and 1 following
       ) count_values_this_and_next
from   bricks b
order  by weight;





```md
# SQL Challenge 01 – Top Three Salaries

## Problem
Complete "Top Three Salaries" from datalemur

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