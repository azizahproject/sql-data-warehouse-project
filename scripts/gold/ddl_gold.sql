-- ===========================================================
-- PROJECT       : Data Warehouse
-- LAYER         : GOLD
-- AUTHOR        : Azizah
-- DATE          : November 2, 2025
-- SOURCE PROJECT: DataWithBaraa

-- DESCRIPTION:
--   This script builds the GOLD LAYER of the Data Warehouse.
--   The Gold Layer contains analytical-ready datasets derived
--   from the Silver Layer (cleaned and standardized data).
--
--   Includes:
--     1. DIM_CUSTOMERS – unified customer dimension
--     2. DIM_PRODUCT   – unified product dimension
--     3. FACT_SALES    – main sales fact table
--
-- CAUTION:
--   - Re-executing this script will drop and recreate all views.
--   - Ensure Silver Layer data is validated before running.
-- ===========================================================


-- ===========================================================
-- SECTION: Create View - gold.dim_customers
-- PURPOSE: Create a unified customer dimension combining data 
--           from CRM (master) and ERP systems.
-- ===========================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,   -- Surrogate key
    ci.cst_id AS customer_id,                              -- Customer ID from CRM
    ci.cst_key AS customer_number,                         -- Unique customer key
    ci.cst_firstname AS first_name,                        -- Customer first name
    ci.cst_lastname AS last_name,                          -- Customer last name
    la.cntry AS country,                                   -- Country info from ERP
    ci.cst_marital_status AS marital_status,               -- Marital status
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr        -- CRM is gender master
         ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,
    ca.bdate AS birthdate,                                 -- Birth date from ERP
    ci.cst_create_date AS create_date                      -- Customer creation date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la  ON ci.cst_key = la.cid;
GO


-- ===========================================================
-- SECTION: Create View - gold.dim_product
-- PURPOSE: Create unified product dimension combining CRM and ERP.
-- ===========================================================
IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL
    DROP VIEW gold.dim_product;
GO

CREATE VIEW gold.dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,  -- Surrogate key
    pn.prd_id AS product_id,               -- Original product ID from CRM
    pn.prd_key AS product_number,          -- Product key (external)
    pn.prd_nm AS product_name,             -- Product name
    pn.cat_id AS category_id,              -- Derived category ID
    pc.cat AS category,                    -- Category name from ERP
    pc.subcat AS subcategory,              -- Subcategory from ERP
    pc.maintenance,                        -- Maintenance flag
    pn.prd_cost AS cost,                   -- Product cost
    pn.prd_line AS product_line,           -- Product line or type
    pn.prd_start_dt AS start_date          -- Product start date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;               -- Exclude expired products
GO


-- ===========================================================
-- SECTION: Create View - gold.fact_sales
-- PURPOSE: Create sales fact table linking sales, product, and customer data.
-- ===========================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,          -- Sales order number
    pr.product_key,                          -- FK: Product dimension
    cu.customer_key,                         -- FK: Customer dimension
    sd.sls_order_dt AS order_date,           -- Order date
    sd.sls_ship_dt AS shipping_date,         -- Shipping date
    sd.sls_due_dt AS due_date,               -- Payment due date
    sd.sls_sales AS sales,                   -- Total sales amount
    sd.sls_quantity AS quantity,             -- Quantity sold
    sd.sls_price AS price                    -- Unit price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_product pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO


-- ===========================================================
-- END OF SCRIPT
-- NOTES:
--   - Validate record counts in each view.
--   - Ensure data consistency across foreign keys.
-- ===========================================================
