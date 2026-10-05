-- Find the total number of orders
--Find the total sales of all orders 
--Find the average sales of all orders
--Find the highest sales of all orders
--Find the lowest sales of all orders

SELECT 
	CustomerID,
	COUNT(OrderID) AS ttl_orders,
	SUM(Sales) AS ttl_sales,
	AVG(Sales) AS avg_sales,
	MAX(Sales) AS highest_sales,
	MIN(Sales) AS lowest_sales
FROM Sales.Orders
GROUP BY CustomerID


--Find the total sales across all orders 

SELECT 
	SUM(Sales) AS ttl_sales
FROM Sales.Orders

--Find the total sales for each product 
SELECT 
	ProductID,
	SUM(Sales) AS sales_by_prd
FROM Sales.Orders
GROUP BY ProductID;

--Find the total sales for each product,
--additionally provide details such as order id & order date
SELECT 
	ProductID,
	OrderID,
	OrderDate,
	SUM(Sales) OVER(PARTITION BY ProductID) AS ttl_sales
FROM Sales.Orders


--Find the total sales across all orders 
--Additionally provide details such as order Id, order date

SELECT 
	OrderID,
	OrderDate,
	SUM(Sales) OVER() AS ttl_sales
FROM Sales.Orders;

--Find the total sales for each product,
--addtionally provide details such order id & order date,
--find total sales across all orders
--Find the total sales for each combination of product and order status
SELECT 
	OrderID,
	ProductID,
	OrderStatus,
	OrderDate,
	Sales,
	SUM(Sales) OVER(PARTITION BY ProductId) AS prd_sales,
	SUM(Sales) OVER() AS ttl_sales,
	SUM(Sales) OVER(PARTITION BY ProductId, OrderStatus) AS cross_ttl_sales
FROM Sales.Orders

--Rank each order based on their sales from highest to lowest 
--Additionally provide details such order id, order date

SELECT 
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) AS rank,
	DENSE_RANK() OVER(ORDER BY Sales DESC) AS rank,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) AS rank
FROM Sales.Orders


SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(ORDER BY Sales ASC, OrderDate ASC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_sum,
	SUM(Sales) OVER(ORDER BY Sales ASC, OrderDate ASC ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) AS preceding_1,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY Sales ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS up_uf_sum,
	SUM(Sales) OVER(ORDER BY Sales ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS following_1,
	SUM(Sales) OVER(ORDER BY Sales) AS default_frame
FROM Sales.Orders
ORDER BY Sales ASC;


SELECT 
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY Sales ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS preceding_2,
	SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY Sales ROWS 2 PRECEDING) AS sort_form,
	SUM(Sales) OVER(ORDER BY Sales) AS default_frame
FROM Sales.Orders;


--Window fn execute after where clause
--Find the total sales for each order status,
--only for two products 101 and 102

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus) AS product_ttl_sls
FROM Sales.Orders
WHERE ProductID IN (101,102)

--rank customers based on their total sales

SELECT 
	CustomerID,
	SUM(Sales) AS cust_sls,
	RANK() OVER(ORDER BY SUM(Sales) DESC) AS cust_rank 
FROM Sales.Orders
GROUP BY CustomerID
HAVING SUM(Sales) > 100

--Find the total number of Orders for each product
SELECT 
	ProductID,
	COUNT(OrderID) AS total_orders
FROM Sales.Orders
GROUP BY ProductID

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	COUNT(OrderID) OVER(PARTITION BY ProductID) AS total_orders
FROM Sales.Orders

--find the total number of ordres
--Find the total number of orders for each customers
--Addtitionally provide details such orderId, order date
SELECT
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(OrderID) OVER() AS total_orders,
	COUNT(OrderID) OVER(PARTITION BY CustomerID) AS ord_by_cust
FROM Sales.Orders

--Find the total number of Customers
--Find the total number of scores for the customers
--Additionally provide All customers Details

SELECT 
	*,
	COUNT(CustomerID) OVER() AS ttl_cust,
	COUNT(Score) OVER() AS ttl_scr
