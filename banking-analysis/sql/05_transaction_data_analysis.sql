-- 1. JAKA JEST ŁĄCZNA WARTOŚĆ TRANSAKCJI W KAŻDYM MIESIĄCU?

SELECT DATE_TRUNC('month', transaction_date) AS Month,
SUM(transaction_amount) AS total_volume FROM transactions
GROUP BY 1 ORDER BY 1;



--2. KTÓRZY KLIENCI WYKAZUJĄ NAJWIĘKSZĄ AKTYWNOŚĆ TRANSAKCYJNĄ (TOP 10)?

SELECT customers.customer_id, COUNT(transactions.account_id) AS Number_of_transactions
FROM transactions JOIN accounts ON transactions.account_id = accounts.account_id 
JOIN customers ON accounts.customer_id = customers.customer_id 
GROUP BY customers.customer_id ORDER BY Number_of_transactions DESC LIMIT 10;



--3. KTÓRE MIASTA GENERUJĄ NAJWIĘKSZY WOLUMEN TRANSAKCJI?

SELECT customers.city, SUM(transactions.transaction_amount) AS 
transactions_volume FROM customers JOIN accounts
ON customers.customer_id = accounts.customer_id 
JOIN transactions ON accounts.account_id = transactions.account_id
GROUP BY 1 ORDER BY transactions_volume DESC;




--4. JAKIE TYPY TRANSAKCJI WYSTĘPUJĄ NAJCZĘŚCIEJ?

SELECT transaction_type, COUNT(transaction_type) as transaction_type_number
FROM transactions GROUP BY transaction_type 
ORDER BY transaction_type_number DESC;


--5. NA KTÓRYCH KONTACH ODNOTOWANO NAJWIĘKSZE ZMIANY SALDA?

SELECT account_id, SUM(transaction_amount) AS total_transaction_volume 
FROM transactions GROUP BY account_id ORDER BY total_transaction_volume 
DESC LIMIT 10;


--6. IDENTYFIKACJA KLIENTÓW, KTÓRYCH AKTYWNOŚĆ TRANSAKCYJNA ZNACZĄCO WZROSŁA W PORÓWNANIU Z POPRZEDNIM MIESIĄCEM.

WITH monthly_transactions AS (
SELECT customers.customer_id, DATE_TRUNC('month', transactions.transaction_date) AS month,
COUNT(transactions.transaction_id) AS transaction_count
FROM customers JOIN accounts ON customers.customer_id = accounts.customer_id
JOIN transactions ON accounts.account_id = transactions.account_id
GROUP BY customers.customer_id, DATE_TRUNC('month', transactions.transaction_date)
),

transaction_growth AS(
SELECT customer_id, month,transaction_count, LAG(transaction_count) OVER (
PARTITION BY customer_id ORDER BY month) AS previous_month_transactions FROM monthly_transactions
)

SELECT customer_id,month,transaction_count,previous_month_transactions, ROUND
(
( 
(transaction_count - previous_month_transactions)::NUMERIC/NULLIF(previous_month_transactions,0)

)*100,2

) AS growth_percentage FROM transaction_growth
WHERE transaction_count > previous_month_transactions ORDER BY
growth_percentage DESC;

--7. TRANSAKCJE KTÓRYCH WARTOŚĆ JEST ZNACZĄCO WYŻSZA OD ŚREDNIEJ WARTOŚCI TRANSAKCJI DANEGO KLIENTA.

WITH customer_transactions AS (
SELECT
   customers.customer_id,
   transactions.transaction_id,
   transactions.transaction_amount,
   
AVG(transactions.transaction_amount) OVER ( 
PARTITION BY customers.customer_id) AS average_customer_transaction
  FROM customers JOIN accounts  ON customers.customer_id = accounts.customer_id
  JOIN transactions ON accounts.account_id = transactions.account_id
)
SELECT *
FROM customer_transactions
WHERE transaction_amount > average_customer_transaction * 2
ORDER BY customer_id;

--8. ZNAJDYWANIE WIELU TRANSAKCJI WYKONANYCH W KRÓTKIM ODSTĘPIE CZASU (W ODSTEPIE 6 GODZIN).

WITH transaction_time_diff AS (
SELECT 
	account_id, transaction_id, transaction_date, transaction_amount,
	LAG(transaction_date) OVER (
		PARTITION BY account_id
		ORDER BY transaction_date
	) AS previous_transaction_date FROM transactions
)

SELECT *, transaction_date - previous_transaction_date AS time_diff
FROM transaction_time_diff WHERE transaction_date - previous_transaction_date
<= INTERVAL '6 hour'
ORDER BY account_id, transaction_date;


--9. SEGREGACJA KLIENTÓW WEDŁUG WOLUMENU TRANSAKCJI W OBRĘBIE KAŻDEGO MIASTA.

WITH customer_volume AS (
SELECT customers.city, customers.customer_id, customers.first_name, customers.last_name,
SUM(transactions.transaction_amount) AS transaction_volume
FROM customers JOIN accounts ON customers.customer_id = accounts.customer_id
JOIN transactions ON accounts.account_id = transactions.account_id
GROUP BY customers.city, customers.customer_id, customers.first_name, customers.last_name
)

SELECT * , RANK() OVER (
PARTITION BY city ORDER BY transaction_volume DESC
) AS customer_rank
from customer_volume;

--10. 7-DNIOWA ŚREDNIA KROCZĄCĄ WARTOŚCI WYDATKÓW Z TRANSAKCJI.

WITH daily_transaction AS (
SELECT transaction_date::DATE AS transaction_day,
SUM(transaction_amount) AS daily_volume FROM transactions G
GROUP BY transaction_date::DATE
)

SELECT transaction_day,daily_volume, AVG(daily_volume) OVER ( ORDER BY transaction_day ROWS BETWEEN  6
PRECEDING AND CURRENT ROW) AS seven_day_avg
FROM daily_transaction ORDER BY transaction_day;

--11. KLIENCI KTÓRYCH WYDATKI ROSŁY PRZEZ 3 KOLEJNE MIESIĄCE.

WITH monthly_spending AS (
SELECT customers.customer_id, DATE_TRUNC('month',transactions.transaction_date) AS month,
SUM(transactions.transaction_amount) AS monthly_spending
FROM customers JOIN accounts ON customers.customer_id = accounts.customer_id
JOIN transactions ON accounts.account_id = transactions.account_id
GROUP BY customers.customer_id, DATE_TRUNC('month',transactions.transaction_date)
),

spending_history AS(
SELECT *, LAG(monthly_spending,1) OVER(PARTITION BY customer_id ORDER BY month) AS previous_month,
LAG(monthly_spending,2) OVER(PARTITION BY customer_id ORDER BY MONTH)
AS two_months_before
FROM monthly_spending
)

SELECT * FROM spending_history WHERE monthly_spending > previous_month AND previous_month> two_months_before
;



