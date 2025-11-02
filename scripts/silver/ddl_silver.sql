-- ===========================================================
-- PROJECT : Data Warehouse Development
-- LAYER   : SILVER
-- AUTHOR  : Azizah
-- DATE    : November 2, 2025
--
-- DESCRIPTION:
--   This script defines all cleaned and standardized tables 
--   for the SILVER layer. Data in this layer is transformed 
--   from BRONZE sources to ensure consistency, structure, 
--   and readiness for analytical processing.
--
-- CAUTION:
--   ⚠️ Running this script will DROP and RECREATE all SILVER tables.
--   This action will PERMANENTLY DELETE any existing data 
--   stored in these tables.
-- ===========================================================


-- ===========================================================
-- CRM SOURCE TABLES (Cleaned versions from Bronze CRM tables)
-- ===========================================================

-- ===========================================================
-- SECTION: Create Table - silver.crm_cust_info
-- PURPOSE: Store cleaned customer information from CRM system.
-- NOTES  : Includes standardized demographic data and auto timestamp.
-- ===========================================================

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id              INT,            -- Customer ID (primary identifier)
    cst_key             NVARCHAR(50),   -- External source key from CRM
    cst_firstname       NVARCHAR(50),   -- Customer's first name
    cst_lastname        NVARCHAR(50),   -- Customer's last name
    cst_marital_status  NVARCHAR(50),   -- Marital status (e.g., Single, Married)
    cst_gndr            NVARCHAR(50),   -- Gender (standardized values: 'M', 'F')
    cst_create_date     DATE,           -- Record creation date (cleaned format)
    dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Automatically stores the timestamp
);
GO


-- ===========================================================
-- SECTION: Create Table - silver.crm_prd_info
-- PURPOSE: Store cleaned product data from CRM system.
-- NOTES  : Used for product-level analysis and sales linkage.
-- ===========================================================
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,                -- Product ID (primary key)
    cat_id          NVARCHAR(50),       -- Update coloumn after check data quality
    prd_key         NVARCHAR(50),       -- External product key
    prd_nm          NVARCHAR(50),       -- Product name
    prd_cost        INT,                -- Product cost or base price
    prd_line        NVARCHAR(50),       -- Product category or line
    prd_start_dt    DATE,               -- Start date of availability
    prd_end_dt      DATE,               -- End or discontinue date
    dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Automatically stores the timestamp
);
GO


-- ===========================================================
-- SECTION: Create Table - silver.crm_sales_details
-- PURPOSE: Store transactional sales data from CRM.
-- NOTES  : Links to customers and products for building fact tables.
-- ===========================================================
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),   -- Sales order number
    sls_prd_key     NVARCHAR(50),   -- Product key (foreign key to crm_prd_info)
    sls_cust_id     INT,            -- Customer ID (foreign key to crm_cust_info)
    sls_order_dt    DATE,            -- Order date (raw integer, to be cleaned later)
    sls_ship_dt     DATE,            -- Shipping date (raw integer, to be cleaned later)
    sls_due_dt      DATE,            -- Due date (raw integer, to be cleaned later)
    sls_sales       INT,            -- Total sales amount
    sls_quantity    INT,            -- Quantity sold
    sls_price       INT,            -- Unit price
    dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Automatically stores the timestamp
);
GO



-- ===========================================================
-- ERP SOURCE TABLES (Cleaned versions from Bronze ERP tables)
-- ===========================================================

-- ===========================================================
-- SECTION: Create Table - silver.erp_loc_a101
-- PURPOSE: Store standardized location/country data from ERP.
-- NOTES  : Supports geographic segmentation and joins.
-- ===========================================================
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid     NVARCHAR(50),   -- Location ID or code
    cntry   NVARCHAR(50),   -- Country name (standardized spelling)
    dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Automatically stores the timestamp
);
GO


-- ===========================================================
-- SECTION: Create Table - silver.erp_cust_az12
-- PURPOSE: Store demographic information for ERP customers.
-- NOTES  : Used to enrich CRM profiles with birthdate and gender data.
-- ===========================================================
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    cid         NVARCHAR(50),       -- Customer ID (matches ERP system)
    bdate       DATE,               -- Birth date (cleaned format)
    gen         NVARCHAR(50),       -- Gender (standardized: 'M'/'F')
    dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Automatically stores the timestamp
);
GO


-- ===========================================================
-- SECTION: Create Table - silver.erp_px_cat_g1v2
-- PURPOSE: Store product category and subcategory mappings.
-- NOTES  : Supports classification and product hierarchy analytics.
-- ===========================================================
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id              NVARCHAR(50),       -- Product ID (matches ERP system)
    cat             NVARCHAR(50),       -- Product category (e.g., Electronics)
    subcat          NVARCHAR(50),       -- Subcategory (e.g., Mobile Phones)
    maintenance     NVARCHAR(50),       -- Maintenance description/flag
    dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Automatically stores the timestamp
);
GO


-- ===========================================================
-- ✅ End of Script
-- All Silver Layer tables successfully defined.
-- ===========================================================
