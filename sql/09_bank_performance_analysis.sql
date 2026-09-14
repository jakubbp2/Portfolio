--1. JAKI JEST MIESIĘCZNY WOLUMEN TRANSAKCJI I JAK ZMIENIAŁ SIĘ W CZASIE?
SELECT DATE_TRUNC('month', transaction_date) AS month,
SUM(transaction_amount) AS transaction_volume
FROM transactions GROUP BY month ORDER BY month;


--2. KTORE MIASTA GENERUJA NAJWIEKSZY WOLUMEN TRANSAKCJI?

SELECT customers.city, SUM(transactions.transaction_amount) AS 
transactions_volume FROM customers JOIN accounts
ON customers.customer_id = accounts.customer_id 
JOIN transactions ON accounts.account_id = transactions.account_id
GROUP BY 1 ORDER BY transactions_volume DESC;


--3. KTÓRY TYP KONTA POSIADA NAJWIĘKSZA LICZBA KLIENTÓW?

SELECT
account_type,
COUNT(DISTINCT customer_id) AS customers_count
FROM accounts
GROUP BY account_type
ORDER BY customers_count DESC;


--4. JAKI PROCENT KLIENTÓW JEST AKTYWNY? (aktywny klient = przynajmniej 1 transakcja)

SELECT ROUND(
COUNT(DISTINCT a.customer_id)*100.0/(SELECT COUNT(*) FROM customers),
2) AS active_customes_percentage FROM accounts a
JOIN transactions t ON a.account_id = t.account_id;


--5. KTÓRE GRUPY WIEKOWE GENERUJĄ NAJWIĘKSZY WOLUMEN TRANSAKCJI?

SELECT
    CASE
        WHEN c.age >= 18 AND c.age < 45 THEN '18-44'
        WHEN c.age >= 45 AND c.age <= 66 THEN '45-66'
        WHEN c.age > 66 THEN '66+'
    END AS age_group,
SUM(t.transaction_amount) as transaction_volume
FROM customers c JOIN accounts a ON c.customer_id =a.customer_id
JOIN transactions t ON a.account_id = t.account_id
GROUP BY age_group
ORDER BY transaction_volume DESC;

--6. JAKI JEST ŚREDNI POZIOM WYKORZYSTANIA LIMITU KART KREDYTOWYCH? I 
-- ILU KLIENTÓW WYKORZYSTUJE PONAD 80% LIMITU?

SELECT ROUND(AVG(credit_card_balance / NULLIF(credit_limit, 0))
 * 100, 2) AS avg_limit_usage,
COUNT(DISTINCT customer_id) FILTER (
WHERE credit_card_balance / NULLIF(credit_limit, 0) > 0.80
) AS customers_over_80_perc FROM credit_cards;

--7. JAKI JEST STOSUNEK WARTOŚCI KREDYTÓW ZAAKCEPTOWANYCH DO ODRZUCONYCH?

SELECT loan_Status, SUM(loan_amount) as total_loan_value
FROM loans WHERE loan_status IN('Approved','Rejected')
GROUP BY loan_status;

--8. JAKI PROCENT WSZYSTKICH TRANSAKCJI STANOWIĄ ANOMALIE I JAKA JEST ICH ŁĄCZNA WARTOŚĆ?
SELECT ROUND(
COUNT(*) FILTER (WHERE anomaly = 'true') * 100.0/COUNT(*),2
) AS anomaly_percentage, SUM(transaction_amount) FILTER(WHERE anomaly = 'true')
as anomaly_transaction_amount FROM transactions;

--9. KTÓRZY KLIENCI SĄ NAJBARDZIEJ „WARTOŚCIOWI” DLA BANKU?

SELECT c.customer_id, 1 + CASE
	WHEN l.customer_id IS NOT NULL THEN 1
	ELSE 0
END +
CASE
	WHEN cc.customer_id IS NOT NULL THEN 1
	ELSE 0
END +1 AS product_score
FROM customers c
LEFT JOIN(SELECT DISTINCT customer_id FROM loans
WHERE loan_status= 'Approved') l 
ON c.customer_id =l.customer_id LEFT JOIN
(SELECT DISTINCT customer_id FROM credit_cards) cc
ON c.customer_id=cc.customer_id
ORDER BY product_score DESC;

--           WNIOSKI
-- 1. 100% klientów w analizowanym zbiorze wykonało co najmniej jedną transakcję.

-- 2. Klienci w wieku 18–44 lat generują prawie 5,5× większy wolumen transakcji niż klienci w wieku 66+.

-- 3. 18% klientów wykorzystuje ponad 80% dostępnego limitu swoich kart kredytowych.

-- 4. Kredyty o łącznej wartości ponad 4 mln zostały odrzucone, co stanowi około 20% wartości analizowanych
-- wniosków kredytowych.

-- 5. Anomalie stanowiły 2,9% wszystkich analizowanych transakcji.
