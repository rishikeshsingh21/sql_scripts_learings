

--CTAS
IF OBJECT_ID('Sales.MontlyOrders','U') IS NOT NULL
	DROP TABLE Sales.MontlyOrders
GO
	SELECT 
		DATENAME(MONTH, OrderDate) OrderMonth,
		COUNT(OrderID) TotalOrders
	INTO Sales.MontlyOrders
	FROM Sales.Orders
	GROUP BY DATENAME(MONTH, OrderDate);

SELECT *
FROM Sales.MontlyOrders;

DROP TABLE Sales.MontlyOrders;

--Temporary tables 


SELECT 
	*
INTO #Orders
FROM Sales.Orders

DELETE FROM #Orders
WHERE OrderStatus = 'Delivered'

SELECT *
FROM #Orders;

SELECT
	*
INTO Sales.OrderTest
FROM #Orders


SELECT *
FROM Sales.OrderTest;


