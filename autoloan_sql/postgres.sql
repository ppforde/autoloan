/*
This is written for postgresql
 
Right click on the Databases
 
Left click on New Database..
 
Name: auto_loan_db, Owner : postgres
 
Go to Tools >> Query tool 
 
Go to File >> Open 
 
Navigate to the autolaon.sql file
 
Highlight each STEP # and execute separately
*/
 
-- STEP #1 drop existing tables
DROP TABLE IF EXISTS auto_loan_tbl;
DROP TABLE IF EXISTS auto_rate_tbl;
DROP TABLE IF EXISTS auto_term_tbl;
 
-- STEP #2 create tables
 
CREATE TABLE auto_loan_tbl (
    loan integer,
    term integer,
    rate numeric,
    payment numeric,
    "date" timestamp
);
 
CREATE TABLE auto_rate_tbl (
    rate numeric primary key
);
 
CREATE TABLE auto_term_tbl (
    term integer primary key
);
 
-- STEP #3 insert values
 
INSERT INTO auto_rate_tbl VALUES (4.7);
INSERT INTO auto_rate_tbl VALUES (3.19);
INSERT INTO auto_rate_tbl VALUES (2.9);
 
 
INSERT INTO auto_term_tbl VALUES (12);
INSERT INTO auto_term_tbl VALUES (24);
INSERT INTO auto_term_tbl VALUES (36);
INSERT INTO auto_term_tbl VALUES (48);
INSERT INTO auto_term_tbl VALUES (60);
INSERT INTO auto_term_tbl VALUES (72);
 
-- STEP #4 check results
SELECT * FROM auto_rate_tbl;
SELECT max(rate) FROM auto_rate_tbl;
 
SELECT * FROM auto_term_tbl;
SELECT round(avg(term)) FROM auto_term_tbl;
 
-- STEP #5 setup function
DROP FUNCTION IF EXISTS auto_loan_func;
 
CREATE FUNCTION auto_loan_func(loan integer, term integer, interest numeric)
RETURNS numeric AS $$
BEGIN
RETURN ROUND((interest / 100 / 12) * loan / (1 - POWER(1 + (interest / 100 / 12), -term)),2);
END; $$
LANGUAGE PLPGSQL;
 
-- STEP #6 set up while/for loop execution
DELETE FROM auto_loan_tbl;
 
DO $$
DECLARE
   loans INTEGER := 25000;
   rates NUMERIC := (SELECT max(rate) FROM auto_rate_tbl);   
   date TIMESTAMP := NOW();
BEGIN
   WHILE loans < 30000 LOOP
           FOR terms IN 24..72 BY 12 LOOP
            INSERT INTO auto_loan_tbl
            VALUES (
                loans,
                terms,
                rates,
                auto_loan_func(loans,terms,rates),
                date
            );
        END LOOP;
        loans := loans + 1000; 
   END LOOP ; 
END $$
 
-- STEP #7 review records
SELECT *
FROM auto_loan_tbl;
