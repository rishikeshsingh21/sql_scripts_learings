USE MyDatabase;

--Create a new table called persons with columns: 
-- id, person_name, birth_date, and phone;

IF OBJECT_ID('dbo.persons','U') IS NOT NULL
	DROP TABLE persons
GO
CREATE TABLE persons (
	id INT IDENTITY(1,1) NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(50) NOT NULL UNIQUE,
	CONSTRAINT pk_persons PRIMARY KEY (id)
)

-- Add a new column called email to the persons table

ALTER TABLE persons
ADD email VARCHAR(50);

-- Remove the column email form the persons table
ALTER TABLE persons
DROP COLUMN email;

--Delete the table persons from the database


DROP TABLE IF EXISTS persons;

SELECT *
FROM persons;

--DML

INSERT INTO persons (person_name, birth_date, phone)
VALUES ('Anna' , '10-11-2002','2020202020')

INSERT INTO customers (id, first_name, country, score)
VALUES (6, 'Anna', 'USA', NULL),
	(7, 'Sam', NULL, 100)

INSERT INTO customers (id, first_name, country, score)
VALUES (8, 'USA', 'USA', NULL)

INSERT INTO customers
VALUES (9, 'Andreas', 'Germany', NULL)

INSERT INTO customers (id, first_name)
VALUES (10, 'John')

SELECT *
FROM customers;

SELECT *
FROM persons;

--Copy data from 'customers' table into 'persons'

INSERT INTO persons (person_name, birth_date, phone)
SELECT 
	first_name,
	'2002-11-20',
	COALESCE(score,'909090')
FROM customers;

SELECT *
FROM sys.tables

SELECT *
FROM sys.objects
WHERE type = 'U';

-- Change the score of customer with ID 6 to 0 

UPDATE customers
SET score = 0 
WHERE id = 6;

SELECT *
FROM customers 
WHERE id = 6;

--Change the scoe of customer with ID 10 TO 0 and update the country to 'UK'

UPDATE customers
SET score = 0 ,
	country = 'UK'
WHERE id = 10;

SELECT *
FROM customers
WHERE ID = 10;

--Update all customers with a Null score by setting their score to 0;

UPDATE customers
SET score = 0
WHERE score IS NULL;


SELECT *
FROM customers;

-- Delete all customers with an ID greater than 5

DELETE FROM customers
WHERE id > 5;

SELECT *
FROM customers
WHERE id > 5;

SELECT *
FROM persons;

TRUNCATE TABLE persons;
USE MyDatabase;
SELECT * FROM persons;

ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL,
	city VARCHAR(50) NOT NULL,
	password VARCHAR(50) NOT NULL;