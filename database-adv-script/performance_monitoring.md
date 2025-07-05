# Guide to Database Performance Monitoring

Effective performance monitoring is crucial for maintaining a healthy, responsive, and scalable application. This guide outlines the key tools and strategies for monitoring the performance of our PostgreSQL database.

## 1. The Core Tool: `EXPLAIN ANALYZE`

The single most important tool for understanding query performance is the `EXPLAIN ANALYZE` command.

-   **`EXPLAIN`**: Shows the **Execution Plan**—the series of steps the PostgreSQL planner *intends* to take to run a query. It provides cost estimates but doesn't run the query.
-   **`EXPLAIN ANALYZE`**: Shows the execution plan **and** actually runs the query, providing the real-world timing for each step. This is the ground truth for performance analysis.

### How to Read the Output

When analyzing the output of `EXPLAIN ANALYZE`, look for these key indicators:

1.  **Scan Type:**
    -   **`Seq Scan` (Sequential Scan):** Reads the entire table. This is efficient for very small tables but a major red flag for large tables, indicating a missing or unused index.
    -   **`Index Scan` / `Bitmap Index Scan`:** The database is using an index to find the data. This is generally what you want to see for filtered queries on large tables.

2.  **`Execution Time`:** This is the final, total time it took to run the query after planning. This is your primary benchmark for measuring improvement.

3.  **`Rows Removed by Filter`:** This shows how many rows were read from the table but discarded because they didn't match the `WHERE` clause. A high number combined with a `Seq Scan` is a clear sign that an index is needed.

4.  **`Planning Time`:** The time taken to decide on the best plan. A high planning time on the first run of a complex query is normal; it should decrease on subsequent runs as metadata is cached.
