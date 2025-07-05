-- ====================================================================
--  DATABASE SEED SCRIPT (Idempotent)
-- ====================================================================
-- Clean all data from tables in reverse order of dependency.
-- This prevents foreign key constraint errors.
DELETE FROM message;
DELETE FROM Review;
DELETE FROM Payment;
DELETE FROM Booking;
DELETE FROM Property;
DELETE FROM "User";
-- The "parent" table is last.
INSERT INTO "User"(
        user_id,
        first_name,
        last_name,
        email,
        password_hash,
        phone_number,
        role
    )
VALUES (
        'f47ac10b-58cc-4372-a567-0e02b2c3d479',
        'Alice',
        'Wonderland',
        'alice.host@email.com',
        'hashed_password_123',
        '111-222-3333',
        'host'
    ),
    (
        '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        'Bob',
        'Builder',
        'bob.builder@email.com',
        'hashed_password_456',
        '444-555-6666',
        'host'
    ),
    (
        'a3b8c2d4-e6f7-4890-1234-567890abcdef',
        'Diana',
        'Prince',
        'diana.guest@email.com',
        'hashed_password_abc',
        '777-888-9999',
        'guest'
    ),
    (
        '98765432-1234-5678-9abc-def012345678',
        'Eve',
        'Joy',
        'eve.admin@email.com',
        'hashed_password_xyz',
        NULL,
        'guest'
    );
INSERT INTO Property (
        property_id,
        host_id,
        name,
        description,
        location,
        pricepernight
    )
VALUES (
        'c2f3a9b1-e2d3-4f56-a789-012b3c4d5e6f',
        'f47ac10b-58cc-4372-a567-0e02b2c3d479',
        'Sunny Downtown Loft',
        'Penthouse by the beach',
        'Miami',
        4500.00
    ),
    (
        'd3e4b8a2-f1e2-3d4c-5b6a-7890c1d2e3f4',
        '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        'Quiet Beach House',
        'Beach House',
        'Malibu, CA',
        250.00
    );
INSERT INTO Booking(
        booking_id,
        property_id,
        user_id,
        start_date,
        end_date,
        total_price,
        status
    )
VALUES(
        'f7a8b9c0-1234-5678-90ab-cdef12345678',
        'c2f3a9b1-e2d3-4f56-a789-012b3c4d5e6f',
        '98765432-1234-5678-9abc-def012345678',
        '2023-10-10',
        '2023-10-13',
        13500,
        'confirmed'
    ),
    (
        'a1b2c3d4-5678-90ab-cdef-1234567890ab',
        'd3e4b8a2-f1e2-3d4c-5b6a-7890c1d2e3f4',
        'a3b8c2d4-e6f7-4890-1234-567890abcdef',
        '2023-11-05',
        '2023-11-07',
        500.00,
        'pending'
    );
INSERT INTO Payment(payment_id, booking_id, amount, payment_method)
VALUES (
        'c5d6e7f8-9012-3456-7890-bcdef0123456',
        'f7a8b9c0-1234-5678-90ab-cdef12345678',
        13500,
        'stripe'
    );
INSERT INTO Review(review_id, property_id, user_id, rating, comment)
VALUES (
        'd6e7f8a9-0123-4567-890a-cdef01234567',
        'c2f3a9b1-e2d3-4f56-a789-012b3c4d5e6f',
        '98765432-1234-5678-9abc-def012345678',
        5,
        'Amazing place! The location was perfect and the host was very responsive. Highly recommend!'
    );
INSERT INTO Message(
        message_id,
        sender_id,
        recipient_id,
        message_body
    )
VALUES (
        'f8a9b0c1-2345-6789-0abc-ef0123456789',
        'a3b8c2d4-e6f7-4890-1234-567890abcdef',
        '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        'Hi Bob, just wondering if your beach house has a grill we can use for our upcoming trip?'
    );