FROM Sales.Customers;


--Check whether the table 'orders' contains any duplicate rows

SELECT 
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) AS dplcat_row
FROM Sales.Orders

SELECT 
	OrderID,
	COUNT(*) AS dplcat_row
FROM Sales.Orders
GROUP BY OrderID

SELECT *
FROM (
	SELECT 
		OrderID,
		COUNT(*) OVER(PARTITION BY OrderID) AS dplcat_row
	FROM Sales.OrdersArchive
)T
WHERE dplcat_row > 1;

SELECT 
	OrderID,
	COUNT(*) AS dplcat_row
FROM Sales.OrdersArchive
GROUP BY OrderID
HAVING COUNT(*) > 1

/*
	Find the total sales across all orders
	and the total sales for each product.
	Additionally, provide details such as order ID and order date
*/

SELECT 
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	SUM(Sales) OVER() AS ttl_sales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS prd_sum
FROM Sales.Orders

--Find the percentage contribution of each product's sales to the total sales

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() AS ttl_sales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS prd_sales,
	CAST(FORMAT((SUM(Sales) OVER(PARTITION BY ProductID)*(1.0)/ISNULL(SUM(Sales) OVER(),0)) * 100,'N2')  AS varchar)+ ' %' prd_measure
FROM Sales.Orders;

/*
	Find the average sales across all orders and the average sales for each product.
	Additionally,provide details such as order ID and order date
*/

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER() AS avg_sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS prd_avg_sales
FROM Sales.Orders

--Find the average scores of customes.
--Additionally, provide details such as Customer ID and Last Name

SELECT 
	CustomerID,
	FirstName,
	LastName,
	Score,
	AVG(ISNULL(Score,0)) OVER() AS avg_sales,
	AVG(Score) OVER() AS avg_sales
FROM Sales.Customers

--Find all orders where sales are higher than the average sales across all orders
SELECT 
	OrderID,
	OrderDate,
	Sales
FROM(
	SELECT 
		*,
		AVG(Sales) OVER() AS avg_sales
	FROM Sales.Orders
)t
WHERE Sales > avg_sales;

/*
	Find the highest & lowest sales across all orders 
	and the highest & lowest sales for each product.
	Additionally, provide details such as order Id and order date
*/

SELECT 
	OrderID,
	OrderDate,
	Sales,
	MAX(Sales) OVER() AS max_sales,
	MIN(COALESCE(Sales,0)) OVER() AS min_sales,
	MAX(Sales) OVER(PARTITION BY ProductID) AS max_prd_sales,
	MIN(COALESCE(Sales,0)) OVER(PARTITION BY ProductID) AS min_prd_sales
FROM Sales.Orders

--show the employees who have the highest salaries

SELECT 
		EmployeeID,
		FirstName,
		LastName,
		Department,
		Gender,
		Salary
FROM (
	SELECT 
		EmployeeID,
		FirstName,
		LastName,
		Department,
		Gender,
		Salary,
		MAX(Salary) OVER() AS max_salary
	FROM Sales.Employees
)T
WHERE Salary = max_salary

--Find the deviation of each sales from the minimum and maximum sales amounts
SELECT 
	OrderID,
	OrderDate,
	Sales,
	MAX(Sales) OVER() AS max_sales,
	MIN(Sales) OVER() AS min_sales,
	FORMAT((MAX(Sales) OVER() - Sales)*1.0/Sales,'N2') + ' %D' AS max_sales_deviation,
	FORMAT((Sales - MIN(Sales) OVER())*1.0/Sales,'N2')+ ' %U' AS min_sales_deviation
FROM Sales.Orders  

--Calculate moving average of sales for each product over time 
--Calculate moving average of sales for each product over time, including only the next order

SELECT 
	OrderID,
	CustomerID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS avg_sales,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS moving_avg,
	AVG(Sales) OVER(PARTITION BY CustomerID ORDER BY OrderDate ASC) AS moving_avg,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderID ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS rolling_avg
FROM Sales.Orders