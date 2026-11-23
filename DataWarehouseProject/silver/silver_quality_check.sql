/*
=======================================================================
DATA EXPLORATION
=======================================================================
*/

SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[crm_cust_info]
SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[crm_prd_info]
SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[crm_sales_details]

SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[erp_px_cat_g1v2]
SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[erp_cust_az12]
SELECT TOP (1000) * FROM [DataWarehouse].[bronze].[erp_loc_a101]

/*
==============================================================
DATA QUALITY CHECKS
==============================================================
*/

-- ------------------------------------------------------------
-- Table Under Data Quality Check : bronze.crm_cust_info
-- ------------------------------------------------------------

-- Check 1.
--Check for nulls or Duplicate in Primary key
--Expectation : No Result

SELECT *
FROM (
	SELECT 
		cst_id,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date) AS flag
	FROM bronze.crm_cust_info
)T
WHERE flag > 1 OR cst_id IS NULL;

-- Check 2.
--Check for unwanted spaces for string values

SELECT *
FROM bronze.crm_cust_info;

-- columne : cst_key
SELECT 
	cst_key,
	TRIM(cst_key) AS trim_val,
	LEN(cst_key) AS org_len,
	LEN(TRIM(cst_key)) AS len_after_trim
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- columne : cst_firstname
SELECT 
	cst_firstname,
	TRIM(cst_firstname) AS trim_val,
	LEN(cst_firstname) AS org_len,
	LEN(TRIM(cst_firstname)) AS len_after_trim
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- columne : cst_lastname
SELECT 
	cst_lastname,
	TRIM(cst_lastname) AS trim_val,
	LEN(cst_lastname) AS org_len,
	LEN(TRIM(cst_lastname)) AS len_after_trim
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);


-- columne : cst_marital_status
SELECT 
	cst_marital_status,
	TRIM(cst_marital_status) AS trim_val,
	LEN(cst_marital_status) AS org_len,
	LEN(TRIM(cst_marital_status)) AS len_after_trim
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

-- columne : cst_gndr
SELECT 
	cst_gndr,
	TRIM(cst_gndr) AS trim_val,
	LEN(cst_gndr) AS org_len,
	LEN(TRIM(cst_gndr)) AS len_after_trim
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- NULL VALUES
SELECT
    COUNT_BIG(*) AS total_records,

    SUM(CASE WHEN cst_id IS NULL
        THEN 1 ELSE 0 END) AS null_cst_id,

    SUM(CASE WHEN cst_key IS NULL
        THEN 1 ELSE 0 END) AS null_cst_key,

    SUM(CASE WHEN cst_firstname IS NULL
        THEN 1 ELSE 0 END) AS null_firstname,

    SUM(CASE WHEN cst_lastname IS NULL
        THEN 1 ELSE 0 END) AS null_lastname,

    SUM(CASE WHEN cst_marital_status IS NULL
        THEN 1 ELSE 0 END) AS null_marital_status,

    SUM(CASE WHEN cst_gndr IS NULL
        THEN 1 ELSE 0 END) AS null_gender,

    SUM(CASE WHEN cst_create_date IS NULL 
        THEN 1 ELSE 0 END)  AS null_cst_create_date

FROM bronze.crm_cust_info;

-- Check for NULL and duplicate customer IDs

SELECT
    cst_id,
    COUNT_BIG(*) AS occurrence_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING
    cst_id IS NULL
    OR COUNT_BIG(*) > 1;

SELECT
    c.cst_id,
    v.column_name,
    v.column_value
FROM bronze.crm_cust_info c

CROSS APPLY (
    VALUES
        ('cst_key', c.cst_key),
        ('cst_firstname', c.cst_firstname),
        ('cst_lastname', c.cst_lastname),
        ('cst_marital_status', c.cst_marital_status),
        ('cst_gndr', c.cst_gndr)
) v(column_name, column_value)

WHERE
    v.column_value IS NOT NULL
    AND DATALENGTH(v.column_value)
        <> DATALENGTH(TRIM(v.column_value));

        --Data Standardization & Consistency

SELECT DISTINCT 
    cst_gndr
FROM bronze.crm_cust_info
SELECT DISTINCT 
    cst_marital_status
FROM bronze.crm_cust_info

SELECT 
cst_create_date
FROM bronze.crm_cust_info;

-- ------------------------------------------------------------
-- Table Under Data Quality Check : bronze.crm_prd_info
-- ------------------------------------------------------------

-- CHECK 1
-- check for null and duplicate prd_id
-- Expectation: No result 

SELECT 
    prd_id,
    COUNT_BIG(prd_id) AS duplicate_prd_id_cnt
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT_BIG(*) > 1 OR prd_id IS NULL;

