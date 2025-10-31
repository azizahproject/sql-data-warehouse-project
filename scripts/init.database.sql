-- ================================================
-- Author: Azizah
-- Purpose: Initialize a clean Data Warehouse environment
-- Database: DataWarehouse
-- Description:
--   1. Drops the existing DataWarehouse (if exists)
--   2. Recreates it from scratch
--   3. Defines schemas: bronze, silver, and gold
--      to represent the data processing layers
-- ================================================

/*
	
⚠️ WARNING:
Running this script will PERMANENTLY DELETE the existing
'DataWarehouse' database if it already exists.
All data inside it will be lost and cannot be recovered.
Use this script ONLY in a development or testing environment.
*/

-- Step 1: Use the 'master' database
-- We need to be in 'master' to create or drop databases
USE master;
GO

-- Step 2: Drop the existing 'DataWarehouse' database if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	-- ⚠️ WARNING:
    -- The following commands will forcefully remove all active connections
    -- and permanently drop the existing 'DataWarehouse' database.
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

	-- Drop the database to start fresh
    DROP DATABASE DataWarehouse;
END;
GO

-- Step 3: Create a new 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

-- Step 4: Switch to the newly created 'DataWarehouse'
USE DataWarehouse;
GO

-- Step 5: Create schema layers for data processing
-- -----------------------------------------------
-- BRONZE: Raw data directly ingested from source systems
CREATE SCHEMA bronze;
GO
-- SILVER: Cleaned and standardized data, ready for transformation
CREATE SCHEMA silver;
GO

-- GOLD: Curated, high-quality data ready for analytics and reporting
CREATE SCHEMA gold;
GO

-- ================================================
-- End of Script
-- ================================================
