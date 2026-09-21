USE SalesDB;

SELECT 
	*,
	ISNULL(ShipAddress,BillAddress) AS nw_add
FROM Sales.Orders

--Find the average score of the customers

SELECT 
	AVG(Score) AS cust_avg_score
FROM Sales.Customers;

SELECT 
	AVG(ISNULL(Score,0)) AS avg_cust_score
FROM Sales.Customers;

/*
	Display the full name of customers in a single field 
	by merging their first and last names,
	and add 10 bonus points to each customer's score.
*/

SELECT 
	CustomerID,
	ISNULL(TRIM(FirstName),'') +' '+ ISNULL(TRIM(LastName),'') AS full_name,
	Country,
	ISNULL(Score,0) + 10 AS score_with_bonus,
	Email
FROM Sales.Customers


--Sort the customers form lowest to highest scores,
-- with null apearing last 

SELECT 
	CustomerID,
	FirstName,
	LastName,
	Country,
	Score,
	Email
FROM Sales.Customers
ORDER BY ISNULL(Score,9999);

SELECT 
	CustomerID,
	FirstName,
	LastName,
	Country,
	Score,
	Email
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END ASC, Score ASC;

--Find the sales price of each order by dividing the sales by the quantity.

SELECT 
	*,
	Sales/NULLIF(Quantity,0) AS sales_price
FROM Sales.Orders

--Identify the customers who has no scores 

SELECT *
FROM Sales.Customers
WHERE Score IS NULL;

--List all cusotmers who have score

SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL;

--List all details for customers who have not placed any orders 

SELECT 
	sc.CustomerID,
	sc.FirstName + ' ' + COALESCE(sc.LastName,'') AS cust_name,
	sc.Country,
	sc.Score,
	sc.Email
FROM Sales.Customers sc
LEFT JOIN Sales.Orders so
ON sc.CustomerID = so.CustomerID
WHERE so.CustomerID IS NULL

WITH Orders AS (
	SELECT 1 Id, 'A' Category UNION
	SELECT 2, NULL UNION
	SELECT 3, '' UNION
	SELECT 4, ' '
)

SELECT 
	Id,
	Category,
	DATALENGTH(Category) AS cat_len, --calculate empty values
	len(Category), --ignore the empty values,
	TRIM(Category) AS policy_01,
	NULLIF(TRIM(Category),'') AS policy_02,
	COALESCE(NULLIF(TRIM(Category),''),'N/A') AS policy_03
FROM Orders;


/*
Generate a report showing the total sales for each category
	-High: If the sales higher than 50
	-Medium: If the sales between 20 and 50
	-low: If the sales equal or lower than 20

Sort the categories form highest sales to lowest

*/

SELECT 
	sales_category,
	SUM(Sales) AS sales_by_cat
FROM (
	SELECT 
		OrderID,
		Sales,
		CASE 
			WHEN Sales > 50 THEN 'High'
			WHEN Sales > 20 THEN 'Medium'
			ELSE 'Low'
		END sales_category
	FROM Sales.Orders
)t
GROUP BY sales_category
ORDER BY sales_by_cat ASC;

--Retrive employee details with gender displayed as full text

SELECT 
	EmployeeID,
	FirstName + ' ' + LastName AS emp_name,
	Department,
	BirthDate,
	CASE 
		WHEN Gender = 'M' THEN 'Male'
		WHEN GENDER = 'F' THEN 'Female'
		ELSE 'n/a'
	END AS gender,
	Salary,
	ManagerID
FROM Sales.Employees;

--Retrive customers details with abbreviated country code

SELECT 
	CustomerID,
	FirstName,
	CASE 
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'n/a'
	END cntry_abbr,
	Score,
	Email
FROM Sales.Customers

SELECT 
	CustomerID,
	FirstName,
	CASE Country -- all here
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
		ELSE 'n/a'
	END cntry_abbr,
	Score,
	Email
FROM Sales.Customers

--Find the average score of cusotmers and treat Nulls as 0
--Additionally provide details such CustomerId and LastName

SELECT 
	CustomerID,
	FirstName,
	Country,
	AVG(
		CASE 
			WHEN Score IS NULL THEN 0
			ELSE Score
		END
	) OVER() AS avg_score
FROM Sales.Customers;

--Count how many times each customer has made an order with sales greater than 30

SELECT 
	CustomerID,
	SUM(
		CASE
			WHEN Sales > 30 THEN 1
			ELSE 0
		END
	) AS cnt_sales,
	COUNT(*) AS ttl_orders
FROM Sales.Orders
GROUP BY CustomerID;

SELECT 
	CustomerID,
	Sales
FROM Sales.Orders
WHERE Sales > 30
ORDER BY CustomerID