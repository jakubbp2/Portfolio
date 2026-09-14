# Banking Analytics

End-to-end banking analytics project built with **PostgreSQL, SQL, Power BI and DAX**.

The project analyzes customer behavior, transactions, loans, credit cards and transaction anomalies to identify patterns and generate business insights.

> **Note:** The dataset is fully synthetic and created for analytical purposes. It does not contain real customer data.

---

## Project Objective

Simulate a real-world banking analytics workflow:

**Raw Data → PostgreSQL → SQL Analysis → Power BI → Business Insights**

The project answers questions around:

* Customer and transaction activity
* Banking product usage
* Loan performance
* Credit card utilization
* Transaction anomalies
* Customer value

---

## Technologies

* **PostgreSQL** — database and data storage
* **SQL** — validation, transformation and analysis
* **Power BI** — dashboards and visualization
* **DAX** — measures and calculated columns
* **Git / GitHub** — version control

---

## Database Structure

```
customers
    ├── accounts
    │     └── transactions
    ├── loans
    ├── credit_cards
    └── customer_feedback
```

### Main Tables

**customers** — customer information, demographics and location.

**accounts** — account type, balance and account dates.

**transactions** — transaction type, amount, date, balance and anomaly flag.

**loans** — loan amount, type, interest rate, term and status.

**credit_cards** — card type, credit limit, balance and payments.

**customer_feedback** — feedback type and resolution status.

---

## SQL Analysis

The analysis covered:

### Customers

* Customer distribution by city
* Age segmentation
* Multiple accounts
* Account balances
* Customers without transactions

### Transactions

* Monthly transaction volume
* Transaction activity by customer and city
* Transaction types
* Unusual transaction values
* Short-interval transactions
* Customer activity trends
* Rolling averages

### Loans

* Loans by type
* Approved vs rejected loans
* Loan value
* Interest rates
* Loan terms
* Customers with multiple loans

### Credit Cards

* Cards by type
* Credit limits
* Credit utilization
* Customers using >80% of their limit

### Anomalies

* Anomaly frequency
* Anomaly value
* Anomalies by transaction type
* Accounts with the most anomalies
* Anomalous vs normal transaction values

---

## Power BI Dashboard

The dashboard contains four pages:

### 1. Bank Overview

High-level banking performance, transaction trends, customer activity and KPIs.

<img width="1315" height="739" alt="image" src="https://github.com/user-attachments/assets/40e7842e-35b8-4dee-8dfd-1b9e209d7583" />

### 2. Customers & Transactions

Customer distribution, transaction behavior, transaction types and top active customers.

<img width="1316" height="737" alt="image" src="https://github.com/user-attachments/assets/f0e176aa-57e8-4b59-9812-9cdc8ca11d93" />

### 3. Loans & Credit Cards

Loan performance, interest rates and credit card utilization.

<img width="1313" height="734" alt="image" src="https://github.com/user-attachments/assets/1d19167d-dec1-4577-a06b-b7241df9e17f" />

### 4. Risk & Anomalies

Transaction anomalies, anomaly trends, values and high-risk accounts.

<img width="1313" height="734" alt="image" src="https://github.com/user-attachments/assets/a24e884a-7b4a-46cb-b496-3d4beb819ebe" />

---

## Key Business Insights

* **100%** of customers performed at least one transaction.
* Customers aged **18–44 generate ~5.5× more transaction volume** than customers aged 66+.
* **18 customers** use more than 80% of their available credit limit.
* More than **22% of loan applications were rejected**.
* **2.9% of transactions** were flagged as anomalies, with an average value approximately **10× higher** than normal transactions.

---


## Project Structure

```text
banking-analytics/
│
├── README.md
├── sql/
├── data/
├── powerbi/
└── screenshots/
```
## Conclusion

This project demonstrates an end-to-end banking analytics workflow, from relational data in PostgreSQL to SQL analysis and an interactive Power BI dashboard.

The focus was on translating data into **business-relevant insights and potential actions**.
