--- Step 1: DW - Create schema tables
.read 01_create_tables_dw.sql


--- Step 2: DW - Load data from CSV files into tables
.read 02_load_schema_dw.sql

-- Step 3: Mart - Create flat mart table
.read 3_create_flat_mart.sql