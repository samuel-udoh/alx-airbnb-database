# Performance Tuning with Indexes

Indexes are special lookup tables that the database search engine can use to speed up data retrieval. While primary and foreign keys are indexed automatically or by best practice, we must also consider columns frequently used in `WHERE`, `JOIN`, or `ORDER BY` clauses.

### Why Indexes are Important

Without an index, the database must perform a **Sequential Scan (Seq Scan)**, meaning it reads every single row in a table to find the data that matches a query's conditions. This is slow and inefficient for large tables. With an index, the database can perform a much faster **Index Scan**, where it uses the index to find the exact location of the required rows and fetches only them.

### Example: Analyzing a Query on `Property.location`

A very common query in our application will be searching for properties in a specific location. Let's analyze the performance of this query before and after adding an index on the `Property.location` column.

We use the `EXPLAIN ANALYZE` command, which shows the query plan and the actual execution time.

#### Before Adding an Index

First, we run the query without a dedicated index on `location`.

**Command:**
```sql
EXPLAIN ANALYZE
SELECT * FROM property WHERE location='Malibu, CA';
```

**Output:**
```
                                             QUERY PLAN
-----------------------------------------------------------------------------------------------------
 Seq Scan on property  (cost=0.00..15.00 rows=2 width=176) (actual time=0.015..0.017 rows=1 loops=1)
   Filter: ((location)::text = 'Malibu, CA'::text)
   Rows Removed by Filter: 1
 Planning Time: 0.072 ms
 Execution Time: 0.037 ms
```
-   **Plan:** The planner chose a `Seq Scan`, as expected. It had to read the entire table.
-   **Execution Time:** The query took **0.037 ms** to execute. This is our baseline.

#### After Adding an Index

Next, we create an index and run the exact same command.

**Command:**
```sql
CREATE INDEX idx_property_location ON Property(location);

EXPLAIN ANALYZE
SELECT * FROM property WHERE location='Malibu, CA';
```

**Output:**
```
                                             QUERY PLAN
-----------------------------------------------------------------------------------------------------
 Seq Scan on property  (cost=0.00..15.00 rows=2 width=176) (actual time=0.014..0.015 rows=1 loops=1)
   Filter: ((location)::text = 'Malibu, CA'::text)
   Rows Removed by Filter: 1
 Planning Time: 0.090 ms
 Execution Time: 0.034 ms
```
-   **Plan:** The planner **still chose a `Seq Scan`**.
-   **Execution Time:** The query took **0.034 ms** to execute.

#### Analysis and Conclusion

In this specific case, the `Execution Time` is marginally faster, but the query plan did **not** change. Why?

The PostgreSQL query planner is incredibly smart. Our `property` table only contains 2 rows from the seed script. The planner correctly calculated that the cost of performing an index scan (looking up 'Malibu, CA' in the index, then fetching the row from the table) was higher than simply reading the entire tiny table from disk.

**This is the correct and most efficient behavior for a small dataset.**

If the `Property` table grew to thousands or millions of rows, the planner would absolutely switch to an **Index Scan**, and the performance difference would be dramatic—potentially reducing query times from seconds or minutes down to a few milliseconds. This exercise demonstrates the process of identifying performance bottlenecks and validates that even when an index exists, the planner will only use it when it's more efficient to do so.

## Included SQL Scripts

-   `schema_and_seed.sql`: A single, idempotent script to set up the entire database structure and populate it with initial data.
-   `database_index.sql`: A script to create performance-enhancing indexes on high-usage, non-key columns.