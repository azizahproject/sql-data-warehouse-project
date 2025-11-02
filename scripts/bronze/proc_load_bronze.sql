-- ===========================================================
-- PROJECT       : Data Warehouse Development
-- LAYER         : BRONZE
-- SCRIPT        : proc_load_bronze.sql
-- AUTHOR        : Azizah
-- DATE          : October 31, 2025
-- SOURCE PROJECT: DataWithBaraa
--
-- DESCRIPTION:
--   This stored procedure performs bulk data loading into
--   all BRONZE layer tables from raw CSV files.
--   It serves as the ingestion layer for the data warehouse,
--   ensuring all CRM and ERP data sources are centralized
--   and ready for transformation into the SILVER layer.
--
-- CAUTION:
--   ⚠️ This process TRUNCATES all existing BRONZE tables before loading.
--   Ensure data sources are validated and accessible before execution.
-- ===========================================================

-- ===========================================================
-- EXECUTION COMMAND (Run this only once to trigger the process)
-- ===========================================================
EXEC bronze.load_bronze;
GO

-- ===========================================================
-- SECTION: PROCEDURE DEFINITION
-- PURPOSE: Define the main procedure to load all BRONZE layer data.
-- ===========================================================

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
        -- SECTION: CRM SOURCE TABLES
        -- PURPOSE: Load raw data from CRM CSV files.
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
        -- SECTION: ERP SOURCE TABLES
        -- PURPOSE: Load raw data from ERP CSV files.
        -- ==========================================================
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
        -- SECTION: COMPLETION LOG
        -- PURPOSE: Log successful batch completion details.
        -- ===========================================================
        SET @batch_end_time = GETDATE();
        PRINT '===========================================================';
        PRINT '✅ Bronze Layer Load Completed Successfully';
        PRINT '   Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '===========================================================';

    END TRY

        -- ===========================================================
        -- SECTION: ERROR HANDLING
        -- PURPOSE: Capture and display detailed error information.
        -- ===========================================================
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

-- ===========================================================
-- ✅ END OF SCRIPT
-- The procedure [bronze.load_bronze] has been created successfully.
-- ===========================================================
