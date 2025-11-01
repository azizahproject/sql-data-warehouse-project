/*
====================================================================
⚠️  WARNING:
This script will DROP and RECREATE all tables in the SILVER layer.
Running this script will PERMANENTLY DELETE any existing data 
stored in these tables.

Use this script only when initializing or resetting your 
Silver Layer schema structure.

Author: Azizah
Layer: SILVER (Cleaned / Standardized data)
====================================================================
*/


-- ===========================================================
-- CRM SOURCE TABLES (Cleaned versions from Bronze CRM tables)
-- ===========================================================

-- ===========================================================
-- Table: silver.crm_cust_info
-- Purpose: Stores cleaned customer information from CRM system.
-- Notes: Contains standardized personal and demographic data.
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
-- Table: silver.crm_prd_info
-- Purpose: Stores cleaned product information from CRM system.
-- Notes: Used to link product-level details in the sales dataset.
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
-- Table: silver.crm_sales_details
-- Purpose: Stores transactional sales data from CRM system.
-- Notes: Links to crm_cust_info (customer) and crm_prd_info (product).
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
-- Table: silver.erp_loc_a101
-- Purpose: Stores standardized location or country data from ERP.
-- Notes: Used for geographic joins or regional analysis.
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
-- Table: silver.erp_cust_az12
-- Purpose: Stores demographic information from ERP customers.
-- Notes: Can be joined with CRM data to enrich customer profiles.
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
-- Table: silver.erp_px_cat_g1v2
-- Purpose: Maps products to categories and subcategories from ERP.
-- Notes: Supports product classification and hierarchy in analytics.
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
