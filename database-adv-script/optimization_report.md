# Optimization of query
```sql
EXPLAIN ANALYZE
SELECT 
    u.first_name, 
    u.email,
    p.name,
    p.location,
    b.booking_id,
    b.status,
    pay.amount,
    pay.payment_id
FROM "User" u 
INNER JOIN Booking b ON b.user_id=u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON pay.booking_id = b.booking_id;
```

**Result**
```bash
"QUERY PLAN"
"Hash Right Join  (cost=17.25..38.06 rows=780 width=196) (actual time=0.122..0.132 rows=2 loops=1)"
"  Hash Cond: (pay.booking_id = b.booking_id)"
"  ->  Seq Scan on payment pay  (cost=0.00..17.80 rows=780 width=64) (actual time=0.011..0.011 rows=1 loops=1)"
"  ->  Hash  (cost=17.23..17.23 rows=2 width=148) (actual time=0.098..0.101 rows=2 loops=1)"
"        Buckets: 1024  Batches: 1  Memory Usage: 9kB"
"        ->  Nested Loop  (cost=1.04..17.23 rows=2 width=148) (actual time=0.087..0.093 rows=2 loops=1)"
"              Join Filter: (b.property_id = p.property_id)"
"              Rows Removed by Join Filter: 1"
"              ->  Hash Join  (cost=1.04..16.15 rows=2 width=100) (actual time=0.068..0.073 rows=2 loops=1)"
"                    Hash Cond: (u.user_id = b.user_id)"
"                    ->  Seq Scan on ""User"" u  (cost=0.00..13.70 rows=370 width=80) (actual time=0.020..0.021 rows=4 loops=1)"
"                    ->  Hash  (cost=1.02..1.02 rows=2 width=52) (actual time=0.030..0.030 rows=2 loops=1)"
"                          Buckets: 1024  Batches: 1  Memory Usage: 9kB"
"                          ->  Seq Scan on booking b  (cost=0.00..1.02 rows=2 width=52) (actual time=0.016..0.017 rows=2 loops=1)"
"              ->  Materialize  (cost=0.00..1.03 rows=2 width=80) (actual time=0.008..0.009 rows=2 loops=2)"
"                    ->  Seq Scan on property p  (cost=0.00..1.02 rows=2 width=80) (actual time=0.010..0.011 rows=2 loops=1)"
"Planning Time: 13.490 ms"
"Execution Time: 0.224 ms"
```