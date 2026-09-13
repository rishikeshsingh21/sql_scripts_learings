USE MyDatabase;
--Retrieve all data from customers and orders as separate results 
SELECT *
FROM customers;

SELECT *
FROM orders;

--Get all customers along with their orders, but only for customers who have placed an order
SELECT
	c.id,
	c.first_name,
	c.country,
	c.score,
	o.order_id,
	o.order_date,
	o.sales
FROM customers c
INNER JOIN orders o
ON c.id = o.customer_id;

/*
Get all customers along with their orders,
including those without orders
*/
SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	o.order_id,
	o.order_date,
	o.sales
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id;

/*
Get all customers along with their orders, including
orders without mactching customers.
*/

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	o.order_id,
	o.order_date,
	o.sales
FROM customers c 
RIGHT JOIN orders o
ON c.id = o.customer_id;

/* 
Get all customers along with their orders ,
including orders without matching customers
(using left join)
*/

SELECT 
	o.order_id,
	o.order_date,
	o.sales,
	c.first_name,
	c.country,
	c.score
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.id

/*
Get all cusotmers and all orders, even if there's no match.
*/

SELECT	
	c.*,
	o.*
FROM customers c
FULL JOIN orders o
ON c.id = o.customer_id;

--Get all customers who haven't placed any order
SELECT 
	c.*
	--o.*
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL;


--Get all orders without matching customers
SELECT 
	c.*,
	o.*
FROM customers c
RIGHT JOIN orders o
ON c.id = o.customer_id
WHERE c.id IS NULL;

--Get all orders without matching customers (USING LEFT JOIN)
SELECT 
	o.*,
	c.*
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.id
WHERE c.id IS NULL

--Find customers without orders,
-- and orders without customers
SELECT *
FROM customers c
FULL JOIN orders o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL OR 
		c.id IS NULL;

/*
Get all customers along with their orders,
but only for customers who have placed an order (WITHOUT USING INNER JOIN)
*/

SELECT 
	c.id,
	c.first_name,
	c.country,
	c.score,
	o.order_id,
	o.order_date,
	o.sales
FROM customers c
LEFT JOIN orders o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;

--Generate all the possible combination of customers and orders

SELECT 
	c.*,
	o.*
FROM customers c
CROSS JOIN orders o;

/*
Using SalesDB, Retrieve a list of all orders, along with the related 
customer, product, and employee details.
For each order, display:
-Order ID
-Cutomer's name
-Product name
-Sales amount
-Product price
-Salesperson's name
*/
USE SalesDB;
SELECT 
	so.OrderID,
	TRIM(COALESCE(sc.FirstName,'') + ' ' + COALESCE(sc.LastName,'')) AS cust_name,
	sp.Product AS product_name,
	COALESCE(so.Quantity,0) * COALESCE(so.Sales,0) AS sales_amount,
	sp.Price AS product_price,
	TRIM(COALESCE(se.FirstName,'') + ' ' + COALESCE(se.LastName,'')) AS salesperson_name
FROM Sales.Orders so
LEFT JOIN Sales.Customers sc
ON so.CustomerID = sc.CustomerID
LEFT JOIN Sales.Products sp
ON so.ProductID = sp.ProductID 
LEFT JOIN Sales.Employees se
ON so.SalesPersonID	 = se.EmployeeID


/*
Combine the data from employee and customers into one table
*/

SELECT 
	FirstName,
	LastName
FROM Sales.Customers
UNION 
SELECT 
	FirstName,
	LastName
FROM Sales.Employees;

/*
Combine the data from employees and customers into one table,
including duplicates
*/
SELECT 
	FirstName,
	LastName
FROM Sales.Employees
UNION ALL
SELECT 
	FirstName,
	LastName
FROM Sales.Customers;

--Find employees who are not customers at the same time 

SELECT 
	FirstName,
	LastName
FROM Sales.Employees
EXCEPT 
SELECT 
	FirstName,
	LastName
FROM Sales.Customers

--Find the Employees, who are also customers
SELECT 
	FirstName,
	LastName
FROM Sales.Employees
INTERSECT
SELECT 
	FirstName,
	LastName
FROM Sales.Customers;

/*
Orders are stored in separate tables (Orders and OrdersArchive).
Combine all orders into one report without duplicates
*/

SELECT 
	   [OrderID]
	  ,'orders' AS source
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders o
UNION
SELECT 
	   [OrderID]
	  ,'orderArchives' AS source
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive oa
ORDER BY o.OrderID;