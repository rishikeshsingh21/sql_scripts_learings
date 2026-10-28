

SELECT 
	*
INTO Sales.DBCustomer
FROM Sales.Customers

SELECT *
FROM Sales.DBCustomer

SELECT *
FROM Sales.DBCustomer
WHERE CustomerID = 1

CREATE CLUSTERED INDEX idx_DBCustomer_CustomerID ON Sales.DBCustomer (CustomerID ASC);

--CREATE CLUSTERED INDEX idx_DBCustomer_FirstName ON Sales.DBCustomer (FirstName ASC); Err one clustered idx per table

DROP INDEX idx_DBCustomer_CustomerID ON Sales.DBCustomer;

SELECT *
FROM Sales.DBCustomer
WHERE LastName = 'Brown';

CREATE NONCLUSTERED INDEX idx_DBCustomer_LastName ON Sales.DBCustomer (LastName ASC);

CREATE INDEX idx_DBCustomer_FirstName ON Sales.DBCustomer (FirstName ASC);

--composite index

SELECT *
FROM Sales.DBCustomer
WHERE Country = 'USA' AND Score > 500;


CREATE NONCLUSTERED INDEX idx_DBCustomer_CountryScore ON Sales.DBCustomer (Country ASC, Score DESC);
DROP INDEX idx_DBCustomer_CountrySales ON Sales.DBCustomer;

SELECT *
FROM SYS.indexes

CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomer_CS ON Sales.DBCustomer;

DROP INDEX idx_DBCustomer_CustomerID ON Sales.DBCustomer;

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomer_FirstName_CS ON Sales.DBCustomer (FirstName);

USE AdventureWorksDW2025;

SELECT *
FROM FactInternetSales;

--HEAP
SELECT 
	*
INTO dbo.FactInternetSales_HP
FROM dbo.FactInternetSales;


--rowstore
SELECT 
	*
INTO dbo.FactInternetSales_RS
FROM dbo.FactInternetSales;

CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber);


--columnstore

SELECT 
	*
INTO dbo.FactInternetSales_CS
FROM dbo.FactInternetSales;

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS ON FactInternetSales_CS;


USE SalesDB;

SELECT *
FROM Sales.Products;

--CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Category ON Sales.Products (Category); not allowed because category has duplicate values 

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product ON Sales.Products (Product);

INSERT INTO Sales.Products (ProductID, Product, Category, Price)
VALUES (106, 'Bottle', 'Accessories', 100) -- cant insert duplicate value in unique key field product as it has uniques index on product

SELECT *
FROM Sales.Customers
WHERE Country = 'USA';

CREATE NONCLUSTERED INDEX idx_Customer_Country ON Sales.Customers (Country)
WHERE Country = 'USA';