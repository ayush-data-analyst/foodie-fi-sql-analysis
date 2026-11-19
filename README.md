# Foodie-Fi SQL Case Study

## Project Overview

This project analyzes customer subscription behavior for Foodie-Fi, a subscription-based video streaming platform.

The objective is to understand customer acquisition, upgrades, churn behavior, and subscription plan transitions using SQL.

---

## Database Schema

The database contains two tables:

### Plans

| Column | Description |
|----------|-------------|
| plan_id | Unique plan identifier |
| plan_name | Subscription plan name |
| price | Plan price |

### Subscriptions

| Column | Description |
|----------|-------------|
| customer_id | Customer identifier |
| plan_id | Plan selected |
| start_date | Date subscription started |

---

## Skills Demonstrated

- SQL Joins
- Common Table Expressions (CTEs)
- Window Functions
- Aggregations
- Date Functions
- Business Analytics

---

## Business Questions Answered

1. Customer count analysis
2. Monthly trial distribution
3. Subscription activity after 2020
4. Churn analysis
5. Trial-to-churn behavior
6. Customer plan transitions
7. Plan distribution at year end
8. Annual plan upgrades
9. Average upgrade time
10. 30-day upgrade buckets
11. Downgrade analysis

---

## Key Insights

- Foodie-Fi served 1000 customers.
- 30.7% of customers churned.
- Basic Monthly was the most common plan after trial.
- Average upgrade time to Annual Plan was 105 days.
- No customers downgraded from Pro Monthly to Basic Monthly.

---

## Repository Structure

```text
foodie-fi-sql-analysis
|
|-- sql
|-- questions
|-- documentation
|-- images
```

---

## Author

Ayush Mishra

Aspiring Data Analyst