--1. ILU KLIENTOW POSIADA KARTE KREDYTOWA?

SELECT count(DISTINCT customer_id) AS customer_with_card FROM credit_cards;


--2. ILE JEST KART KAZDEGO TYPU?

SELECT card_type, count(card_id) FROM credit_cards
GROUP BY card_type;

--3. JAKI JEST SREDNI LIMIT KREDYTOWY WEDLUG TYPU KARTY?

SELECT card_type, avg(credit_limit)::DECIMAL(40,2) FROM credit_cards
GROUP BY card_type;

--4. JAKI JEST SREDNI POZIOM WYKORZYSTANIA LIMITU KARTY? (balance/limit)

SELECT (AVG(credit_card_balance / NULLIF(credit_limit, 0))*100)::DECIMAL(50,2) as avg_limit_usage
FROM credit_cards;

--5. KTORZY KLIENCI WYKORZYSTUJA NAJWIEKSZY PROCENT DOSTEPNEGO LIMITU?

SELECT customer_id, credit_card_balance,credit_limit, 
ROUND(
(credit_card_balance/NULLIF(credit_limit,0)*100)::numeric,2
) AS limit_used_percentage FROM credit_cards
ORDER BY limit_used_percentage DESC LIMIT 10;

--6. SREDNIA KWOTA MINIMALNEJ WYMAGANEJ SPŁATY WEDLUG TYPU KARTY

SELECT card_type ,AVG(minimum_payment_due)::DECIMAL(40,2) from credit_cards
GROUP BY card_type;

--7. KTORZY KLIENCI MAJA JEDNOCZESNIE WYSOKIE SALDO I KREDYT BANKOWY

SELECT cc.customer_id, cc.credit_card_balance FROM credit_cards cc
JOIN loans l ON cc.customer_id = l.customer_id WHERE 
cc.credit_card_balance/NULLIF(cc.credit_limit,0) > 0.80 ;


--8. NA KTORYM TYPIE KARTY ZNAJDUJE SIE NAJWIEKSZE ŁĄCZNE SALDO

SELECT card_type, sum(credit_card_balance) as sum_card_balance FROM credit_cards
group by card_type ORDER BY sum_card_balance DESC LIMIT 1;
