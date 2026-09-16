USE SalesDB;

--Concatenate first name and country into one column 

SELECT 
	*,
	CONCAT(FirstName,' -> ',Country) AS name_cntry
FROM Sales.Customers;

--Transform the customer's first name to lowercase
SELECT 
	LOWER(FirstName) AS name,
	Country,
	Score,
	Email
FROM Sales.Customers

--Transform the customer's first name to UPPERCASE
SELECT 
	UPPER(FirstName) AS name,
	Country,
	Email,
	Score
FROM Sales.Customers

--Find customers whose first name contains leading or trailing spaces
USE MyDatabase;
SELECT 
	first_name,
	country,
	score,
	TRIM(first_name) AS trim_name,
	LEN(first_name) AS name_len,
	LEN(TRIM(first_name)) AS name_len_after_trim,
	LEN(first_name) - LEN(TRIM(first_name)) AS flag
FROM customers
WHERE TRIM(first_name) != first_name;

-- Remove dashes (-) from a phone number

SELECT 
	'123-456-7890',
	REPLACE('123-456-7890','-','');

-- Replace File Extence from txt to csv

SELECT 
	'report.txt' AS old_filename,
	REPLACE('report.txt','.txt','.csv') AS new_filename;


--Calculate the length of each customer's first name

SELECT 
	*,
	LEN(first_name) AS len_name
FROM customers;

SELECT LEN(123456);

--Retrieve the first two characters of each first name
SELECT 
	*,
	LEFT(TRIM(first_name),2) AS two_char_fn
FROM customers;

--Retrieve the last two character of each first name
SELECT 
	*,
	RIGHT(TRIM(first_name),2) AS lst_two_char
FROM customers;

--After the 2nd character extract 2 characters
SELECT 
	*,
	SUBSTRING(TRIM(first_name),3,2) AS sbs_chr
FROM customers;

--After the 2nd character extract all characters 
SELECT 
	*,
	SUBSTRING(TRIM(first_name),3,LEN(first_name)) AS sbs_char
FROM customers;

SELECT 
3.516,
ROUND(3.516,2) AS round_2,
ROUND(3.516,1) AS round_1,
ROUND(3.516,0) AS round_0,
ROUND(3.157,2,1) AS round_3,
CAST(ROUND(3.157,2,1) AS DECIMAL(4,2)) AS int_val;

