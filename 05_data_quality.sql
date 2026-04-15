-- 05_data_quality.sql

USE MedicalAppointmentsDB;
GO

/* =========================================================
   1. Validate source transformed table
========================================================= */

-- Check if appointments_clean exists
SELECT
    SCHEMA_NAME(t.schema_id) AS schema_name,
    t.name AS table_name
FROM sys.tables t
WHERE t.name = 'appointments_clean';
GO

-- Total rows
SELECT COUNT(*) AS total_rows
FROM dbo.appointments_clean;
GO

-- Preview data
SELECT TOP 10 *
FROM dbo.appointments_clean;
GO

/* =========================================================
   2. Null checks
========================================================= */

SELECT
    SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END) AS null_patient_id,
    SUM(CASE WHEN appointment_id IS NULL THEN 1 ELSE 0 END) AS null_appointment_id,
    SUM(CASE WHEN scheduled_date IS NULL THEN 1 ELSE 0 END) AS null_scheduled_date,
    SUM(CASE WHEN appointment_date IS NULL THEN 1 ELSE 0 END) AS null_appointment_date,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN assisted IS NULL THEN 1 ELSE 0 END) AS null_assisted
FROM dbo.appointments_clean;
GO

/* =========================================================
   3. Invalid values
========================================================= */

SELECT
    SUM(CASE WHEN gender NOT IN ('F', 'M') THEN 1 ELSE 0 END) AS invalid_gender,
    SUM(CASE WHEN age < 0 OR age > 100 THEN 1 ELSE 0 END) AS invalid_age,
    SUM(CASE WHEN days_between < 0 THEN 1 ELSE 0 END) AS invalid_days_between,
    SUM(CASE WHEN assisted NOT IN (0, 1) THEN 1 ELSE 0 END) AS invalid_assisted
FROM dbo.appointments_clean;
GO

-- Invalid ages
SELECT age
FROM dbo.appointments_clean
WHERE age < 0 OR age > 100;
GO

-- Invalid waiting time:
-- waiting time = days between scheduling date and appointment date
SELECT days_between
FROM dbo.appointments_clean
WHERE days_between < 0;
GO

/* =========================================================
   4. Duplicate checks
========================================================= */

-- Duplicate appointment IDs
SELECT appointment_id, COUNT(*) AS cnt
FROM dbo.appointments_clean
GROUP BY appointment_id
HAVING COUNT(*) > 1;
GO

-- Summary of duplicates
SELECT
    COUNT(*) AS total_appointment_ids,
    COUNT(DISTINCT appointment_id) AS unique_appointment_ids,
    COUNT(*) - COUNT(DISTINCT appointment_id) AS duplicate_appointment_ids
FROM dbo.appointments_clean;
GO

-- Preview one duplicated appointment_id
SELECT TOP 10 *
FROM dbo.appointments_clean
WHERE appointment_id = (
    SELECT TOP 1 appointment_id
    FROM dbo.appointments_clean
    GROUP BY appointment_id
    HAVING COUNT(*) > 1
);
GO

/* =========================================================
   5. Create deduplicated table
========================================================= */

IF OBJECT_ID('dbo.appointments_clean_dedup', 'U') IS NOT NULL
    DROP TABLE dbo.appointments_clean_dedup;
GO

SELECT DISTINCT *
INTO dbo.appointments_clean_dedup
FROM dbo.appointments_clean;
GO

SELECT COUNT(*) AS total_rows_dedup
FROM dbo.appointments_clean_dedup;
GO

/* =========================================================
   6. Create final cleaned table
========================================================= */

IF OBJECT_ID('dbo.appointments_clean_final', 'U') IS NOT NULL
    DROP TABLE dbo.appointments_clean_final;
GO

SELECT *
INTO dbo.appointments_clean_final
FROM dbo.appointments_clean_dedup
WHERE age BETWEEN 0 AND 100
  AND days_between >= 0;
GO

SELECT COUNT(*) AS total_rows_final
FROM dbo.appointments_clean_final;
GO

/* =========================================================
   7. Clean neighbourhood encoding issues
========================================================= */

-- Review distinct neighbourhood values before cleaning
SELECT DISTINCT neighbourhood
FROM dbo.appointments_clean_final
ORDER BY neighbourhood;
GO

-- First round of text replacements
UPDATE dbo.appointments_clean_final
SET neighbourhood = REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(neighbourhood,
                          '+ç', 'ç'),
                          '+â', 'â'),
                          '+ì', 'í'),
                          '+ë', 'é'),
                          '+è', 'ê'),
                          '+ã', 'ã'),
                          '+õ', 'õ'),
                          '+á', 'á'),
                          '+ó', 'ó'),
                          '+ú', 'ú'),
                          '+ö', 'Ô'),
                          '+ü', 'Á'),
                          '+é', 'Â'),
                          'çâO', 'ÇÃO');
GO

-- Identify remaining problematic values
SELECT DISTINCT neighbourhood
FROM dbo.appointments_clean_final
WHERE neighbourhood LIKE '%+%'
   OR neighbourhood LIKE '%â%'
   OR neighbourhood LIKE '%ç%'
   OR neighbourhood LIKE '%Ü%'
   OR neighbourhood LIKE '%¦%';
GO

-- Second round of text replacements
UPDATE dbo.appointments_clean_final
SET neighbourhood = REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(
                      REPLACE(neighbourhood,
                          'SâO', 'SÃO'),
                          'JOâO', 'JOÃO'),
                          'çA', 'ÇA'),
                          '+ô', 'Ó'),
                          'é', 'É'),
                          '-¦', ''''),
                          'âO', 'ÃO');
GO

-- Final review of neighbourhood values
SELECT DISTINCT neighbourhood
FROM dbo.appointments_clean_final
ORDER BY neighbourhood;
GO

/* =========================================================
   8. Final preview
========================================================= */

SELECT TOP 20 *
FROM dbo.appointments_clean_final;
GO