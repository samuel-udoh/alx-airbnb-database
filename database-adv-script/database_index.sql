EXPLAIN ANALYZE
SELECT * FROM Property
WHERE location="Miami";

CREATE INDEX IF NOT EXISTS idx_property_location ON Property(location);
CREATE INDEX IF NOT EXISTS idx_property_pricepernight ON Property(pricepernight);
CREATE INDEX IF NOT EXISTS idx_booking_dates ON Booking(start_date, end_date);

EXPLAIN ANALYZE
SELECT * FROM Property
WHERE location="Miami";