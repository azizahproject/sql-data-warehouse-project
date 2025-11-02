-- ===========================================================
-- PROJECT: DATA WAREHOUSE DEVELOPMENT (GOLD LAYER)
-- AUTHOR: Azizah
-- DATE CREATED: November 2, 2025
-- 
-- DESCRIPTION:
--   This script builds the GOLD LAYER for the Data Warehouse.
--   The Gold Layer contains curated, analytical-ready datasets 
--   derived from the Silver Layer (cleaned and transformed data).
--
--   It consists of:
--     1. DIM_CUSTOMERS  –  Customer dimension combining CRM and ERP data
--     2. DIM_PRODUCT    –  Product dimension integrating CRM products 
--                          with ERP category and maintenance info
--     3. FACT_SALES     –  Central fact table combining sales transactions 
--                          with related customer and product dimensions
--
--   Each object in this layer is created as a SQL VIEW to ensure 
--   real-time consistency with upstream Silver data, while preserving 
--   analytical integrity for BI consumption (Power BI, Tableau, etc).
--
-- CAUTION:
--   - Re-executing this script will drop and recreate the views.
--   - Ensure Silver Layer data is refreshed and validated before running.
--
-- ===========================================================



-- ===========================================================
-- GOLD LAYER: DIM_CUSTOMERS
-- Purpose: To create a clean, unified customer dimension view
-- combining data from CRM and ERP systems.
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
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr        -- Use CRM gender as master
         ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,
    ca.bdate AS birthdate,                                 -- Birth date from ERP
    ci.cst_create_date AS create_date                      -- Customer creation date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la  ON ci.cst_key = la.cid;
GO

-- ===========================================================
-- GOLD LAYER: DIM_PRODUCT
-- Purpose: Create a unified product dimension by combining
--          product details from CRM and category info from ERP.
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
    pn.cat_id AS category_id,              -- Derived category ID (from transformation)
    pc.cat AS category,                    -- Product category name
    pc.subcat AS subcategory,              -- Product subcategory
    pc.maintenance,                        -- Maintenance status/flag
    pn.prd_cost AS cost,                   -- Product cost
    pn.prd_line AS product_line,           -- Product line or segment
    pn.prd_start_dt AS start_date          -- Availability start date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;               -- Only include active products
GO

-- ===========================================================
-- GOLD LAYER: FACT_SALES
-- Purpose: Create a unified sales fact table by combining
--          transactional data from CRM with product and
--          customer dimensions for analytical reporting.
-- ===========================================================

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,          -- Unique sales order number
    pr.product_key,                          -- FK to product dimension
    cu.customer_key,                         -- FK to customer dimension
    sd.sls_order_dt AS order_date,           -- Order date
    sd.sls_ship_dt AS shipping_date,         -- Shipping date
    sd.sls_due_dt AS due_date,               -- Due date for payment
    sd.sls_sales AS sales,                   -- Total sales amount
    sd.sls_quantity AS quantity,             -- Number of items sold
    sd.sls_price AS price                    -- Price per unit
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_product pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
