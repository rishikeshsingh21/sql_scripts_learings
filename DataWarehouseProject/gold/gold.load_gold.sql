/*
====================================================================================
DDL Script: Create Gold Views
====================================================================================

Script Purpose: 
	This script create views for the Gold layer in the data warehouse.
	The Gold layer represents the final dimentional and fact tables (star Schema)

	Each view performs transfomations and combines data from the silver layer
	to produce a clean, enriched, and business ready datasets

Usage:
 - These views can be queried directly for the analytics and reproting.
*/
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY cst_create_date ASC) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE 
		WHEN ci.cst_gndr = 'n/a' THEN ca.gen
		ELSE ci.cst_gndr
	END gender,
	ca.bdate AS birth_date,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;
GO

CREATE VIEW gold.dim_product AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY prd_start_dt ASC) AS product_key,
	prd_id AS product_id,
	prd_key AS product_number,
	prd_nm AS product_name,
	cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS sub_category,
	pc.maintenance AS maintenance,
	prd_cost AS product_cost,
	prd_line AS product_line,
	prd_start_dt AS start_date
FROM silver.crm_prd_info pi
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pi.cat_id = pc.id
WHERE pi.prd_end_dt IS NULL; --Filter out all historical data 
GO

CREATE VIEW gold.fact_sales AS 
SELECT 
	sls_ord_num AS order_number,
	dp.product_key,
	dc.customer_key,
	sls_order_dt AS order_date,
	sls_ship_dt AS shipping_date,
	sls_due_dt AS due_date,
	sls_sales AS sales_amount,
	sls_quantity AS quantity,
	sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_product dp
ON sd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers dc
ON sd.sls_cust_id = dc.customer_id
GO


-- Foreign key Integrity (Dimentions)

SELECT *
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
LEFT JOIN gold.dim_product dp
ON fs.product_key = dp.product_key

select *
from gold.fact_sales