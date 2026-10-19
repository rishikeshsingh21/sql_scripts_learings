--Find the products that have a price higher than the average price of all products.

SELECT 
	*
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

--Rank customers based on their total amount of sales

SELECT
	CustomerID,
	cust_sls,
	RANK() OVER(ORDER BY cust_sls DESC) AS cust_rank
FROM(
	SELECT 
		CustomerID,
		SUM(Sales) AS cust_sls
	FROM Sales.Orders
	GROUP BY CustomerID
)T

--Show the product Ids, product names, prices, and the total number of orders

SELECT 
	ProductID,
	Product AS product_name,
	Price,
	(SELECT COUNT(ProductID) FROM Sales.Products ) AS total_product
FROM Sales.Products

--Show all customer details and find the total orders for each customer.

SELECT 
	sc.CustomerID,
	sc.FirstName,
	sc.LastName,
	sc.Country,
	sc.Score,
	T.ttl_orders
FROM Sales.Customers AS sc
LEFT JOIN( 
	SELECT 
		CustomerID,
		COUNT(*) AS ttl_orders
	FROM Sales.Orders
	GROUP BY CustomerID
)T
ON T.CustomerID = sc.CustomerID

--Find the products that have a price higher than the average price of all products

SELECT 
	*,
	(SELECT AVG(Price) FROM Sales.Products) AS avg_price
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

--Show the details of the orders made by customer's in Germany.

SELECT 
	*
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany')

--Show the details of orders for customers who are not from Germany

SELECT *
FROM Sales.Orders
WHERE CustomerID NOT IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany')

--Find female employees whose salaries are greater than the salaries of any male employees

SELECT *
FROM Sales.Employees
WHERE Gender = 'F' AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

--Find female employees whose salaries are greater than the salaries of all male employees

SELECT *
FROM Sales.Employees 
WHERE Gender = 'F' AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

--Show all customer details and find the total orders for each customer

SELECT 
	*,
	(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) AS ttl_orders
FROM Sales.Customers c


--Show the details of orders made by cusotmers in Germany

SELECT *
FROM Sales.Orders o
WHERE EXISTS (
	SELECT 1
	FROM Sales.Customers c
	WHERE Country = 'Germany' AND c.CustomerID = o.CustomerID
)
