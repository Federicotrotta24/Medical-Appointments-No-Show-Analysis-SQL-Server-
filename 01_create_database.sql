
-- Create database
IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = 'MedicalAppointmentsDB'
)
BEGIN
    CREATE DATABASE MedicalAppointmentsDB;
END
GO

-- Use database
USE MedicalAppointmentsDB;
GO

-- Create raw table
IF OBJECT_ID('dbo.appointments_raw', 'U') IS NOT NULL
    DROP TABLE dbo.appointments_raw;
GO

CREATE TABLE dbo.appointments_raw (
    patient_id VARCHAR(50),
    appointment_id VARCHAR(50),
    gender VARCHAR(10),
    scheduled_date DATETIME,
    appointment_date DATETIME,
    age INT,
    neighbourhood VARCHAR(100),
    scholarship INT,
    hypertension INT,
    diabetes INT,
    alcoholism INT,
    handicap INT,
    sms_received INT,
    no_show VARCHAR(10)
);
GO