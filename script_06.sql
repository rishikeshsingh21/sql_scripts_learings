USE SalesDB;

SELECT
	OrderID,
	OrderDate,
	ShipDate,
	CreationTime,
	'2026-09-15' AS hardcoded_date,
	GETDATE() AS today
FROM Sales.Orders

SELECT CAST(GETDATE() AS datetime2) ;

SELECT 
	OrderID,
	CreationTime,
	YEAR(CreationTime) AS year,
	MONTH(CreationTime) AS month,
	DAY(CreationTime) AS day
FROM Sales.Orders

SELECT 
	OrderDate,
	CreationTime,
	DATEPART(HOUR, CreationTime) AS hour,
	DATEPART(MINUTE, CreationTime) AS minute,
	DATEPART(SECOND,CreationTime) AS second,
	DATEPART(MILLISECOND, CreationTime) AS millisecond,
	DATEPART(DAY, CreationTime) AS day,
	DATEPART(MONTH, CreationTime) AS month,
	DATEPART(YEAR,CreationTime) AS year,
	DATEPART(QUARTER,CreationTime) AS quarter,
	DATEPART(WEEK, CreationTime) AS week,
	DATEPART(WEEKDAY,CreationTime) AS weekday
FROM Sales.Orders

SELECT 
	OrderID,
	CreationTime,
	DATENAME(MONTH,CreationTime) AS month_dn,
	DATENAME(WEEKDAY,CreationTime) AS day_dn,
	DATENAME(YEAR,CreationTime) AS year --as string not int
FROM Sales.Orders;

SELECT 
	OrderID,
	OrderDate,
	CreationTime,
	DATETRUNC(HOUR,CreationTime) AS dt_hour,
	DATETRUNC(DAY,CreationTime) AS dt_day,
	DATETRUNC(MONTH,CreationTime) AS dt_month
FROM Sales.Orders

SELECT 
	DATETRUNC(MONTH,CreationTime),
	COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH,CreationTime)

SELECT 
	*,
	EOMONTH(CreationTime) AS EndOfMonth
FROM Sales.Orders

--How many orders were placed each year?

SELECT 
	YEAR(CreationTime) AS year,
	COUNT(*) AS ord_year
FROM Sales.Orders
GROUP BY YEAR(CreationTime)

SELECT 
	CAST(DATETRUNC(YEAR,CreationTime)AS DATE) AS year,
	COUNT(*) AS ord_year
FROM Sales.Orders
GROUP BY DATETRUNC(YEAR,CreationTime)

--how many orders were placed each month?
SELECT 
	DATENAME(MONTH,CreationTime) AS ord_month,
	COUNT(*) AS ttl_ord
FROM Sales.Orders
GROUP BY DATENAME(MONTH,CreationTime)


-- Show all orders that were placed during the month of february

SELECT 
	DATEPART(MONTH,CreationTime) AS ord_month,
	COUNT(*) AS ttl_order
FROM Sales.Orders
GROUP BY DATEPART(MONTH,CreationTime) 
HAVING DATEPART(MONTH,CreationTime) = 2

SELECT *
FROM Sales.Orders
WHERE MONTH(CreationTime) = 2

