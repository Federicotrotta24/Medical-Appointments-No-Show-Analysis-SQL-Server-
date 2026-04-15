-- 06_analysis.sql

USE MedicalAppointmentsDB;
GO

/* =========================================================
   1. Final dataset preview
========================================================= */

SELECT TOP 5 *
FROM dbo.appointments_clean_final;
GO

/* =========================================================
   2. Overall no-show rate
========================================================= */

SELECT 
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) AS no_show,
    SUM(CASE WHEN assisted = 1 THEN 1 ELSE 0 END) AS showed_up,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final;
GO

/* =========================================================
   3. No-show rate by gender
========================================================= */

SELECT 
    gender,
    COUNT(*) AS total,
    SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) AS no_show,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final
GROUP BY gender
ORDER BY no_show_rate DESC;
GO

/* =========================================================
   4. No-show rate by age group
========================================================= */

SELECT 
    CASE 
        WHEN age < 18 THEN '0-17'
        WHEN age BETWEEN 18 AND 35 THEN '18-35'
        WHEN age BETWEEN 36 AND 60 THEN '36-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS total,
    SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) AS no_show,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final
GROUP BY 
    CASE 
        WHEN age < 18 THEN '0-17'
        WHEN age BETWEEN 18 AND 35 THEN '18-35'
        WHEN age BETWEEN 36 AND 60 THEN '36-60'
        ELSE '60+'
    END
ORDER BY no_show_rate DESC;
GO

/* =========================================================
   5. No-show rate by SMS reminder
========================================================= */

SELECT 
    sms_received,
    COUNT(*) AS total,
    SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) AS no_show,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final
GROUP BY sms_received;
GO

/* =========================================================
   6. No-show rate by waiting time

   Waiting time = number of days between:
   - the date when the appointment was scheduled
   - the actual appointment date
========================================================= */

SELECT 
    CASE 
        WHEN days_between = 0 THEN 'same_day'
        WHEN days_between BETWEEN 1 AND 3 THEN '1-3 days'
        WHEN days_between BETWEEN 4 AND 7 THEN '4-7 days'
        ELSE '7+ days'
    END AS wait_time,
    COUNT(*) AS total,
    SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) AS no_show,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final
GROUP BY 
    CASE 
        WHEN days_between = 0 THEN 'same_day'
        WHEN days_between BETWEEN 1 AND 3 THEN '1-3 days'
        WHEN days_between BETWEEN 4 AND 7 THEN '4-7 days'
        ELSE '7+ days'
    END
ORDER BY no_show_rate DESC;
GO

/* =========================================================
   7. SMS reminder + waiting time interaction
========================================================= */

SELECT 
    sms_received,
    CASE 
        WHEN days_between <= 3 THEN '0-3'
        WHEN days_between <= 7 THEN '4-7'
        ELSE '7+'
    END AS wait_group,
    COUNT(*) AS total,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final
GROUP BY 
    sms_received,
    CASE 
        WHEN days_between <= 3 THEN '0-3'
        WHEN days_between <= 7 THEN '4-7'
        ELSE '7+'
    END
ORDER BY no_show_rate DESC;
GO

/* =========================================================
   8. No-show rate by chronic conditions
========================================================= */

-- Hypertension
SELECT 
    hypertension,
    COUNT(*) AS total,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final
GROUP BY hypertension;
GO

-- Diabetes
SELECT 
    diabetes,
    COUNT(*) AS total,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final
GROUP BY diabetes;
GO

-- Alcoholism
SELECT 
    alcoholism,
    COUNT(*) AS total,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final
GROUP BY alcoholism;
GO

/* =========================================================
   9. No-show rate by day of week
========================================================= */

SELECT 
    DATENAME(WEEKDAY, appointment_date) AS day_of_week,
    COUNT(*) AS total,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final
GROUP BY DATENAME(WEEKDAY, appointment_date)
ORDER BY no_show_rate DESC;
GO

/* =========================================================
   10. Top neighbourhoods with highest no-show rates
========================================================= */

SELECT TOP 10
    neighbourhood,
    COUNT(*) AS total,
    CAST(SUM(CASE WHEN assisted = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS no_show_rate
FROM dbo.appointments_clean_final
GROUP BY neighbourhood
HAVING COUNT(*) > 100
ORDER BY no_show_rate DESC;
GO