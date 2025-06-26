-- ====================================================================
--  DATABASE RESET SCRIPT (Idempotent & Optimized)
-- ====================================================================
-- Drop objects in the correct reverse order of dependency.
DROP TRIGGER IF EXISTS set_updated_at ON Property;
DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS "User";
DROP TYPE IF EXISTS payment_method_options;
DROP TYPE IF EXISTS status_state;
DROP TYPE IF EXISTS user_role;
DROP FUNCTION IF EXISTS update_updated_at_column();
-- ====================================================================
--  Create all objects from a clean slate.
-- ====================================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- CREATE TYPES
CREATE TYPE user_role AS ENUM ('host', 'guest', 'admin');
CREATE TYPE status_state AS ENUM('pending', 'confirmed', 'canceled');
CREATE TYPE payment_method_options AS ENUM('credit_card', 'paypal', 'stripe');
-- User Table
CREATE TABLE "User" (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password_hash VARCHAR NOT NULL,
    phone_number VARCHAR,
    role user_role NOT NULL DEFAULT 'guest',
    created_at TIMESTAMP DEFAULT NOW()
);
CREATE UNIQUE INDEX idx_users_email ON "User"(email);
-- Property TABLE
CREATE TABLE Property (
    property_id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    host_id UUID NOT NULL,
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR NOT NULL,
    pricepernight DECIMAL NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (host_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);
CREATE INDEX idx_property_host_id ON Property(host_id);
-- Update 'update_at' automatically when update is made
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$ BEGIN NEW.updated_at := NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER set_updated_at BEFORE
UPDATE ON Property FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
--  BOOKING TBALE
CREATE TABLE Booking(
    booking_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL NOT NULL,
    status status_state NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_user_id ON Booking(user_id);
--  PAYMENT TABLE
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID NOT NULL,
    amount DECIMAL NOT NULL,
    payment_date TIMESTAMP DEFAULT NOW(),
    payment_method payment_method_options NOT NULL,
    FOREIGN KEY(booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE
);
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);
--  REVIEW TABLE
CREATE TABLE Review (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (
        rating >= 1
        and rating <= 5
    ),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);
CREATE INDEX idx_review_property_id ON Review(property_id);
CREATE INDEX idx_review_user_id ON Review(user_id);
--  MESSAGE TABLE
CREATE TABLE Message(
    message_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID,
    recipient_id UUID,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(sender_id) REFERENCES "User"(user_id) ON DELETE
    SET NULL,
        FOREIGN KEY (recipient_id) REFERENCES "User"(user_id) ON DELETE
    SET NULL
);
CREATE INDEX idx_message_sender_id ON Message(sender_id);
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);