SELECT 
	'Year' AS part,
	DATEPART(YEAR,GETDATE()) AS DatePart_Output,
	DATENAME(YEAR,GETDATE()) AS DateNamte_Output,
	DATETRUNC(YEAR,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'yy',
	DATEPART(yy,GETDATE()) AS DatePart_Output,
	DATENAME(yy,GETDATE()) AS DateNamte_Output,
	DATETRUNC(yy,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'yyyy',
	DATEPART(yyyy,GETDATE()) AS DatePart_Output,
	DATENAME(yyyy,GETDATE()) AS DateNamte_Output,
	DATETRUNC(yyyy,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'Quarter',
	DATEPART(QUARTER,GETDATE()) AS DatePart_Output,
	DATENAME(QUARTER,GETDATE()) AS DateNamte_Output,
	DATETRUNC(QUARTER,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'q',
	DATEPART(Q,GETDATE()) AS DatePart_Output,
	DATENAME(Q,GETDATE()) AS DateNamte_Output,
	DATETRUNC(Q,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'qq',
	DATEPART(qq,GETDATE()) AS DatePart_Output,
	DATENAME(qq,GETDATE()) AS DateNamte_Output,
	DATETRUNC(qq,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'Month',
	DATEPART(MONTH,GETDATE()) AS DatePart_Output,
	DATENAME(MONTH,GETDATE()) AS DateNamte_Output,
	DATETRUNC(MONTH,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'm',
	DATEPART(m,GETDATE()) AS DatePart_Output,
	DATENAME(m,GETDATE()) AS DateNamte_Output,
	DATETRUNC(m,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'mm',
	DATEPART(mm,GETDATE()) AS DatePart_Output,
	DATENAME(mm,GETDATE()) AS DateNamte_Output,
	DATETRUNC(mm,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'DayOfYear',
	DATEPART(DAYOFYEAR,GETDATE()) AS DatePart_Output,
	DATENAME(DAYOFYEAR,GETDATE()) AS DateNamte_Output,
	DATETRUNC(DAYOFYEAR,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'dy',
	DATEPART(dy,GETDATE()) AS DatePart_Output,
	DATENAME(dy,GETDATE()) AS DateNamte_Output,
	DATETRUNC(dy,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'y',
	DATEPART(y,GETDATE()) AS DatePart_Output,
	DATENAME(y,GETDATE()) AS DateNamte_Output,
	DATETRUNC(y,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'day',
	DATEPART(DAY,GETDATE()) AS DatePart_Output,
	DATENAME(DAY,GETDATE()) AS DateNamte_Output,
	DATETRUNC(DAY,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'dd',
	DATEPART(dd,GETDATE()) AS DatePart_Output,
	DATENAME(dd,GETDATE()) AS DateNamte_Output,
	DATETRUNC(dd,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'd',
	DATEPART(d,GETDATE()) AS DatePart_Output,
	DATENAME(d,GETDATE()) AS DateNamte_Output,
	DATETRUNC(d,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'weekday',
	DATEPART(WEEKDAY,GETDATE()) AS DatePart_Output,
	DATENAME(WEEKDAY,GETDATE()) AS DateNamte_Output,
	null AS DateTrunc_Output
UNION ALL
SELECT 
	'dw',
	DATEPART(dw,GETDATE()) AS DatePart_Output,
	DATENAME(dw,GETDATE()) AS DateNamte_Output,
	null AS DateTrunc_Output
UNION ALL
SELECT 
	'week',
	DATEPART(WEEK,GETDATE()) AS DatePart_Output,
	DATENAME(WEEK,GETDATE()) AS DateNamte_Output,
	DATETRUNC(WEEK,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'wk',
	DATEPART(wk,GETDATE()) AS DatePart_Output,
	DATENAME(wk,GETDATE()) AS DateNamte_Output,
	DATETRUNC(wk,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'ww',
	DATEPART(ww,GETDATE()) AS DatePart_Output,
	DATENAME(ww,GETDATE()) AS DateNamte_Output,
	DATETRUNC(ww,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'iso_week',
	DATEPART(ISO_WEEK,GETDATE()) AS DatePart_Output,
	DATENAME(ISO_WEEK,GETDATE()) AS DateNamte_Output,
	DATETRUNC(ISO_WEEK,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'isowk',
	DATEPART(ISOWK,GETDATE()) AS DatePart_Output,
	DATENAME(ISOWK,GETDATE()) AS DateNamte_Output,
	DATETRUNC(ISOWK,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'isoww',
	DATEPART(ISOWW,GETDATE()) AS DatePart_Output,
	DATENAME(ISOWW,GETDATE()) AS DateNamte_Output,
	DATETRUNC(ISOWW,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'hour',
	DATEPART(HOUR,GETDATE()) AS DatePart_Output,
	DATENAME(HOUR,GETDATE()) AS DateNamte_Output,
	DATETRUNC(HOUR,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'hh',
	DATEPART(HH,GETDATE()) AS DatePart_Output,
	DATENAME(HH,GETDATE()) AS DateNamte_Output,
	DATETRUNC(HH,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'minute',
	DATEPART(MINUTE,GETDATE()) AS DatePart_Output,
	DATENAME(MINUTE,GETDATE()) AS DateNamte_Output,
	DATETRUNC(MINUTE,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'n',
	DATEPART(n,GETDATE()) AS DatePart_Output,
	DATENAME(n,GETDATE()) AS DateNamte_Output,
	DATETRUNC(n,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'second',
	DATEPART(SECOND,GETDATE()) AS DatePart_Output,
	DATENAME(SECOND,GETDATE()) AS DateNamte_Output,
	DATETRUNC(SECOND,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'ss',
	DATEPART(SS,GETDATE()) AS DatePart_Output,
	DATENAME(SS,GETDATE()) AS DateNamte_Output,
	DATETRUNC(SS,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	's',
	DATEPART(S,GETDATE()) AS DatePart_Output,
	DATENAME(S,GETDATE()) AS DateNamte_Output,
	DATETRUNC(S,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'millisecond',
	DATEPART(MILLISECOND,GETDATE()) AS DatePart_Output,
	DATENAME(MILLISECOND,GETDATE()) AS DateNamte_Output,
	DATETRUNC(MILLISECOND,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'ms',
	DATEPART(MS,GETDATE()) AS DatePart_Output,
	DATENAME(MS,GETDATE()) AS DateNamte_Output,
	DATETRUNC(MS,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'microsecond',
	DATEPART(MICROSECOND,GETDATE()) AS DatePart_Output,
	DATENAME(MICROSECOND,GETDATE()) AS DateNamte_Output,
	null AS DateTrunc_Output
UNION ALL
SELECT 
	'msc',
	DATEPART(MS,GETDATE()) AS DatePart_Output,
	DATENAME(MS,GETDATE()) AS DateNamte_Output,
	DATETRUNC(MS,GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
	'nanosecond',
	DATEPART(NANOSECOND,GETDATE()) AS DatePart_Output,
	DATENAME(NANOSECOND,GETDATE()) AS DateNamte_Output,
	NULL AS DateTrunc_Output
UNION ALL
SELECT 
	'ns',
	DATEPART(NS,GETDATE()) AS DatePart_Output,
	DATENAME(NS,GETDATE()) AS DateNamte_Output,
	null AS DateTrunc_Output


SELECT 
	*,
	FORMAT(CreationTime,'dd/MM/yyyy HH:mm:ss tt') AS formated_creation_time
FROM Sales.Orders

SELECT 
	OrderID,
	OrderDate,
	FORMAT(CreationTime,'MM-dd-yyyy HH:mm:ss tt') AS usa_format,
	FORMAT(CreationTime,'dd-MM-yyyy HH:mm:ss tt') AS euro_format,
	FORMAT(CreationTime,'d') AS d,
	FORMAT(CreationTime,'dd') AS dd,
	FORMAT(CreationTime,'ddd') AS ddd,
	FORMAT(CreationTime,'dddd') AS dddd,
	FORMAT(CreationTime,'M') AS M,
	FORMAT(CreationTime,'MM') AS MM,
	FORMAT(CreationTime,'MMM') AS MMM,
	FORMAT(CreationTime,'MMMM') AS MMMM
FROM Sales.Orders

--Show Creation Time using the following format:
-- Day Wed Jan Q1 2025 12:34:56 PM

SELECT 
	OrderID,
	OrderDate,
	CreationTime,
	'Day ' + FORMAT(CreationTime,'ddd MMM Q') + DATENAME(QUARTER,CreationTime) + FORMAT(CreationTime,' yyyy hh:mm:ss tt') AS given_format
FROM Sales.Orders 

SELECT 
	FORMAT(OrderDate,'MMM yy') AS date,
	COUNT(*) AS order_count
FROM Sales.Orders
GROUP BY FORMAT(OrderDate,'MMM yy')



SELECT 
	'D' AS FORMAT,
	FORMAT(GETDATE(), 'D') AS [formated vaue],
	'full detailed date' AS discreption
UNION ALL
SELECT 
	'd',
	FORMAT(GETDATE(), 'd'),
	'shot date pattern'
UNION ALL
SELECT 
	'dd',
	FORMAT(GETDATE(), 'dd'),
	'two digit date'
UNION ALL
SELECT 
	'ddd',
	FORMAT(GETDATE(), 'ddd'),
	'shot day name'
UNION ALL
SELECT 
	'dddd',
	FORMAT(GETDATE(), 'dddd'),
	'full day name'
UNION ALL
SELECT 
	'M',
	FORMAT(GETDATE(), 'M'),
	'full month name with day'
UNION ALL
SELECT 
	'MM',
	FORMAT(GETDATE(), 'MM'),
	'two digit month'
UNION ALL
SELECT 
	'MMM',
	FORMAT(GETDATE(), 'MMM'),
	'Shot month name'
UNION ALL
SELECT 
	'MMMM',
	FORMAT(GETDATE(), 'MMMM'),
	'Full month name'
UNION ALL
SELECT 
	'Y',
	FORMAT(GETDATE(), 'Y'),
	'month name with year'
UNION ALL
SELECT 
	'yy',
	FORMAT(GETDATE(), 'yy'),
	'two digit year'
UNION ALL
SELECT 
	'yyy',
	FORMAT(GETDATE(), 'yyy'),
	'full digit of year'
UNION ALL
SELECT 
	'yyyy',
	FORMAT(GETDATE(), 'yyyy'),
	'four digit year'
UNION ALL
SELECT 
	'H',
	FORMAT(GETDATE(), 'H'),
	'NO value'
UNION ALL
SELECT 
	'HH',
	FORMAT(GETDATE(), 'HH'),
	'two digit Hour in 24 HOUR FORMAT'
UNION ALL
SELECT 
	'hh',
	FORMAT(GETDATE(), 'hh'),
	'two digit hour 12 hour fomrat'
UNION ALL
SELECT 
	'mm',
	FORMAT(GETDATE(), 'mm'),
	'two digit minute'
UNION ALL
SELECT 
	's',
	FORMAT(GETDATE(), 's'),
	'datetime'
UNION ALL
SELECT 
	'ss',
	FORMAT(GETDATE(), 'ss'),
	'two digit second'
UNION ALL
SELECT 
	'tt',
	FORMAT(GETDATE(), 'tt'),
	'pm or am'


SELECT 'N' AS FORMATTYPE, FORMAT(12345.6323,'N') AS Formatedvalue
UNION ALL
SELECT 'P' AS FORMATTYPE, FORMAT(12345.6323,'P') AS Formatedvalue
UNION ALL
SELECT 'C' AS FORMATTYPE, FORMAT(12345.6323,'C') AS Formatedvalue
UNION ALL
SELECT 'E' AS FORMATTYPE, FORMAT(12345.6323,'E') AS Formatedvalue
UNION ALL
SELECT 'F' AS FORMATTYPE, FORMAT(12345.6323,'F') AS Formatedvalue
UNION ALL
SELECT 'N0' AS FORMATTYPE, FORMAT(12345.6323,'N0') AS Formatedvalue
UNION ALL
SELECT 'N1' AS FORMATTYPE, FORMAT(12345.6323,'N1') AS Formatedvalue
UNION ALL
SELECT 'N2' AS FORMATTYPE, FORMAT(12345.6323,'N2') AS Formatedvalue

SELECT 
	CONVERT(INT, '1234') AS str_to_int,
	CONVERT(DATE, '2026-09-20') AS [String to date convert],
	CONVERT(DATE, CreationTime) AS [DATETIME to date Convet],
	CONVERT(varchar, CreationTime,34) AS [DATETIME to string formated convert EU: STYLE 34],
	CONVERT(varchar, CreationTime,32) AS [DATETIME to string formated convert usa: STYLE 32]
FROM Sales.Orders


SELECT 
	CAST(123 AS varchar) AS [int ot string],
	CAST('123' AS INT) AS [string to int],
	CAST('2026-09-20' AS DATE) AS [string to date],
	CAST('2026-09-20 14:53:32'AS datetime2) AS [string to datetime],
	CAST(CreationTime as date) AS [DATETIME TO DATE]
FROM sales.orders

-- add two year to order date

SELECT 
	OrderID,
	OrderDate,
	DATEADD(YEAR, 2, OrderDate) AS two_year_added,
	DATEADD(YEAR, -2, OrderDate) AS two_year_before,
	DATEADD(MONTH, -2, OrderDate) AS two_month_before,
	DATEADD(MONTH, 2, OrderDate) AS two_mont_after
FROM Sales.Orders


--Calculate the age of employees 

SELECT 
	*,
	DATEDIFF(YEAR,BirthDate,GETDATE()) AS emp_age
FROM Sales.Employees


--Find the average shipping duration in days for each month

SELECT 
	DATENAME(MONTH,OrderDate) AS order_month,
	AVG(DATEDIFF(DAY,OrderDate,ShipDate) ) AS avg_shipping_day
FROM Sales.Orders
GROUP BY DATENAME(MONTH,OrderDate)


--Find the number of days 
-- between each order and previous order,

SELECT 
	*,
	LAG(OrderDate) OVER(ORDER BY OrderDate) AS previous_order_date,
	DATEDIFF(DAY,LAG(OrderDate) OVER(ORDER BY OrderDate),OrderDate) AS diff_days
FROM Sales.Orders


SELECT 
ISDATE('123') AS datecheck1,
ISDATE('2026-09-20') AS datecheck2,
ISDATE('20-09-2026') AS datecheck3,
ISDATE('2026') AS datecheck4,
ISDATE('09') AS datecheck5

SELECT 
	orderDate as date,
	ISDATE(orderDate) AS flag,
	CASE WHEN ISDATE(orderDate) = 1 THEN CAST(orderDate AS date)
	ELSE '9999-01-01'
	END orderDate
FROM (
	SELECT '2026-09-20' AS orderDate UNION 
	SELECT '2026-08-23' UNION
	SELECT '2026-07-24' UNION
	SELECT '2025-09'
)t
WHERE ISDATE(orderDate) = 0