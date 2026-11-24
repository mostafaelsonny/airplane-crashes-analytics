# Dataset Inspection Report

## 1. Dataset Overview

- **Dataset Name:** NTSB Aviation Accident Database
- **Source:** National Transportation Safety Board (NTSB)
- **Dataset Format:** Microsoft Access Database (.mdb)
- **Database File:** avall.mdb
- **Database Access Method:** Python using pyodbc
- **Database Path:** Extracted_Data/avall.mdb

## 2. Dataset Tables and Record Counts

| Table Name | Total Records |
|---|---:|
| events | 31,453 |
| aircraft | 32,010 |
| injury | 182,616 |

## 3. Database Relationships

The database contains event-related information distributed across multiple tables.

- `events`: Contains accident/event information, including event ID, date, time, location, coordinates, and injury totals.
- `aircraft`: Contains aircraft information associated with events, including aircraft key, make, and model.
- `injury`: Contains person injury information associated with events, including person category, injury level, and person count.

The `ev_id` field is used to associate records between the events, aircraft, and injury tables.

## 4. Data Access and Exploration

The Access database was accessed programmatically using Python and pyodbc.

The following tasks were performed:

- Database connection and table inspection.
- Field matching for the required project fields.
- Data profiling for missing and empty values.
- Data quality checks for dates, times, injury counts, and geographic coordinates.
- Extraction of 20 sample event records with associated aircraft and injury records.

## 5. Data Quality Findings

Data profiling identified missing values in several fields, including:

- Event time
- State
- Latitude and longitude
- Event injury severity
- Aircraft make and model
- Injury person count

Detailed missing-value statistics are available in `data_profiling.csv`.

Additional quality checks were performed for:

- Invalid and future dates
- Invalid time formats
- Negative and unusually high injury counts
- Geographic coordinates outside valid ranges
- Unparsed coordinate values

Detailed check results are available in `data_quality_checks.csv`.

## 6. Sample Data

A sample of 20 event records was extracted in JSON format.

The sample includes:

- Event ID
- Accident date and time
- Location information
- Latitude and longitude
- Event injury severity
- Fatal, serious, and minor injury totals
- Associated aircraft information
- Associated injury records

Sample file: `sample_records.json`

## 7. Generated Files

| File | Description |
|---|---|
| `data_profiling.csv` | Missing-value profiling report |
| `data_quality_checks.csv` | Data quality check results |
| `sample_records.json` | 20 extracted sample records |
| `dataset_inspection.md` | Dataset inspection documentation |
| `data_dictionary.md` | Field definitions and profiling details |

## 8. Notes and Limitations

- Missing values do not necessarily mean incorrect data.
- High injury counts were flagged for review and are not automatically classified as errors.
- The relationship between tables was explored using the event identifier (`ev_id`); formal database foreign-key constraints still need confirmation.
- The extracted sample contains 20 events with associated aircraft and injury records.

## 9. Data Mapping & Transformations

The following transformations are planned to prepare the source data for downstream processing:

- **Accident Time (`ev_time`):** The source field is stored as `SMALLINT` and represents time in HHMM format. It will be converted into `HH:MM:SS` format. For example, `1430` will be converted to `14:30:00`. Missing or invalid time values will be handled as NULL.

- **Latitude and Longitude:** The source `latitude` and `longitude` fields are stored as `VARCHAR` and may contain coordinate values in different formats. They will be parsed and converted into decimal numeric values (Float/Double) after validation. Invalid or unparseable coordinates will be handled as NULL to prevent downstream processing errors in NiFi or Spark.

- **Multiple Aircraft per Event:** Some events may be associated with more than one aircraft. For Sprint 1, using `Aircraft_Key = 1` as the primary aircraft is a proposed simplification, pending team approval.