SELECT 
    prd_key,
    COUNT_BIG(prd_key) AS duplicate_prd_key_cnt
FROM bronze.crm_prd_info
GROUP BY prd_key
HAVING COUNT_BIG(*) > 1;

-- CHECK for null values 

SELECT 
    COUNT_BIG(*) AS ttl_records,
    SUM(CASE WHEN prd_id IS NULL
        THEN 1 ELSE 0 END) AS null_prd_id,
    SUM(CASE WHEN prd_key IS NULL 
        THEN 1 ELSE 0 END) AS null_prd_key,
    SUM(CASE WHEN prd_nm IS NULL 
        THEN 1 ELSE 0 END) AS null_prd_nm,
    SUM(CASE WHEN prd_cost IS NULL 
        THEN 1 ELSE 0 END) AS null_prd_cost,
    SUM(CASE WHEN prd_line IS NULL
        THEN 1 ELSE 0 END) AS null_prd_line,
    SUM(CASE WHEN prd_start_dt IS NULL
        THEN 1 ELSE 0 END) AS null_prd_start_dt,
    SUM(CASE WHEN prd_end_dt IS NULL
        THEN 1 ELSE 0 END) AS null_prd_prd_end_dt
FROM bronze.crm_prd_info

--CHECK 2
-- Check for unwanted space in string columns

SELECT 
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info

SELECT 
    prd_key,
    DATALENGTH(prd_key) AS len_prd_key,
    DATALENGTH(TRIM(prd_key)) AS len_after_trim_prd_key
FROM bronze.crm_prd_info
WHERE prd_key != TRIM(prd_key)

SELECT 
    prd_nm,
    DATALENGTH(prd_nm) AS len_prd_key,
    DATALENGTH(TRIM(prd_nm)) AS len_after_trim_prd_key
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--check for null or negative number 
SELECT 
    prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

--Data standardization and consistency

SELECT 
    DISTINCT prd_line
FROM bronze.crm_prd_info

select *
from bronze.erp_px_cat_g1v2

--Check for invalid order date 

SELECT 
    *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ------------------------------------------------------------
-- Table Under Data Quality Check : bronze.crm_sales_details
-- ------------------------------------------------------------

SELECT 
    sls_ord_num,
    TRIM(sls_prd_key) AS sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details

--Check for invalid Dates 

SELECT 
NULLIF(sls_order_dt,0)
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8 
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101


SELECT 
sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
OR LEN(sls_ship_dt) != 8 
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101


SELECT 
sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
OR LEN(sls_ship_dt) != 8 
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101

--Check for invalid Date orders

SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt

--Check Data Consistency: Between Sales, Qantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero , or negative


SELECT 
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_sales < 0 
OR sls_quantity < 0 
OR sls_price < 0 
OR sls_sales IS NULL 
OR sls_quantity IS NULL
OR sls_price IS NULL
OR sls_quantity * sls_price !=  sls_sales
ORDER BY sls_sales, sls_quantity, sls_price;

SELECT 
    sls_sales,	
    CASE 
		WHEN sls_sales < 0 THEN ABS(sls_sales)
		WHEN sls_sales IS NULL THEN 0
		WHEN (sls_quantity * sls_price) !=  sls_sales THEN ISNULL(ABS(sls_quantity),0) * ISNULL(ABS(sls_price),0)
	END sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_sales < 0 Or (sls_quantity * sls_price) !=  sls_sales;

-- ------------------------------------------------------------
-- Table Under Data Quality Check : bronze.erp_cust_az12
-- ------------------------------------------------------------
SELECT 
	CASE 
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END cid,
	bdate,
	gen
FROM bronze.erp_cust_az12
WHERE 	CASE 
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

SELECT 
    cid,
    bdate,
    gen
FROM bronze.erp_cust_az12

--Identify Out of range Date

SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standardization & Consistency

SELECT DISTINCT gen
FROM bronze.erp_cust_az12;


-- ------------------------------------------------------------
-- Table Under Data Quality Check : bronze.erp_loc_a101
-- ------------------------------------------------------------

SELECT 
	REPLACE(cid, '-', '') AS cid,
	cntry,
    CASE 
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry) 
    END cntry
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info)

SELECT cst_key FROM silver.crm_cust_info

SELECT DISTINCT
cntry 
FROM bronze.erp_loc_a101

-- ------------------------------------------------------------
-- Table Under Data Quality Check : bronze.erp_px_cat_g1v2
-- ------------------------------------------------------------
 SELECT 
	id,
	cat,
	subcat,
	maintenance
 FROM bronze.erp_px_cat_g1v2

 SELECT *
 FROM bronze.erp_px_cat_g1v2
 WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)