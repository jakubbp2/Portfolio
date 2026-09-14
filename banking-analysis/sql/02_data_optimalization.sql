--INDEXING USED TO OPTIMALIZE DATA

CREATE INDEX idx_accounts_customer_id
ON accounts(customer_id);

CREATE INDEX idx_transactions_account_id
ON transactions(account_id);

CREATE INDEX idx_transactions_date
ON transactions(transaction_date);

CREATE INDEX idx_loans_customer_id
ON loans(customer_id);

CREATE INDEX idx_credit_cards_customer_id
ON credit_cards(customer_id);

CREATE INDEX idx_feedback_customer_id
ON customer_feedback(customer_id);