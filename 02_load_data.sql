-- 02_load_data.sql

USE MedicalAppointmentsDB;
GO

-- Load data into raw table
BULK INSERT dbo.appointments_raw
FROM '/var/opt/mssql/KaggleV2-May-2016.csv'
WITH (
    FIRSTROW = 2,              -- Skip header
    FIELDTERMINATOR = ',',     -- CSV delimiter
    ROWTERMINATOR = '\n',      -- New line
    TABLOCK
);
GO