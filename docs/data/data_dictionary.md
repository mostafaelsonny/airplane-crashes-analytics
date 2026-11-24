# Data Dictionary

## 1. Purpose

This data dictionary documents the fields selected for the NTSB aviation accident dataset inspection. It includes field names, source tables, data types, descriptions, missing-value statistics, and their importance for the project.

## 2. Events Table

| Field Name | Data Type | Description | Missing Count | Missing % | Requirement |
|---|---|---|---:|---:|---|
| ev_id | VARCHAR (14) | Unique identifier for an aviation event | 0 | 0.00% | Required |
| ev_date | DATETIME | Date of the accident or event | 0 | 0.00% | Required |
| ev_time | SMALLINT | Time of the event, stored as a numeric value | 413 | 1.31% | Optional |
| ev_city | VARCHAR (50) | City where the event occurred | 13 | 0.04% | Optional |
| ev_state | VARCHAR (2) | State associated with the event location | 4,725 | 15.02% | Optional |
| ev_country | VARCHAR (4) | Country associated with the event location | 4 | 0.01% | Optional |
| latitude | VARCHAR (7) | Latitude coordinate of the event location | 3,430 | 10.91% | Optional |
| longitude | VARCHAR (8) | Longitude coordinate of the event location | 3,429 | 10.90% | Optional |
| ev_highest_injury | VARCHAR (4) | Highest injury severity associated with the event | 1,463 | 4.65% | Optional |
| inj_tot_f | SMALLINT | Total fatal injuries reported for the event | 0 | 0.00% | Required for injury analysis |
| inj_tot_s | SMALLINT | Total serious injuries reported for the event | 0 | 0.00% | Required for injury analysis |
| inj_tot_m | SMALLINT | Total minor injuries reported for the event | 0 | 0.00% | Required for injury analysis |

## 3. Aircraft Table

| Field Name | Data Type | Description | Missing Count | Missing % | Requirement |
|---|---|---|---:|---:|---|
| ev_id | VARCHAR (14) | Identifier linking aircraft records to an event | 0 | 0.00% | Required |
| Aircraft_Key | INTEGER | Aircraft record key | 0 | 0.00% | Required |
| acft_make | VARCHAR (30) | Aircraft manufacturer or make | 42 | 0.13% | Optional |
| acft_model | VARCHAR (20) | Aircraft model | 53 | 0.17% | Optional |

## 4. Injury Table

| Field Name | Data Type | Description | Missing Count | Missing % | Requirement |
|---|---|---|---:|---:|---|
| ev_id | VARCHAR (14) | Identifier linking injury records to an event | 0 | 0.00% | Required |
| inj_person_category | VARCHAR(4) | Category of the person associated with the injury record | 0 | 0.00% | Required for injury analysis |
| injury_level | VARCHAR (4) | Severity level of the reported injury | 0 | 0.00% | Required for injury analysis |
| inj_person_count | SMALLINT | Number of persons represented by the injury record | 23,246 | 12.73% | Optional |

## 5. Missing-Value Notes

- Event ID and event date contain no missing values in the profiling report.
- Event time is missing in 413 records.
- State is missing in 4,725 records.
- Latitude and longitude have missing values in approximately 10.9% of records.
- Aircraft make and model have very low missing-value percentages.
- Injury person count has 23,246 missing values (12.73%).

Missing values should be investigated before using these fields in analysis. Missing values are not automatically considered invalid records.

## 6. Data Type Verification

Data types were verified using the schema inspection results extracted from the original NTSB Access database (avall.mdb). The data types are documented according to the source database schema.

## 7. Requirement Classification

- **Required:** Important identifiers or fields needed to connect records or perform core project analysis.
- **Optional:** Fields that may be missing or unavailable for some records.
- **Required for analysis:** Important for a particular analytical task, but the field may not be mandatory in every source record.