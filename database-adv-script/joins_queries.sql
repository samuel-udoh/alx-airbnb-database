SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.email
FROM
    booking b
INNER JOIN
    "User" u ON b.user_id=u.user_id
ORDER BY
    b.start_date DESC;

SELECT p.property_id, p.name, r.review_id, r.rating
FROM
    property p
LEFT JOIN
    review r ON p.property_id=r.property_id
ORDER BY r.rating ASC;

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.email
FROM
    booking b
FULL OUTER JOIN
    "User" u ON b.user_id=u.user_id
ORDER BY
    b.start_date DESC;