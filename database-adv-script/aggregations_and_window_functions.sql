SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS "Number of booking(s)"
FROM "User" u
INNER JOIN
booking b ON b.user_id=u.user_id
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY "Number of booking(s)" ASC
;

WITH PropertyBookingCount AS
(
    SELECT
        p.property_id,
        p.name,
        COUNT(b.booking_id) AS booking_count
    FROM
        property p
    LEFT JOIN
        booking b ON b.property_id=p.property_id
    GROUP BY p.property_id, p.name
)

SELECT
    property_id,
    name,
    booking_count,
    ROW_NUMBER() OVER (ORDER BY booking_count ASC) AS property_row_number,
    RANK() OVER (ORDER BY booking_count ASC) AS property_row_rank
FROM
    PropertyBookingCount
ORDER BY property_row_rank;