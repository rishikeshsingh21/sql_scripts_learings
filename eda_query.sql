USE DataWarehouse;

SELECT 
	DATETRUNC(MONTH, order_date) AS order_date,
	SUM(sales_amount) AS sls_amt_by_dt,
	COUNT(customer_key) AS cust_count,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY sls_amt_by_dt DESC;

-- Calculate the total sales per month and the running total of sales over time.

SELECT 
	DATENAME(MONTH,order_date) AS month,
	SUM(sales_amount)
FROM gold.fact_sales
GROUP BY DATENAME(MONTH,order_date);

SELECT 
	order_date,
	total_sales,
	avg_price,
	SUM(total_sales) OVER(PARTITION BY order_date ORDER BY order_date ASC) AS running_total,
	AVG(avg_price) OVER(PARTITION BY order_date ORDER BY order_date ASC) AS moving_average_price
FROM (
	SELECT 
		DATETRUNC(MONTH,order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	GROUP BY DATETRUNC(MONTH,order_date)
)T

/* 
Analyze the yearly performance of products by comparing their sales to both 
the average sales performance of the product and the previous year's sales
*/
WITH yearly_product_sales AS (
	SELECT 
		YEAR(fs.order_date) AS order_year,
		dp.product_name,
		SUM(fs.sales_amount) AS current_sales
	FROM gold.fact_sales fs
	LEFT JOIN  gold.dim_product dp
	ON fs.product_key = dp.product_key
	WHERE fs.order_date IS NOT NULL
	GROUP BY YEAR(fs.order_date), dp.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER(PARTITION BY product_name) avg_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
	CASE 
		WHEN 
			current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'above avg'
		WHEN  
			current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'below avg'
		ELSE 'avg'
	END flag,
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) py_sales,
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py,
	CASE 
		WHEN 
			current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'increase'
		WHEN  
			current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'decrease'
		ELSE 'no change'
	END py_change
FROM yearly_product_sales
ORDER BY product_name, order_year


--Which categories contributes the most to overall sales
WITH category_salse AS (
SELECT 
	p.category,
	SUM(s.sales_amount) sls_by_cat
FROM gold.fact_sales s
LEFT JOIN gold.dim_product p
ON s.product_key = p.product_key
GROUP BY p.category
)

SELECT 
	category,
	sls_by_cat,
	SUM(sls_by_cat) OVER() AS tt_sls,
	CAST((sls_by_cat*1.0 / SUM(sls_by_cat) OVER()) * 100 AS VARCHAR)  +' %' AS percent_contribution 
FROM category_salse


/*
	segment products into cost ranges and count how many products fall into each segment
*/

SELECT 
	CASE 
		WHEN product_cost > 500 THEN 'High above 500'
		WHEN product_cost > 300 THEN 'Medium between 500 & 300'
		ELSE 'Low lower then 300'
	END cost_range,
	COUNT(product_key) AS no_of_prds
FROM gold.dim_product
GROUP BY (
	CASE 
		WHEN product_cost > 500 THEN 'High above 500'
		WHEN product_cost > 300 THEN 'Medium between 500 & 300'
		ELSE 'Low lower then 300'
	END
)

/*
Groupb customers into three segments based on there spending behavior:
	-VIP: Customers with atleast 12 months of history and spending more then 5,000
	-Regular: Customers with at least 12 month of history but spending 5,000 or less,
	-New: Customers with a lifespan less then 12 months.
and find the total number of customers by each group
*/
WITH cust_sls_details AS (
SELECT 
	c.customer_key,
	SUM(s.sales_amount) AS ttl_sales,
	MAX(order_date) AS earliest_order,
	MIN(order_date) AS oldest_order,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL
GROUP BY c.customer_key
)

SELECT 
	cust_category,
	count(customer_key) AS cust_count
FROM (
SELECT 
	customer_key,
	CASE 
		WHEN ttl_sales > 5000 AND lifespan >= 12 THEN 'VIP'
		WHEN ttl_sales < 5000 AND lifespan >= 12 THEN 'Regular'
		ELSE 'New'
	END cust_category
FROM cust_sls_details
)T
GROUP BY cust_category
ORDER BY cust_count DESC;


/*
====================================================================================
Customer Report
====================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age group.
	3. Aggregate customes-level metrics:
		- total orders
		- total sales,
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
====================================================================================
*/

CREATE VIEW gold.report_cusotmers AS 
WITH base_query AS (
/*-----------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
------------------------------------------------------------------------*/
SELECT 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	c.first_name + ' ' + c.last_name AS customer_name,
	DATEDIFF(YEAR, c.birth_date, GETDATE()) AS customer_age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE f.order_date IS NOT NULL
)
, customer_aggregation AS (
/*------------------------------------------------------------------------------
2) Cusotmer Aggregations: Summarizes key metrics at the cusotmer level
--------------------------------------------------------------------------------*/
SELECT 
	customer_key,
	customer_number,
	customer_name,
	customer_age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	customer_age)


SELECT 
	customer_key,
	customer_number,
	customer_name,
	customer_age,
	CASE 
		WHEN customer_age < 20 THEN 'Under 20'
		WHEN customer_age BETWEEN 20 AND 29 THEN '20-29'
		WHEN customer_age BETWEEN 30 AND 39 THEN '30-39'
		WHEN customer_age BETWEEN 40 AND 49 THEN '20-29'
		ELSE '50 and above'
	END AS age_gorup,
	CASE 
		WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales < 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency, 
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	lifespan,
	-- Compute average order value (AVO)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders 
	END AS avg_order_value,

	-- Compute average monthly spend
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan 
	END AS avg_monthly_spend
FROM customer_aggregation


SELECT *
FROM gold.report_cusotmers


/*
=========================================================================================
Product Report
=========================================================================================
Purpose: 
	- This report consolicates key product metrics and behaviors.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory, and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total cusotmers (unique)
		- lifespan (in months)
	4. Calculate valueable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
==================================================================================================
*/

CREATE VIEW gold.report_product AS
WITH base_query_product AS (
/*-------------------------------------------------------------------------
1) Base Query; Retrieves core columns form fact_sales and dim_products
-------------------------------------------------------------------*/
SELECT 
	f.order_number,
	f.order_date,
	f.customer_key,
	f.sales_amount,
	f.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.sub_category,
	p.product_cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL -- only consider valid sales dates
),

product_aggregations AS (
/*--------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
-----------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	category,
	sub_category,
	product_cost,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_cusotmers,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT)/ NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query_product
GROUP BY 
	product_key,
	product_name,
	category,
	sub_category,
	product_cost
)

/* ---------------------------------------------------------------------------
3) Final Query: Combines all product results into one output
-----------------------------------------------------------------------------*/

SELECT 
	product_key,
	product_name,
	category,
	sub_category,
	product_cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_month,
	CASE	
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS prodcut_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_cusotmers,
	avg_selling_price,
	--Avgerage Order Revenue (AOR)
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/ total_orders
	END AS avg_order_revenue,

	--Average Montly Revenue
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales/ lifespan
	END AS avg_monthly_revenue
FROM product_aggregations 

SELECT *
FROM gold.report_product