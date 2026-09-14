
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE public.accounts (
    account_id integer NOT NULL,
    customer_id integer NOT NULL,
    account_type character varying(30) NOT NULL,
    account_balance numeric(15,2) NOT NULL,
    date_of_account_opening date NOT NULL,
    last_transaction_date date,
    CONSTRAINT accounts_account_balance_check CHECK ((account_balance >= (0)::numeric))
);





CREATE TABLE public.credit_cards (
    card_id integer NOT NULL,
    customer_id integer NOT NULL,
    card_type character varying(50) NOT NULL,
    credit_limit numeric(15,2) NOT NULL,
    credit_card_balance numeric(15,2) NOT NULL,
    minimum_payment_due numeric(15,2),
    payment_due_date date,
    last_credit_card_payment_date date,
    rewards_points integer DEFAULT 0 NOT NULL,
    CONSTRAINT credit_cards_minimum_payment_due_check CHECK ((minimum_payment_due >= (0)::numeric)),
    CONSTRAINT credit_cards_rewards_points_check CHECK ((rewards_points >= 0))
);






CREATE TABLE public.customer_feedback (
    feedback_id integer NOT NULL,
    customer_id integer NOT NULL,
    feedback_date date NOT NULL,
    feedback_type character varying(100) NOT NULL,
    resolution_status character varying(50) NOT NULL,
    resolution_date date
);



CREATE TABLE public.customers (
    customer_id integer CONSTRAINT customer_customer_id_not_null NOT NULL,
    first_name character varying(30) CONSTRAINT customer_first_name_not_null NOT NULL,
    last_name character varying(30) CONSTRAINT customer_last_name_not_null NOT NULL,
    age integer CONSTRAINT customer_age_not_null NOT NULL,
    gender character varying(20) CONSTRAINT customer_gender_not_null NOT NULL,
    adress character varying(255),
    city character varying(100) CONSTRAINT customer_city_not_null NOT NULL,
    contact_number character varying(30),
    email character varying(60) CONSTRAINT customer_email_not_null NOT NULL
);



CREATE TABLE public.loans (
    loan_id integer NOT NULL,
    customer_id integer NOT NULL,
    loan_amount numeric(15,2) NOT NULL,
    loan_type character varying(50) NOT NULL,
    interest_rate numeric(5,2),
    loan_term integer,
    approval_rejection_date date,
    loan_status character varying(30) NOT NULL,
    CONSTRAINT loans_interest_rate_check CHECK ((interest_rate >= (0)::numeric)),
    CONSTRAINT loans_loan_amount_check CHECK ((loan_amount > (0)::numeric)),
    CONSTRAINT loans_loan_term_check CHECK ((loan_term > 0))
);



CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    account_id integer NOT NULL,
    transaction_date timestamp without time zone NOT NULL,
    transaction_type character varying(50) NOT NULL,
    transaction_amount numeric(15,2) NOT NULL,
    account_balance_after_transaction numeric(15,2),
    branch_id integer,
    anomaly boolean DEFAULT false NOT NULL,
    CONSTRAINT transactions_transaction_amount_check CHECK ((transaction_amount > (0)::numeric))
);





ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);

ALTER TABLE ONLY public.credit_cards
    ADD CONSTRAINT credit_cards_pkey PRIMARY KEY (card_id);




ALTER TABLE ONLY public.customer_feedback
    ADD CONSTRAINT customer_feedback_pkey PRIMARY KEY (feedback_id);




ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);




ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (loan_id);




ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);



CREATE INDEX idx_accounts_customer_id ON public.accounts USING btree (customer_id);


CREATE INDEX idx_credit_cards_customer_id ON public.credit_cards USING btree (customer_id);




CREATE INDEX idx_feedback_customer_id ON public.customer_feedback USING btree (customer_id);




CREATE INDEX idx_loans_customer_id ON public.loans USING btree (customer_id);




CREATE INDEX idx_transactions_account_id ON public.transactions USING btree (account_id);




CREATE INDEX idx_transactions_date ON public.transactions USING btree (transaction_date);




ALTER TABLE ONLY public.credit_cards
    ADD CONSTRAINT credit_cards_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);




ALTER TABLE ONLY public.customer_feedback
    ADD CONSTRAINT customer_feedback_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);




ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);




ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id);


