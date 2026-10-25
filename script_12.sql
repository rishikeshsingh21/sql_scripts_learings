--Find the running total of sales for each month 

IF OBJECT_ID('Sales.V_Montly_Summary','V') IS NOT NULL
	DROP VIEW Sales.V_Montly_Summary;
GO
CREATE VIEW Sales.V_Montly_Summary AS
(
	SELECT 
		DATETRUNC(MONTH, OrderDate) AS OrderMonth,
		SUM(Sales) AS monthly_sales,
		COUNT(OrderID) AS total_orders,
		SUM(Quantity) AS total_quantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(MONTH, OrderDate)
)

SELECT 
	OrderMonth,
	monthly_sales,
	total_orders,
	total_quantities,
	SUM(monthly_sales) OVER(ORDER BY monthly_sales) AS running_total
FROM V_Montly_Summary

DROP VIEW V_Montly_Summary;

--TASK: Provide view that combines details from orders, products customers, and employees 


IF OBJECT_ID('Sales.V_Order_Summary','V') IS NOT NULL
	DROP VIEW Sales.V_Order_Summary;
GO
CREATE VIEW Sales.V_Order_Summary AS (
	SELECT 
		o.OrderID,
		COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS customer_name,
		COALESCE(E.FirstName,'') + ' ' + COALESCE(E.LastName,'') AS salesperson_name,
		p.Product,
		p.Category,
		o.OrderStatus,
		c.Country AS customer_country,
		o.OrderDate,
		o.Quantity,
		o.Sales,
		p.Price
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON o.ProductID = p.ProductID
	LEFT JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	LEFT JOIN Sales.Employees e
	ON o.SalesPersonID = e.EmployeeID
)

SELECT *
FROM Sales.Employees


SELECT *
FROM Sales.Products

SELECT *
FROM Sales.Customers

SELECT *
FROM Sales.V_Order_Summary

--Provide a view for EU Sales team
--That combines detasils from all tables
--And excludes data related to the USA


IF OBJECT_ID('Sales.V_Order_Summary_EU','V') IS NOT NULL
	DROP VIEW Sales.V_Order_Summary_EU;
GO
CREATE VIEW Sales.V_Order_Summary_EU AS (
	SELECT 
		o.OrderID,
		COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') AS customer_name,
		COALESCE(E.FirstName,'') + ' ' + COALESCE(E.LastName,'') AS salesperson_name,
		p.Product,
		p.Category,
		o.OrderStatus,
		c.Country AS customer_country,
		o.OrderDate,
		o.Quantity,
		o.Sales,
		p.Price
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON o.ProductID = p.ProductID
	LEFT JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	LEFT JOIN Sales.Employees e
	ON o.SalesPersonID = e.EmployeeID
	WHERE c.Country != 'USA'
)


SELECT *
FROM Sales.V_Order_Summary_EU;