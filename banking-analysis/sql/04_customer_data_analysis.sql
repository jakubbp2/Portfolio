-- 1. ILU JEST KLIENTÓW W KAZDYM MIESCIE?

SELECT COUNT(customer_id) as customers_count, city FROM customers
GROUP BY city ORDER BY customers_count DESC;

-- 2. JAKI JEST SREDNI WIEK KLIENTÓW?

SELECT AVG(age) AS avg_customer_age FROM customers;

-- 3. PODZIAŁ KLIENTÓW WEDŁUG GRUP WIEKOWYCH (18-45, 45-66 I 66+)

SELECT
    CASE
        WHEN age >= 18 AND age < 45 THEN '18-44'
        WHEN age >= 45 AND age <= 66 THEN '45-66'
        WHEN age > 66 THEN '66+'
    END AS age_group,
    COUNT(*) AS customers_count
FROM customers
GROUP BY age_group
ORDER BY age_group;


-- 4. KLIENCI KTORZY MAJA NAJWEICEJ KONT

SELECT customer_id, COUNT(accounts.account_id) AS accounts_count FROM accounts
GROUP BY customer_id ORDER BY accounts_count desc LIMIT 10;

-- 5. ILU KLIENTOW POSAIDA WIECEJ NIZ JEDNO KONTO?
SELECT COUNT(*) AS customers_with_multiple_accounts
FROM (
    SELECT
        customer_id
    FROM accounts
    GROUP BY customer_id
    HAVING COUNT(account_id) > 1
) AS customer_accounts;
-- 6. KTORZY KLIENCI MAJA NAJWIEKSZE LACZNIE SALDO?

SELECT customer_id, SUM(account_balance) as acc_balance FROM accounts
GROUP BY customer_id ORDER BY acc_balance DESC LIMIT 10;


-- 7. SEGMENTACJA KLIENTOW NA PODSTAWIE WARTOSCI SALDA

 WITH customer_balance AS (
    SELECT
        customer_id,
        SUM(account_balance) AS total_balance
    FROM accounts
    GROUP BY customer_id
),
customer_segments AS (
    SELECT
        customer_id,
        total_balance,
        CASE
            WHEN total_balance >= 100000 THEN 'High Value'
            WHEN total_balance >= 50000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_balance
)

SELECT
    customer_segment,
    COUNT(*) AS customers_count
FROM customer_segments
GROUP BY customer_segment
ORDER BY customers_count DESC;

-- 8. KLIENCI BEZ TRANSAKCJI.


SELECT DISTINCT accounts.customer_id FROM accounts LEFT JOIN transactions ON accounts.account_id = transactions.account_id
WHERE transactions.transaction_id IS NULL;

-- 9. JAKI PROCENT KLIENTOW KORZYSTA Z POSZCZEGOLNYCH TYPOW KONT

SELECT
account_type,
COUNT(DISTINCT customer_id) AS customers_count
FROM accounts
GROUP BY account_type
ORDER BY customers_count DESC;
