-- ===========================================================
-- PROJECT       : Data Warehouse
-- LAYER         : GOLD
-- SCRIPT        : quality_check_gold.sql
-- AUTHOR        : Azizah
-- SOURCE PROJECT: DataWithBaraa
-- DATE          : November 3, 2025
--
-- DESCRIPTION:
--   This script performs comprehensive quality checks to validate
--   the integrity, consistency, and analytical readiness of the
--   GOLD Layer data model.
--
-- OBJECTIVES:
--   • Ensure uniqueness of surrogate keys in dimension tables.
--   • Validate referential integrity between fact and dimension tables.
--   • Confirm relationship accuracy and completeness for reporting use.
--
-- USAGE NOTES:
--   • Execute after all GOLD layer views/tables are refreshed.
--   • Investigate and resolve any discrepancies or anomalies found.
-- ===========================================================


-- ===========================================================
-- SECTION: CHECKING gold.dim_customers - DUPLICATE CHECK
-- PURPOSE: Identify duplicate customer IDs after merging CRM and ERP sources.
-- =========================================================== 
SELECT cst_id, COUNT(*) FROM
	(SELECT
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
	ON		  ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON		  ci.cst_key = la.cid
)t GROUP BY cst_id
HAVING COUNT(*) > 1

-- ===========================================================
-- SECTION: CHECKING gold.dim_customers - DATA INTEGRATION CHECK
-- PURPOSE: Validate and align gender field between CRM and ERP systems.
-- ===========================================================
SELECT DISTINCT
		ci.cst_gndr,
		ca.gen,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  --CRM is the master for gender info
		ELSE COALESCE(ca.gen, 'n/a')
		END AS new_gen
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
	ON		  ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON		  ci.cst_key = la.cid
	ORDER BY 1,2

-- ===========================================================
-- SECTION: CHECKING gold.dim_product - DUPLICATE CHECK
-- PURPOSE: Identify duplicate product key after merging CRM and ERP sources.
-- ===========================================================
SELECT prd_key, COUNT(*) FROM (
SELECT
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filter out all historical data

)t GROUP BY prd_key HAVING COUNT(*) > 1

-- ===========================================================
-- SECTION: CHECKING gold.fact_sales - Connectivity between dim-fact
-- PURPOSE: Identify the data model connectivity between fact and dimensions.
-- ===========================================================
SELECT * FROM gold.dim_customers

SELECT DISTINCT gender FROM gold.dim_customers

SELECT * FROM gold.dim_product

select * from gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_product p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL
