-- DATA CLEANING


-- 1. STANDARDIZE TEXT DATA


UPDATE customers
SET first_name = TRIM(first_name),
    last_name = TRIM(last_name),
    gender = TRIM(gender),
    city = TRIM(city);


-- 2. STANDARDIZE EMAIL ADDRESSES


UPDATE customers
SET email = LOWER(TRIM(email));



-- 3. REMOVE WHITESPACE FROM ACCOUNT TYPES


UPDATE accounts
SET account_type = TRIM(account_type);

-- 4. REMOVE WHITESPACE FROM TRANSACTION TYPES


UPDATE transactions
SET transaction_type = TRIM(transaction_type);



-- 5. REMOVE WHITESPACE FROM LOAN DATA


UPDATE loans
SET loan_type = TRIM(loan_type),
    loan_status = TRIM(loan_status);


-- 6. REMOVE WHITESPACE FROM CREDIT CARD DATA

UPDATE credit_cards
SET card_type = TRIM(card_type);


-- 7. REMOVE WHITESPACE FROM FEEDBACK DATA

UPDATE customer_feedback
SET feedback_type = TRIM(feedback_type),
    resolution_status = TRIM(resolution_status);