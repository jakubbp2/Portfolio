
-- 1. RECORD COUNTS


SELECT COUNT(*) AS customer_count
FROM customers;

SELECT COUNT(*) AS account_count
FROM accounts;

SELECT COUNT(*) AS transaction_count
FROM transactions;

SELECT COUNT(*) AS loan_count
FROM loans;

SELECT COUNT(*) AS credit_card_count
FROM credit_cards;

SELECT COUNT(*) AS feedback_count
FROM customer_feedback;


-- 2. NULL VALUE CHECK


SELECT
    COUNT(*) FILTER (WHERE first_name IS NULL) AS missing_first_name,
    COUNT(*) FILTER (WHERE last_name IS NULL) AS missing_last_name,
    COUNT(*) FILTER (WHERE age IS NULL) AS missing_age,
    COUNT(*) FILTER (WHERE gender IS NULL) AS missing_gender,
    COUNT(*) FILTER (WHERE city IS NULL) AS missing_city
FROM customers;



-- 3. DUPLICATE CHECK


SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;



-- 4. INVALID AGE CHECK


SELECT *
FROM customers
WHERE age < 18
   OR age > 120;



-- 5. NEGATIVE BALANCE CHECK


SELECT *
FROM accounts
WHERE account_balance < 0;



-- 6. INVALID TRANSACTION AMOUNT CHECK


SELECT *
FROM transactions
WHERE transaction_amount <= 0;



-- 7. FOREIGN KEY VALIDATION


SELECT a.*
FROM accounts a
LEFT JOIN customers c
    ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;