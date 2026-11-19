# Database Schema Description

## Plans Table

The plans table stores information about all available subscription plans.

| Column | Data Type | Description |
|----------|------------|-------------|
| plan_id | Integer | Unique plan identifier |
| plan_name | Varchar | Plan name |
| price | Decimal | Subscription price |

---

## Subscriptions Table

The subscriptions table records customer subscription activity.

| Column | Data Type | Description |
|----------|------------|-------------|
| customer_id | Integer | Customer identifier |
| plan_id | Integer | Selected plan |
| start_date | Date | Plan starting date |

---

## Relationship

One plan can belong to many subscriptions.

Relationship:

Plans (1) -----> (Many) Subscriptions

plan_id is the primary key in Plans and a foreign key in Subscriptions.