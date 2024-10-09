-- Create the patient table
CREATE TABLE patient (
    patient_id VARCHAR PRIMARY KEY,
    race_name VARCHAR,
    race_category VARCHAR,
    ethnicity_name VARCHAR,
    ethnicity_category VARCHAR,
    sex_name VARCHAR,
    sex_category VARCHAR,
    birth_date DATE,
    death_dttm TIMESTAMP,
    language_name VARCHAR,
    language_category VARCHAR
);

-- Create the hospitalization table
CREATE TABLE hospitalization (
    hospitalization_id VARCHAR PRIMARY KEY,
    patient_id VARCHAR NOT NULL REFERENCES patient(patient_id),
    admission_dttm TIMESTAMP,
    discharge_dttm TIMESTAMP,
    age_at_admission INTEGER,
    admission_type_name VARCHAR,
    admission_type_category VARCHAR,
    discharge_name VARCHAR,
    discharge_category VARCHAR,
    zipcode_nine_digit VARCHAR,
    zipcode_five_digit VARCHAR,
    census_block_code VARCHAR,
    census_block_group_code VARCHAR,
    census_tract VARCHAR,
    state_code VARCHAR,
    county_code VARCHAR
);

-- Create the adt table
CREATE TABLE adt (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    in_dttm TIMESTAMP NOT NULL,
    location_name VARCHAR NOT NULL,
    hospital_id VARCHAR,
    out_dttm TIMESTAMP,
    location_category VARCHAR,
    PRIMARY KEY (hospitalization_id, in_dttm, location_category)
);

-- Create the vitals table
CREATE TABLE vitals (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    recorded_dttm TIMESTAMP NOT NULL,
    vital_name VARCHAR NOT NULL,
    vital_category VARCHAR,
    vital_value DOUBLE PRECISION,
    meas_site_name VARCHAR,
    PRIMARY KEY (hospitalization_id, recorded_dttm, vital_category)
);

-- Create the labs table
CREATE TABLE labs (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    lab_collect_dttm TIMESTAMP NOT NULL,
    lab_name VARCHAR NOT NULL,
    lab_specimen_name VARCHAR NOT NULL,
    lab_order_dttm TIMESTAMP,
    lab_result_dttm TIMESTAMP,
    lab_order_name VARCHAR,
    lab_order_category VARCHAR,
    lab_category VARCHAR,
    lab_value VARCHAR,
    lab_value_numeric DOUBLE PRECISION,
    reference_unit VARCHAR,
    lab_specimen_category VARCHAR,
    lab_loinc_code VARCHAR,
    PRIMARY KEY (hospitalization_id, lab_collect_dttm, lab_category)
);

-- Create the patient_assessments table
CREATE TABLE patient_assessments (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    recorded_dttm TIMESTAMP NOT NULL,
    assessment_name VARCHAR NOT NULL,
    assessment_category VARCHAR,
    assessment_group VARCHAR,
    numerical_value DOUBLE PRECISION,
    categorical_value VARCHAR,
    text_value VARCHAR,
    PRIMARY KEY (hospitalization_id, recorded_dttm, assessment_category)
);

-- Create the respiratory_support table
CREATE TABLE respiratory_support (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    recorded_dttm TIMESTAMP NOT NULL,
    device_name VARCHAR NOT NULL,
    mode_name VARCHAR NOT NULL,
    device_category VARCHAR,
    mode_category VARCHAR,
    tracheostomy VARCHAR,
    fio2_set DOUBLE PRECISION,
    lpm_set DOUBLE PRECISION,
    tidal_volume_set DOUBLE PRECISION,
    resp_rate_set DOUBLE PRECISION,
    pressure_control_set DOUBLE PRECISION,
    pressure_support_set DOUBLE PRECISION,
    flow_rate_set DOUBLE PRECISION,
    peak_inspiratory_pressure_set DOUBLE PRECISION,
    inspiratory_time_set DOUBLE PRECISION,
    peep_set DOUBLE PRECISION,
    tidal_volume_obs DOUBLE PRECISION,
    resp_rate_obs DOUBLE PRECISION,
    plateau_pressure_obs DOUBLE PRECISION,
    peak_inspiratory_pressure_obs DOUBLE PRECISION,
    peep_obs DOUBLE PRECISION,
    minute_vent_obs DOUBLE PRECISION,
    mean_airway_pressure_obs DOUBLE PRECISION,
    PRIMARY KEY (hospitalization_id, recorded_dttm, device_category, mode_category)
);

