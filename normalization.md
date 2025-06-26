# Normalization Analysis to Third Normal Form (3NF)

The database schema, as specified and represented in the second diagram, is already in **Third Normal Form (3NF)**. No further normalization steps are necessary.

Here is the formal proof:

### Step 1: First Normal Form (1NF)

- **Rule**: All table columns must contain atomic (indivisible) values, and each record must be unique (enforced by a primary key).
- **Analysis**: Each column in every table is defined to hold a single value (e.g., `first_name` is a single string, `rating` is a single integer). There are no repeating groups or multi-valued attributes. All tables have a primary key.
- **Conclusion**: The schema is in **1NF**.

### Step 2: Second Normal Form (2NF)

- **Rule**: The schema must be in 1NF, and all non-key attributes must be fully dependent on the entire primary key. This rule primarily addresses tables with composite primary keys.
- **Analysis**: All tables in this schema use a single attribute as the primary key (e.g., `user_id`, `property_id`). When the primary key is a single column, there can be no partial dependencies by definition. All other attributes in a table are functionally dependent on that single primary key.
- **Conclusion**: The schema is in **2NF**.

### Step 3: Third Normal Form (3NF)

- **Rule**: The schema must be in 2NF, and there must be no transitive dependencies (i.e., no non-key attribute should be dependent on another non-key attribute).
- **Analysis**: We examine each table for transitive dependencies:
  - **User**: Attributes like `first_name`, `email`, and `role` depend only on `user_id`, not on each other.
  - **Property**: `name`, `location`, and `pricepernight` depend only on `property_id`.
  - **Booking**: `start_date` and `status` depend only on `booking_id`. The `total_price` attribute is a calculated value based on `pricepernight` and dates. Storing it is a deliberate design choice for historical accuracy and performance. It is not a transitive dependency because it doesn't depend on another non-key attribute _within the Booking table_.
  - **Payment, Review, Message**: In each of these tables, the non-key attributes (`amount`, `rating`, `message_body`, etc.) depend directly on their respective primary keys (`payment_id`, `review_id`, `message_id`).
- **Conclusion**: The schema contains no transitive dependencies and is therefore in **3NF**.
