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