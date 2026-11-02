--Step 1: Create a Partition Function

CREATE PARTITION FUNCTION PartitionByYear (DATE) 
AS RANGE LEFT FOR VALUES ('2023-12-31','2024-12-31','2025-12-31')

-- Query list all the existing Partition Function

SELECT 
	name,
	function_id,
	type,
	type_desc,
	boundary_value_on_right
FROM sys.partition_functions;


--Step2: Create Filegroups

ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;


--Query lists all existing Filegroups

SELECT *
FROM sys.filegroups
WHERE type = 'FG'

--Step3: Add .ndf File to each filegroup

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2023,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS01\MSSQL\DATA\P_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2024,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS01\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2025,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS01\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2026,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS01\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026;

SELECT 
	fg.name AS FilegroupName,
	mf.name AS LogicalFileName,
	mf.physical_name AS PhysicalFilePath,
	mf.size/128 AS SizeInMB
FROM sys.filegroups fg
JOIN sys.master_files mf 
ON fg.data_space_id = mf.data_space_id
WHERE mf.database_id = DB_ID('SalesDB');

--Step: Create Partition Scheme

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026);

--Query lists all Partition Scheme 

SELECT 
	ps.name AS PartitionSchemeName,
	pf.name AS PartitionFunctionName,
	ds.destination_id AS PartitionNumber,
	fg.name AS FigleGroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf 
ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds
ON ps.data_space_id = ds.partition_scheme_id 
JOIN sys.filegroups fg
ON ds.data_space_id = fg.data_space_id

--Step 5: Create the Partition Table

CREATE TABLE Sales.Orders_Partitioned(
	OrderId INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear(OrderDate);

--Step 6: Insert data into the partitioned table

