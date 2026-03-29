-- 1. Database Creation
CREATE DATABASE hospital_analysis;

-- 2. Schema Creation
-- Using a dedicated schema keeps the 'public' schema clean and mimics professional data warehousing.
CREATE SCHEMA IF NOT EXISTS clinical_analytics;

-- 3. Table Creation (Master Table)
-- This table was designed to include all 31 clinical markers found in the master dataset.
CREATE TABLE clinical_analytics.admissions_master (
    encounter_id INT PRIMARY KEY,
    patient_nbr BIGINT,
    race VARCHAR(50),
    gender VARCHAR(20),
    age VARCHAR(20),
    weight VARCHAR(20),
    admission_type_id INT,
    discharge_disposition_id INT,
    admission_source_id INT,
    time_in_hospital INT,
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    number_diagnoses INT,
    severity_index DECIMAL(4,2), -- Engineered Feature
    readmit_high_risk INT,       -- Binary Classification
    insulin VARCHAR(20),
    diabetes_med VARCHAR(10),
    change_med VARCHAR(10)
);

-- 4. Indexing for Performance
-- Essential for optimizing the Power BI connection and faster dashboard refreshing.
CREATE INDEX idx_age_severity ON clinical_analytics.admissions_master (age, severity_index);
CREATE INDEX idx_patient_lookup ON clinical_analytics.admissions_master (patient_nbr);