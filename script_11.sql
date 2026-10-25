-- Step1: Find the total Sales Per Customer

WITH CTE_Total_Sales AS 
(
	SELECT 
		CustomerID,
		SUM(Sales) AS cust_sls
	FROM Sales.Orders
	GROUP BY CustomerID
)
-- Step2: Find the last order date per customer.
, CTE_Last_ord_date AS 
(
	SELECT 
		CustomerID,
		MAX(OrderDate) AS lst_ord_dt
	FROM Sales.Orders
	GROUP BY CustomerID
)
-- Step3: Rank Customers based on Total Sales per Customer
, CTE_Cust_Rank AS 
(
	SELECT 
		CustomerID,
		DENSE_RANK() OVER(ORDER BY cust_sls DESC) AS cust_rank
	FROM CTE_Total_Sales
)
--Step4: Segment customers based on their total sales
, CTE_Cust_Segment AS 
(
	SELECT 
		CustomerID,
		CASE 
			WHEN cust_sls > 100 THEN 'High'
			WHEN cust_sls > 70 THEN 'Medium'
			ELSE 'Low'
		END AS cust_segment
	FROM CTE_Total_Sales
)

SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.cust_sls,
	cts2.lst_ord_dt,
	cts3.cust_rank,
	cts4.cust_segment
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON c.CustomerID = cts.CustomerID
LEFT JOIN CTE_Last_ord_date cts2
ON c.CustomerID = cts2.CustomerID
LEFT JOIN CTE_Cust_Rank cts3
ON c.CustomerID = cts3.CustomerID
LEFT JOIN CTE_Cust_Segment cts4
ON c.CustomerID = cts4.CustomerID
ORDER BY c.CustomerID

-- Generate a sequence of Numbers from 1 to 20 

WITH CTE_Gen_Num AS (
	SELECT 1 AS num
	UNION ALL
	SELECT num + 1
	FROM CTE_Gen_Num
	WHERE num < 100
)

SELECT *
FROM CTE_Gen_Num
OPTION (MAXRECURSION 100)

--Show the employee hierarchy by displaying each employee's level within the organization.

WITH CTE_Manager_hierarchy AS (
	SELECT 
		EmployeeID,
		FirstName,
		LastName,
		Department,
		BirthDate,
		Gender,
		Salary,
		ManagerID  AS mgr_id,
		1 AS level
	FROM Sales.Employees
	WHERE ManagerID IS NULL

	UNION ALL

	SELECT 
		e.*,
		level + 1
	FROM Sales.Employees e
	INNER JOIN CTE_Manager_hierarchy ceh
	ON e.ManagerID = ceh.EmployeeID
)

SELECT *
FROM CTE_Manager_hierarchy