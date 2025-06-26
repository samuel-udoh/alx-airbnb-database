# Database Seeding Script

This document describes the `seeds.sql` script, which is designed to populate the vacation rental database with a consistent and logical set of sample data. This is essential for creating a predictable environment for development, testing, and demonstrations.

## Key Features & Design

This is not a simple `INSERT` script. It has been carefully designed to be robust and easy to use.

### 1. Idempotent by Design

The most important feature of this script is its **idempotency**. This means **you can run the script multiple times without causing errors or creating duplicate data.** Each time it runs, it will result in the exact same, clean set of data in the database.

This is achieved through the "Clean Slate" approach.

### 2. The "Clean Slate" Approach

The script begins with a series of `DELETE FROM ...` statements. This ensures that any pre-existing data is completely wiped from the tables before the new data is inserted.

Crucially, the `DELETE` statements are ordered in the **reverse of their dependency**. This is to avoid violating foreign key constraints. For example:

- `Payment` data is deleted before `Booking` data, because a payment belongs to a booking.
- `Booking` data is deleted before `Property` and `User` data, because a booking belongs to a property and a user.
- The `User` table, which is the "parent" of most other tables, is cleaned last.

### 3. Predictable, Static IDs

Instead of letting the database generate random UUIDs for primary keys, this script uses hard-coded, static UUIDs. This is extremely valuable for a development and testing environment for several reasons:

- **Consistency:** "Alice the host" will _always_ have the same `user_id` (`f47ac10b...`) every time the database is seeded.
- **Easier Testing:** You can write automated tests or API queries that rely on these known IDs without having to look them up first.
- **Clear Relationships:** It's easy to trace the relationships between tables by simply looking at the UUIDs in the script.

## How to Use This Script

### Prerequisites

1.  You must have a running PostgreSQL server.
2.  You must have already run the `schema.sql` script to create the necessary tables, types, and constraints.

### Instructions

1.  Connect to your target database using a PostgreSQL client like `psql`.

    ```bash
    # Example using the user 'sam' and database 'airbnb'
    psql -d airbnb -U sam
    ```

2.  From within the `psql` shell, execute this seed script using the `\i` command. You will need to provide the correct path to the file.
    ```sql
    -- Example from inside psql:
    \i /path/to/your/seeds.sql
    ```

After the script finishes, your database will be populated with the sample data. You can re-run this command at any time to reset the data to its initial state.

## Overview of Sample Data

The script creates a small but logical set of interconnected data to simulate a real-world scenario:

- **Users:** 2 hosts, 2 guests.
- **Properties:** 2 properties, one owned by each host.
- **Bookings:** 1 `confirmed` booking and 1 `pending` booking.
- **Payments:** 1 payment record linked to the `confirmed` booking.
- **Reviews:** 1 review linked to a completed stay.
- **Messages:** 1 message from a guest to a host.
