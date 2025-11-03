-- ===========================================================
-- Data Quality Check: bronze.crm_cust_info
-- ===========================================================

SELECT
*
FROM bronze.crm_cust_info

SELECT
COUNT (*)
FROM bronze.crm_cust_info


-- Check for duplicate or null in Primary Key - cst_id
-- Expectation: No Result
SELECT
	cst_id, 
	COUNT (*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL


-- Check for unwanted spaces for string coloumn
-- Expectation: No Result
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname) -- TRIM(): Removes leadind and trailing spaces from string

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr)

-- Data Standarization $ Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info


-- ===========================================================
-- Data Quality Check: bronze.crm_prd_info
-- ===========================================================
SELECT
*
FROM bronze.crm_prd_info

-- Check for duplicate or null in Primary Key - prd_id
-- Expectation: No Result
SELECT
	prd_id, 
	COUNT (*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for unwanted spaces for string coloumn
-- Expectation: No Result
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Checj for Nulls or negative numbers
-- Expectation: No Results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standarization $ Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

--Check for invalid date orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- ===========================================================
-- Data Quality Check: bronze.crm_sales_details
-- ===========================================================
SELECT
*
FROM bronze.crm_sales_details

-- Check for unwanted spaces
-- Expectation: No Result
SELECT sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num!= TRIM(sls_ord_num)

-- Check coloumn can join or not
SELECT sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT sls_cust_id
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

-- Check for invalid dates
SELECT sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0

SELECT 
NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN (sls_order_dt) !=8 
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

SELECT 
NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
OR LEN (sls_ship_dt) !=8 
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101

SELECT 
NULLIF(sls_due_dt, 0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
OR LEN (sls_due_dt) !=8 
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

-- Check for invalid date orders
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt


-- Check data consistency: between sales, quantity, and price
-- >> Sales = Quantity * Prize
-- >> Values must not be null, zero, or ngative.

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,

CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS (SLS_price)
	THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <= 0
	THEN sls_sales / NULLIF (sls_quantity, 0)
ELSE sls_price
END AS sls_price

FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price



-- ===========================================================
-- Data Quality Check: bronze.erp_cust_az12
-- ===========================================================

SELECT
cid,
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid, 4, LEN(cid))
ELSE cid
END AS cid,
bdate,
gen
FROM bronze.erp_cust_az12

-- Check coloumn can connect or not
SELECT
cid,
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid, 4, LEN(cid))
ELSE cid
END AS cid,
bdate,
gen
FROM bronze.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid, 4, LEN(cid))
ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)


SELECT *
FROM silver.crm_cust_info

-- Identify out-of-range dates
SELECT DISTINCT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data stadardization & consistensy
SELECT DISTINCT gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12


-- ===========================================================
-- Data Quality Check: bronze.erp_loc_a101
-- ===========================================================
SELECT
REPLACE(cid,'-','') cid,
cntry
FROM bronze.erp_loc_a101

--WHERE REPLACE(cid,'-','') NOT IN
--(SELECT cst_key FROM silver.crm_cust_info)

-- Data stadardization & consistensy
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry

SELECT 
REPLACE(cid,'-','') cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'  
	WHEN  TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101

-- ===========================================================
-- Data Quality Check: bronze.erp_px_cat_g1v2
-- ===========================================================

SELECT *
FROM bronze.erp_px_cat_g1v2

SELECT
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2


-- Check unwanted spaces
SELECT
*
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat)

SELECT
*
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat)

SELECT
*
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance)

-- Data stadardization & consistensy
SELECT DISTINCT
cat
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT
subcat
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2

