-- Readmission Rate by Age

SELECT
    age,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmissions,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)::numeric 
        / COUNT(*) * 100, 2
    ) AS readmission_rate
FROM hospital.admissions_master
GROUP BY age
ORDER BY readmission_rate DESC;


-- Medication Impact (Polypharmacy Effect)
SELECT
    age,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmissions,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)::numeric 
        / COUNT(*) * 100, 2
    ) AS readmission_rate
FROM hospital.admissions_master
GROUP BY age
ORDER BY readmission_rate DESC;


-- Length of Stay Optimization
SELECT
    time_in_hospital,
    COUNT(*) AS patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmissions,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)::numeric 
        / COUNT(*) * 100, 2
    ) AS readmission_rate
FROM hospital.admissions_master
GROUP BY time_in_hospital
ORDER BY time_in_hospital;

-- Severity vs Resource Usage
SELECT
    number_diagnoses,
    AVG(num_lab_procedures) AS avg_labs,
    AVG(num_medications) AS avg_meds
FROM hospital.admissions_master
GROUP BY number_diagnoses
ORDER BY number_diagnoses;


-- WINDOW FUNCTION 
-- Rank Age Groups by Readmission Risk
SELECT
    age,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmissions,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)::numeric 
        / COUNT(*) * 100, 2
    ) AS readmission_rate,
    RANK() OVER (
        ORDER BY 
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)::numeric 
        / COUNT(*) DESC
    ) AS risk_rank
FROM hospital.admissions_master
GROUP BY age;

-- Running Total of Readmissions
SELECT
    age,
    COUNT(*) AS patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmissions,
    SUM(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)
    ) OVER (ORDER BY age) AS cumulative_readmissions
FROM hospital.admissions_master
GROUP BY age
ORDER BY age;

-- Patient Segmentation (NTILE)
SELECT
    patient_key,
    number_diagnoses,
    NTILE(4) OVER (ORDER BY number_diagnoses DESC) AS risk_quartile
FROM hospital.admissions_master;

-- Top Patients by Resource Usage
SELECT *
FROM (
    SELECT
        patient_key,
        num_medications,
        num_lab_procedures,
        ROW_NUMBER() OVER (
            ORDER BY num_medications DESC
        ) AS rank
    FROM hospital.admissions_master
) t
WHERE rank <= 10;

-- Partitioned  Analysis (By Race)
SELECT
    race,
    age,
    COUNT(*) AS patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmissions,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)::numeric 
        / COUNT(*) * 100, 2
    ) AS readmission_rate,
    RANK() OVER (
        PARTITION BY race 
        ORDER BY 
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)::numeric 
        / COUNT(*) DESC
    ) AS rank_within_race
FROM hospital.admissions_master
GROUP BY race, age;