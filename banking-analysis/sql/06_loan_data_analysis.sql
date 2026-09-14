--1 LICZBA UDZIELONYCH KREDYTOW ZE WZGLEDU NA TYP

SELECT loan_type, COUNT( loan_type) as amount_of_types 
FROM loans GROUP BY loan_type;

--2. ŁĄCZNA WARTOSC UDZIELONYCH KREDYTOW WEDLUG TYPU.

SELECT loan_type, SUM(loan_amount) 
FROM loans WHERE loan_status = 'Approved' group by loan_type;

-- 3. SREDNIA KWOTA KREDYTU WEDLUG TYPU KREDYTU (zatwierdzonych)

SELECT loan_type, avg(loan_amount) 
FROM loans WHERE loan_status = 'Approved' group by loan_type;

-- 4. JAKI PROCENT KREDYTOW ZAAKCEPTOWANO I JAKI ODRZUCONO

SELECT loan_status, COUNT(*) AS loan_count, ROUND(
COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2
) AS percentage FROM loans
WHERE loan_status IN('Approved','Rejected')
GROUP BY loan_status ORDER BY percentage DESC;

--5. KTORZY KLIENCI MAJA NAJWIEKSZA ŁĄCZNĄ WARTOSC KREDYTOW

SELECT customer_id, SUM(loan_amount) as loan_sum FROM loans WHERE loan_status = 'Approved' 
GROUP BY customer_id ORDER BY loan_sum DESC;

--6. SREDNI POZIOM OPROCENTOWANIA WEDLUG TYPU KREDYTU

SELECT loan_type, AVG(interest_rate)::DECIMAL(20,2) as avg_interest_rate FROM loans 
GROUP BY loan_type;

-- 7. KTORE TYPY KREDYTOW MAJA NAJWIEKSZY SREDNI OKRES SPLATY

SELECT loan_type, AVG(loan_term)::DECIMAL(30,2) as avg_loan_term FROM loans
GROUP BY loan_type ORDER BY avg_loan_term DESC;

-- 8. KTORZY KLIENCI POSIADAJA WIECEJ NIZ JEDEN KREDYT

SELECT customer_id, COUNT(loan_id) as amount_of_loans FROM loans GROUP BY customer_id
HAVING COUNT(loan_id) >1 ORDER BY amount_of_loans ;

-- 9. KTORZY KLIENCI MAJA JEDNOCZESNIE KARTE KREDYTOWA I KREDYT

SELECT DISTINCT loans.customer_id FROM loans
JOIN credit_cards ON loans.customer_id = credit_cards.customer_id
WHERE loans.loan_status = 'Approved';