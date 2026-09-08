USE MyDatabase;


--Retrive All Customer Data
SELECT *
FROM customers;

--Retrive All Order Data 
SELECT *
FROM orders;

--Retrieve each customers's name, country and score
SELECT 
	first_name AS name,
	country,
	score
FROM customers;

--Retrieve customers with a score not equal to 0
SELECT *
FROM customers
WHERE score <> 0;

SELECT *
FROM customers
WHERE score != 0;

--Retrieve cusotmers from Germany
SELECT 
	first_name AS name,
	country
FROM customers 
WHERE country = 'Germany';

--Retrieve all cusotmers and sort the result by the highest score first 
SELECT *
FROM customers
ORDER BY score DESC;

--Retrieve all customers and sort the results by the lowest score first 
SELECT *
FROM customers
ORDER BY score ASC;

--Retrieve all customers and sort the results by the country and then by the highest score
SELECT *
FROM customers
ORDER BY country ASC,
		score DESC;

--Find the total score for each country 

SELECT 
	country,
	SUM(score) AS score_by_country
FROM customers
GROUP BY country;

--Find the total score and total number of customers for each country
SELECT 
	country,
	SUM(score) AS score_by_country,
	COUNT(*) AS total_cust
FROM customers
GROUP BY country;

/*
	Find the average score for each country considering only customers with a score not equal
	to 0 and return only those countries with an average score greater than 430
*/

SELECT 
	country,
	AVG(score) AS avg_score
FROM customers
WHERE score <> 0
GROUP BY country
HAVING AVG(score) > 430;

--Return Unique list of all countries 

SELECT DISTINCT
	country
FROM customers

-- Retrieve only 3 Customers
SELECT TOP 3 *
FROM customers;

-- Retrieve the top 3 Customers with the highest Score
SELECT TOP 3 *
FROM customers
ORDER BY score DESC;

-- Retrieve the lowest 2 customers based on the score
SELECT TOP 2 *
FROM customers
ORDER BY score ASC;

-- Get the two most recent orders
SELECT TOP 2 * 
FROM orders
ORDER BY order_date DESC;