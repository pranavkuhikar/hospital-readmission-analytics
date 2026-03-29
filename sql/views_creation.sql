DROP VIEW IF EXISTS Portfolio_Hospital_Insights;

CREATE VIEW Portfolio_Hospital_Insights AS
WITH PatientSequence AS (
    SELECT 
        f.admission_id,
        f.patient_key,
        p.age, 
        p.gender, 
        f.time_in_hospital,
        f.severity_index,
        -- Identify the order of visits for each patient
        ROW_NUMBER() OVER (PARTITION BY f.patient_key ORDER BY f.admission_id) as visit_number
    FROM Fact_Admissions f
    JOIN Dim_Patients p ON f.patient_key = p.patient_key
)
SELECT 
    admission_id,
    -- 1. Start all dates at 1999-01-01
    -- 2. Add a random offset (0 to 2800 days) based on the patient's unique ID
    -- 3. For repeat visits, add exactly 20 days per visit to simulate "30-day readmissions"
    (
        '1999-01-01'::date + 
        (MOD(ABS(HASHTEXT(patient_key::text)), 2800) * INTERVAL '1 day') + 
        ((visit_number - 1) * INTERVAL '20 days')
    )::date as admission_date,
    age, 
    gender, 
    time_in_hospital,
    severity_index,
    DENSE_RANK() OVER(PARTITION BY age ORDER BY severity_index DESC) as risk_rank_in_age
FROM PatientSequence;