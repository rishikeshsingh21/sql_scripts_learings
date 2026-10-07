
--Rank the orders based on their sales from highest to lowest

SELECT 
	*,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) AS sls_rank_row_number,
	RANK() OVER(ORDER BY Sales DESC) AS sls_rank_rank,
	DENSE_RANK() OVER(ORDER BY Sales DESC) AS sls_rank_dense_rank
FROM Sales.Orders

--Find the top highest sales for each product

SELECT *
FROM (
	SELECT 
		*,
		RANK() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS rank_prd
	FROM Sales.Orders
)T 
WHERE rank_prd = 1;


--Find the lowest 2 customers based on their total sales

SELECT *
FROM(
	SELECT 
		CustomerID,
		SUM(Sales) AS sls_sum,
		ROW_NUMBER() OVER(ORDER BY SUM(Sales)) AS rank
	FROM Sales.Orders
	GROUP BY CustomerID
)T
WHERE rank <= 2;

	SELECT 
		CustomerID,
		SUM(Sales) AS sls_sum,
		ROW_NUMBER() OVER(ORDER BY SUM(Sales) DESC) AS rank
	FROM Sales.Orders
	GROUP BY CustomerID

-- Assign unique IDs to the rows of the 'Orders Archive' table

SELECT
	*,
	ROW_NUMBER() OVER(ORDER BY OrderID, OrderDate) AS pk_key
FROM Sales.OrdersArchive;

--Identify duplicate rows in the table 'Orders Archive' and return a clean result without any  duplicates

SELECT *
FROM(
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY OrderID) AS rk
	FROM Sales.OrdersArchive
)t
WHERE rk = 1;

SELECT 
	OrderID,
	OrderDate,
	Sales,
	NTILE(1) OVER(ORDER BY Sales) AS one_bucket,
	NTILE(2) OVER(ORDER BY Sales) AS two_bucket,
	NTILE(3) OVER(ORDER BY Sales) AS three_bucket,
	NTILE(4) OVER(ORDER BY Sales) AS four_bucket
FROM Sales.Orders;

--Segment all orders into 3 categories: High, medium and low sales.

SELECT 
	*,
	CASE
		WHEN hml_bucket = 1 THEN 'High'
		WHEN hml_bucket = 2 THEN 'Medium'
		ELSE 'Low'
	END AS category
FROM (
	SELECT 
		OrderID,
		OrderDate,
		Sales,
		NTILE(3) OVER(ORDER BY Sales DESC) hml_bucket
	FROM Sales.Orders
)t;

--In order to export the data , divide the orders into 2 groups


With cta1  AS
(
	SELECT	
		*,
		NTILE(2) OVER(ORDER BY OrderID) AS buckets
	FROM Sales.Orders
)

SELECT *
FROM cta1
WHERE buckets = 1
UNION
SELECT *
FROM cta1 
WHERE buckets = 2;

SELECT 
	*,
	CUME_DIST() OVER(ORDER BY Sales ASC) AS cume_rk,
	PERCENT_RANK() OVER(ORDER BY Sales ASC) AS perct_rk
FROM Sales.Orders;

--Find the products that fall within the highest 40% of prices

SELECT 
	*,
	CONCAT(pr_rk * 100, '%') AS disc_rank
FROM(
	SELECT 
		*,
		CUME_DIST() OVER(ORDER BY Price DESC) AS pr_rk
	FROM Sales.Products
)t
WHERE pr_rk <= 0.4;


--Analyze the month-over-month performance by finding the percentage change
--in sales between the current and previous month

SELECT 
	*,
	CONCAT(FORMAT(COALESCE(((monthy_sls - pre_mn_sls)*1.0/pre_mn_sls) *100,0),'N2'),' %') AS prt_change
FROM (
	SELECT 
		DATEPART(MONTH,OrderDate) AS mnth,
		SUM(Sales) AS monthy_sls,
		LAG(SUM(Sales)) OVER(ORDER BY DATEPART(MONTH,OrderDate)) AS pre_mn_sls
	FROM Sales.Orders
	GROUP BY DATEPART(MONTH,OrderDate)
)t;

--Analyze customer loyalty by ranking customers
--based on the average number of days between orders

SELECT 
	CustomerID,
	AVG(day_bn_ord) AS avg_ord_day,
	RANK() OVER(ORDER BY COALESCE(AVG(day_bn_ord),9999)) AS loyalty_rank
FROM(
	SELECT 
		OrderID,
		CustomerID,
		OrderDate,
		LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) as next_order_date,
		DATEDIFF(DAY,OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS day_bn_ord
	FROM Sales.Orders
)t
GROUP BY CustomerID;

SELECT 
	*,
	FIRST_VALUE(Sales) OVER(ORDER BY Sales) AS sales,
	LAST_VALUE(Sales) OVER(ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS lst_sls
FROM Sales.Orders;
