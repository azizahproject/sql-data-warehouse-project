-- ================================================
-- Author: Azizah
-- Source Project: DataWithBaraa
-- Purpose: Load raw data into the Bronze Layer
-- Database: DataWarehouse
-- Schema: bronze
--
-- Description:
--   - This procedure loads CSV files from local folders
--     into the bronze schema tables.
--   - Each table is truncated before loading (data replaced).
--
-- ⚠️ WARNING:
--   Running this procedure will TRUNCATE all Bronze tables.
--   Any existing data will be permanently deleted and replaced
--   with the contents of the CSV files.
--
-- Usage:
--   EXEC bronze.load_bronze
-- ================================================

-- Execute the procedure manually using:
EXEC bronze.load_bronze  /* execute only this line */

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    SET @batch_start_time = GETDATE();

    BEGIN TRY
        PRINT '=================================================================';
        PRINT '                  LOADING BRONZE LAYER';
        PRINT '=================================================================';

        -- ===========================================================
        -- CRM SOURCE TABLES
        -- ===========================================================
        PRINT '-----------------------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-----------------------------------------------------------------';

        ----------------------------------------------------------------
        -- Table: bronze.crm_cust_info
        ----------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;  -- Clears table before loading

        PRINT '>> Inserting Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'D:\001_Prepare For Work\03_Data Analyst\02_SQL\Project\001_Data Warehouse-Baraa\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,            -- Skip header row
            FIELDTERMINATOR = ',',   -- CSV delimiter
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------------------------------------------------';


        ----------------------------------------------------------------
        -- Table: bronze.crm_prd_info
        ----------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'D:\001_Prepare For Work\03_Data Analyst\02_SQL\Project\001_Data Warehouse-Baraa\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------------------------------------------------';


        ----------------------------------------------------------------
        -- Table: bronze.crm_sales_details
        ----------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'D:\001_Prepare For Work\03_Data Analyst\02_SQL\Project\001_Data Warehouse-Baraa\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------------------------------------------------';


        -- ===========================================================
        -- ERP SOURCE TABLES
        -- ===========================================================
        PRINT '-----------------------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-----------------------------------------------------------------';

        ----------------------------------------------------------------
        -- Table: bronze.erp_cust_az12
        ----------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\001_Prepare For Work\03_Data Analyst\02_SQL\Project\001_Data Warehouse-Baraa\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------------------------------------------------';


        ----------------------------------------------------------------
        -- Table: bronze.erp_loc_a101
        ----------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\001_Prepare For Work\03_Data Analyst\02_SQL\Project\001_Data Warehouse-Baraa\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------------------------------------------------';


        ----------------------------------------------------------------
        -- Table: bronze.erp_px_cat_g1v2
        ----------------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\001_Prepare For Work\03_Data Analyst\02_SQL\Project\001_Data Warehouse-Baraa\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------------------------------------------------';


        -- ===========================================================
        -- FINISHING
        -- ===========================================================
        SET @batch_end_time = GETDATE();
        PRINT '===========================================================';
        PRINT '✅ Bronze Layer Load Completed Successfully';
        PRINT '   Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '===========================================================';

    END TRY

    BEGIN CATCH
        PRINT '===========================================================';
        PRINT '❌ ERROR OCCURRED DURING BRONZE LAYER LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '===========================================================';
    END CATCH
END;
GO
