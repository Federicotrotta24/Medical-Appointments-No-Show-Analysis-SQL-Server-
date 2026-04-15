-- 03_exploration.sql

USE MedicalAppointmentsDB;
GO

-- Preview data
SELECT TOP 10 *
FROM dbo.appointments_raw;
GO

-- Total number of rows
SELECT COUNT(*) AS total_rows
FROM dbo.appointments_raw;
GO

-- Table schema / column info
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'appointments_raw';
GO