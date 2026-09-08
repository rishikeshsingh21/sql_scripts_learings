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