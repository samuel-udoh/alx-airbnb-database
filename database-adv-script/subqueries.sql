SELECT 
    property_id,
    name, 
    location 
FROM property
WHERE 
    property_id IN 
    (SELECT review.property_id 
    FROM 
        review  
    GROUP BY review.property_id 
    HAVING AVG(review.rating) > 4
    );

SELECT 
    user_id, 
    first_name,
    email 
FROM "User"
WHERE user_id IN 
(
    SELECT booking.user_id 
    FROM booking 
    GROUP BY user_id 
    HAVING COUNT(user_id) > 3
);