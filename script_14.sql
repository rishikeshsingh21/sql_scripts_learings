--Step 1: Write a Query
--For US Customers Find the Total Number of Customers and the Average Score

SELECT 
	COUNT(CustomerID) AS ttl_customer,
	AVG(Score) AS avg_cust_score
FROM Sales.Customers
WHERE Country = 'USA'


--Step 2 : Turning the query into a store procedure
--Total Customers from Germany : 2;
--Average score from Germany: 425;

IF OBJECT_ID('GetCustomerSummary') IS NOT NULL 
	DROP PROCEDURE dbo.GetCustomerSummary
GO
CREATE PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS 
BEGIN
	BEGIN TRY

		DECLARE @TotalCustomers INT, @AvgScore FLOAT;

		-- ================================
		-- Step 1: Prepare & Cleanup Data
		-- ================================
		SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = 'GERMANY'
		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
		BEGIN
			PRINT('Updating NULL scores to');
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country;
		END

		ELSE
		BEGIN
			PRINT('No NULL score found')
		END

		-- ===================================
		-- Step 2: Generating Summary Reports
		-- ===================================
		
		-- ================================================================
		-- Calculate Total Customer and Average Score for Specific country
		-- ================================================================
		SELECT 
			@TotalCustomers = COUNT(CustomerID),
			 @AvgScore = AVG(Score) 
		FROM Sales.Customers
		WHERE Country = @Country;

		PRINT 'Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR)
		PRINT 'Average score from ' +@Country + ': ' + CAST(@AvgScore AS NVARCHAR)

		-- ==================================================================
		-- Find the total Nr. of Orders and Total Sales for Specific country
		-- ==================================================================
		SELECT 
			COUNT(OrderID) AS ttl_orders,
			SUM(Sales) AS ttl_sales
		FROM Sales.Orders o
		JOIN Sales.Customers c
		ON o.CustomerID = c.CustomerID
		WHERE c.Country = @Country;
	END TRY

	-- ================
	-- Error Handling
	-- ================
	BEGIN CATCH
		PRINT('An error occured.');
		PRINT('Error Message: '+ ERROR_MESSAGE());
		PRINT('Error Number: '+ CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Line: '+ CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('Error Procedure: '+ ERROR_PROCEDURE())
	END CATCH
END

--Step 3 : Execute the store procedure

EXEC GetCustomerSummary @Country = 'GERMANY'

-- For German Customers Find the Total Number of Customers and the average score

CREATE PROCEDURE GetCustomerSummaryGermany AS 
BEGIN
SELECT 
	COUNT(CustomerID) AS ttl_customer,
	AVG(Score) AS avg_cust_score
FROM Sales.Customers
WHERE Country = 'germany'
END


EXEC GetCustomerSummaryGermany

DROP PROCEDURE GetCustomerSummaryGermany


