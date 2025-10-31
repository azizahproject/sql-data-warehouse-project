-- ================================================
-- Author: Azizah
-- Purpose: Create raw data tables in the 'bronze' schema
-- Database: DataWarehouse
-- Schema: bronze
-- Description:
--   This script drops and recreates raw tables sourced
--   from CRM and ERP systems.
--
-- ⚠️ WARNING:
--   Running this script will DELETE existing tables (if they exist)
--   and recreate them from scratch.
--   All existing data in these tables will be lost.
-- ================================================

-- ===========================================================
-- CRM SOURCE TABLES
-- ===========================================================

-- Drop and recreate customer information table
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,            -- Customer ID (primary identifier)
    cst_key             NVARCHAR(50),   -- External source key
    cst_firstname       NVARCHAR(50),   -- Customer's first name
    cst_lastname        NVARCHAR(50),   -- Customer's last name
    cst_marital_status  NVARCHAR(50),   -- Marital status
    cst_gndr            NVARCHAR(50),   -- Gender
    cst_create_date     DATE            -- Record creation date
);
GO

-- Drop and recreate product information table
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id          INT,                -- Product ID
    prd_key         NVARCHAR(50),       -- External source key
    prd_nm          NVARCHAR(50),       -- Product name
    prd_cost        INT,                -- Product cost
    prd_line        NVARCHAR(50),       -- Product line/category
    prd_start_dt    DATETIME,           -- Product availability start date
    prd_end_dt      DATETIME            -- Product end/discontinue date
);
GO

-- Drop and recreate sales details table
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num     NVARCHAR(50),   -- Sales order number
    sls_prd_key     NVARCHAR(50),   -- Product key (links to crm_prd_info)
    sls_cust_id     INT,            -- Customer ID (links to crm_cust_info)
    sls_order_dt    INT,            -- Order date (as integer, raw format)
    sls_ship_dt     INT,            -- Shipping date (as integer, raw format)
    sls_due_dt      INT,            -- Due date (as integer, raw format)
    sls_sales       INT,            -- Total sales amount
    sls_quantity    INT,            -- Quantity sold
    sls_price       INT             -- Unit price
);
GO


-- ===========================================================
-- ERP SOURCE TABLES
-- ===========================================================

-- Drop and recreate location table
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid     NVARCHAR(50),   -- Location ID / Code
    cntry   NVARCHAR(50)    -- Country name
);
GO

-- Drop and recreate customer demographics table
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid         NVARCHAR(50),       -- Customer ID
    bdate       DATE,               -- Birth date
    gen         NVARCHAR(50)        -- Gender
);
GO

-- Drop and recreate product category mapping table
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id              NVARCHAR(50),       -- Product ID
    cat             NVARCHAR(50),       -- Product category
    subcat          NVARCHAR(50),       -- Product subcategory
    maintenance     NVARCHAR(50)        -- Maintenance flag/description
);
GO

-- ================================================
-- End of Script
-- ================================================
