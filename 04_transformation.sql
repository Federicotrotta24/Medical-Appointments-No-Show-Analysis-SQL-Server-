-- 04_transformation.sql

USE MedicalAppointmentsDB;
GO

-- Drop table if it already exists
IF OBJECT_ID('dbo.appointments_clean', 'U') IS NOT NULL
    DROP TABLE dbo.appointments_clean;
GO

-- Create cleaned/transformed table
SELECT
    patient_id,
    appointment_id,
    gender,
    scheduled_date,
    appointment_date,
    age,
    neighbourhood,
    scholarship,
    hypertension,
    diabetes,
    alcoholism,
    handicap,
    sms_received,
    CASE 
        WHEN no_show = 'No' THEN 1
        WHEN no_show = 'Yes' THEN 0
        ELSE NULL
    END AS assisted,
    DATEDIFF(DAY, scheduled_date, appointment_date) AS days_between
INTO dbo.appointments_clean
FROM dbo.appointments_raw;
GO