-- Create the medication_orders table
CREATE TABLE medication_orders (
    med_order_id VARCHAR PRIMARY KEY,
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    order_start_dttm TIMESTAMP,
    order_end_dttm TIMESTAMP,
    ordered_dttm TIMESTAMP,
    med_name VARCHAR,
    med_category VARCHAR,
    med_group VARCHAR,
    med_order_status_name VARCHAR,
    med_order_status_category VARCHAR,
    med_route_name VARCHAR,
    med_dose DOUBLE PRECISION,
    med_dose_unit VARCHAR,
    med_frequency VARCHAR,
    prn VARCHAR
);

-- Create the medication_admin_continuous table
CREATE TABLE medication_admin_continuous (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    admin_dttm TIMESTAMP NOT NULL,
    med_order_id VARCHAR REFERENCES medication_orders(med_order_id),
    med_name VARCHAR NOT NULL,
    med_category VARCHAR,
    med_group VARCHAR,
    med_route_name VARCHAR,
    med_route_category VARCHAR,
    med_dose DOUBLE PRECISION,
    med_dose_unit VARCHAR,
    mar_action_name VARCHAR,
    mar_action_category VARCHAR,
    PRIMARY KEY (hospitalization_id, admin_dttm, med_category)
);

-- Create the position table
CREATE TABLE position (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    recorded_dttm TIMESTAMP NOT NULL,
    position_name VARCHAR NOT NULL,
    position_category VARCHAR,
    PRIMARY KEY (hospitalization_id, recorded_dttm, position_category)
);

-- Create the provider table
CREATE TABLE provider (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    provider_id VARCHAR NOT NULL,
    start_dttm TIMESTAMP NOT NULL,
    stop_dttm TIMESTAMP,
    provider_role_name VARCHAR,
    provider_role_category VARCHAR,
    PRIMARY KEY (hospitalization_id, provider_id, start_dttm)
);

-- Create the admission_diagnosis table
CREATE TABLE admission_diagnosis (
    patient_id VARCHAR NOT NULL REFERENCES patient(patient_id),
    diagnostic_code VARCHAR NOT NULL,
    start_dttm TIMESTAMP NOT NULL,
    diagnosis_code_format VARCHAR,
    end_dttm TIMESTAMP,
    PRIMARY KEY (patient_id, diagnostic_code, start_dttm)
);

-- Create the intake_output table
CREATE TABLE intake_output (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    intake_dttm TIMESTAMP NOT NULL,
    fluid_name VARCHAR NOT NULL,
    amount DOUBLE PRECISION,
    in_out_flag INTEGER,
    PRIMARY KEY (hospitalization_id, intake_dttm, fluid_name)
);

-- Create the ecmo_mcs table
CREATE TABLE ecmo_mcs (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    start_dttm TIMESTAMP NOT NULL,
    device_name VARCHAR NOT NULL,
    device_metric_name VARCHAR NOT NULL,
    end_dttm TIMESTAMP,
    device_category VARCHAR,
    device_rate DOUBLE PRECISION,
    flow DOUBLE PRECISION,
    sweep DOUBLE PRECISION,
    PRIMARY KEY (hospitalization_id, start_dttm, device_category)
);

-- Create the microbiology_culture table
CREATE TABLE microbiology_culture (
    culture_id VARCHAR PRIMARY KEY,
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    order_dttm TIMESTAMP,
    collect_dttm TIMESTAMP,
    result_dttm TIMESTAMP,
    fluid_name VARCHAR,
    fluid_category VARCHAR,
    component_name VARCHAR,
    component_category VARCHAR,
    organism_name VARCHAR,
    organism_category VARCHAR
);

-- Create the sensitivity table
CREATE TABLE sensitivity (
    culture_id VARCHAR NOT NULL REFERENCES microbiology_culture(culture_id),
    antibiotic VARCHAR NOT NULL,
    mic VARCHAR,
    sensitivity VARCHAR,
    PRIMARY KEY (culture_id, antibiotic)
);

-- Create the microbiology_nonculture table
CREATE TABLE microbiology_nonculture (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    collect_dttm TIMESTAMP NOT NULL,
    fluid_name VARCHAR NOT NULL,
    fluid_category VARCHAR,
    component_category VARCHAR NOT NULL,
    order_dttm TIMESTAMP,
    result_dttm TIMESTAMP,
    result_unit_category VARCHAR,
    result_category VARCHAR,
    PRIMARY KEY (hospitalization_id, collect_dttm, fluid_category, component_category)
);

-- Create the procedures table
CREATE TABLE procedures (
    hospitalization_id VARCHAR NOT NULL REFERENCES hospitalization(hospitalization_id),
    procedure_name VARCHAR NOT NULL,
    start_dttm TIMESTAMP NOT NULL,
    procedure_category VARCHAR,
    diagnosis VARCHAR,
    PRIMARY KEY (hospitalization_id, procedure_category, start_dttm)
);