CREATE TABLE Booking_partition(
    booking_id UUID,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL NOT NULL,
    status status_state NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

CREATE INDEX IF NOT EXISTS idx_user_id_booking_partition ON Booking_partition(user_id);
CREATE INDEX IF NOT EXISTS idx_property_id_booking_partition ON Booking_partition(property_id);

CREATE TABLE Booking_2023_h1 PARTITION OF Booking_partition
FOR VALUES FROM ('2023-01-01') TO ('2023-07-01');

CREATE TABLE Booking_2023_h2 PARTITION OF Booking_partition
FOR VALUES FROM ('2023-07-01') TO ('2024-01-01');

INSERT INTO Booking_partition
SELECT * FROM Booking;

EXPLAIN ANALYZE
SELECT * FROM Booking_partition
WHERE 
    start_date > '2023-03-24';

