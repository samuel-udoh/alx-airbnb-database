# Database Design and Normalization Analysis for AirBnB

This document provides an analysis of the database design for an AirBnB-like application.

## Database Specification Overview

The design is based on the following entities and their attributes:

<details>
<summary>Click to view Full Database Specification</summary>

- **User**: Stores user information, including roles like guest, host, or admin.
- **Property**: Contains details about the rental properties, linked to a host (User).
- **Booking**: An associative entity linking a `User` and a `Property` for a specific duration.
- **Payment**: Records payment details for a specific `Booking`.
- **Review**: An associative entity allowing a `User` to post a rating and comment for a `Property`.
- **Message**: Stores messages sent between `Users`.

</details>

---

## 1. Conceptual Entity-Relationship (ER) Diagram Analysis

### Interpretation

- **Entities**: The diagram correctly identifies the core entities: `USER`, `PROPERTY`, `REVIEW`, `BOOKING`, `PAYMENT`, and `MESSAGE`. These are represented by rectangles.
- **Relationships**: Relationships are shown using diamonds (e.g., `REVIEWS`, `BOOKS`). This model attempts to show how entities interact:
  - A `USER` makes a `BOOKING` for a `PROPERTY`.
  - A `USER` writes a `REVIEW` for a `PROPERTY`.
  - A `BOOKING` leads to a `PAYMENT`.
  - `USERS` can send and receive `MESSAGES`.

## 2. Relational Schema Diagram Analysis

This diagram is a **Relational Schema**, which is a more detailed and physically accurate representation of the database tables. It uses Crow's Foot notation and is an excellent model for implementation.

### Key Relationships Shown

This schema correctly models all the required relationships:

- **User -> Property (Hosting)**: A one-to-many relationship where one `USER` can be the host of many `PROPERTIES`. This corrects the omission from the first diagram.
- **User/Property -> Booking**: A `BOOKING` is correctly linked to exactly one `USER` and one `PROPERTY`.
- **Booking -> Payment**: A one-to-one relationship is shown, where a `PAYMENT` must belong to one `BOOKING`, and a `BOOKING` can have zero or one `PAYMENTS`. This correctly models that a payment is made for a booking.
- **User/Property -> Review**: A `REVIEW` is correctly linked to the `USER` who wrote it and the `PROPERTY` it is about.
- **User -> Message (Sending/Receiving)**: The schema cleverly uses two separate relationships from `USER` to `MESSAGE` to represent the `sender_id` and `recipient_id`, correctly modeling the messaging functionality.
