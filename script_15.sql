CREATE TABLE Sales.EmployeeLogs(
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255)
)

ALTER TABLE Sales.EmployeeLogs
ADD LogDate DATE

SELECT *
FROM Sales.EmployeeLogs;

CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT 
AS 
BEGIN
	INSERT INTO Sales.EmployeeLogs(EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New employee added = ' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM inserted	
END

SELECT *
FROM Sales.Employees

INSERT INTO Sales.Employees (EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID)
VALUES (6, 'Yash', 'rak', 'technology', '2002-08-08','M', 60000, 2)

SELECT *
FROM Sales.EmployeeLogs;