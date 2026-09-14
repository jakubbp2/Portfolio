--1 ILE JEST TRANSAKCJI OZNACZONYCH JAKO ANOMALIE

SELECT COUNT(transaction_id) FROM transactions WHERE
anomaly = 'true';

--2. JAKI PROCENT WSZYSTKICH TRANSAKCJI STANOWIA ANOMALIE 

SELECT ROUND(
COUNT(*) FILTER (WHERE anomaly = 'true') * 100.0/COUNT(*),2
) AS anomaly_percentage FROM transactions;


--3. ŁĄCZNA WARTOSC TRANSAKCJI OZNACZONYCH JAKO ANOMALIE

SELECT SUM(transaction_amount) FROM transactions WHERE
anomaly = 'true';

--4. KTORE TYPY TRANSAKCJI NAJCZESCIEJ SA OZNACZANE JAKO ANOMALIE

SELECT transaction_type, COUNT(transaction_ID) as anomaly_amount FROM transactions WHERE
anomaly = 'true' GROUP BY transaction_type ORDER BY anomaly_amount DESC;

--5. KTORE KONTA MAJA NAJWIECEJ TRANSAKCJI OZNACZONYCH JAKO ANOMALIE

SELECT account_id, count(transaction_id) as anomaly_count FROM transactions
WHERE anomaly = 'true' GROUP BY account_id ORDER BY anomaly_count DESC LIMIT 5;


--6. KTORE KONTA WYGENEROWALY NAJWIEKSZA WARTOSC TRANSAKCJI OZNACZONYCH JAKO ANOMALIE

SELECT account_id, SUM(transaction_amount) as anomaly_balance FROM transactions
WHERE anomaly = 'true' GROUP BY account_id ORDER BY anomaly_balance DESC LIMIT 20;

--7. CZY TRANSAKCJE OZNACZONE JAKO ANOMALIE MAJA WIEKSZA SREDNIA WARTOSC NIZ NORMALNE TRANSAKCJE
SELECT CASE WHEN AVG(CASE
	 WHEN anomaly = 'true' THEN transaction_amount
END) > AVG(CASE WHEN anomaly = 'false' THEN
transaction_amount END) THEN 'YES' ELSE 'NO'
END AS anomalies_have_higher_average
FROM transactions;

--8. KTORE TRANSAKCJE ONZACZONE JAKO ANOMALIE MIALY ZNACZNIE WYZSZA WARTOSC OD SREDNIEJ WARTOSCI TRANSAKCJI KLIENTA

WITH avg_customer AS (
SELECT a.customer_id, AVG(t.transaction_amount) AS avg_transaction
FROM transactions t JOIN accounts a ON t.account_id = a.account_id
GROUP BY a.customer_id
)

SELECT t.transaction_id, a.customer_id, t.transaction_amount FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN avg_customer ac ON a.customer_id = ac.customer_id
WHERE t.anomaly = 'true'
 AND t.transaction_amount > ac.avg_transaction * 2;