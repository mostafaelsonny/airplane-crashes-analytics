import pyodbc
import json
import os

mdb_path = r"D:\NTSB_Project\Extracted_Data\avall.mdb"
output_folder = r"D:\NTSB_Project\docs\data"

os.makedirs(output_folder, exist_ok=True)

conn_str = (
    r"DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};"
    f"DBQ={mdb_path};"
)

conn = pyodbc.connect(conn_str)
cursor = conn.cursor()


def fetch_as_dicts(query):
    cursor.execute(query)
    column_names = [column[0] for column in cursor.description]
    return [
        dict(zip(column_names, row))
        for row in cursor.fetchall()
    ]


# 1. Read event records
events = fetch_as_dicts("""
    SELECT
        ev_id,
        ev_date,
        ev_time,
        ev_city,
        ev_state,
        ev_country,
        latitude,
        longitude,
        ev_highest_injury,
        inj_tot_f,
        inj_tot_s,
        inj_tot_m
    FROM [events]
    WHERE ev_date IS NOT NULL
    ORDER BY ev_date DESC
""")

# 2. Read aircraft records
aircraft = fetch_as_dicts("""
    SELECT
        ev_id,
        Aircraft_Key,
        acft_make,
        acft_model
    FROM [aircraft]
""")

# 3. Read injury records
injuries = fetch_as_dicts("""
    SELECT
        ev_id,
        inj_person_category,
        injury_level,
        inj_person_count
    FROM [injury]
""")

# 4. Group aircraft by Event ID
aircraft_by_event = {}

for row in aircraft:
    event_id = row["ev_id"]

    aircraft_by_event.setdefault(event_id, []).append({
        "Aircraft Key": row["Aircraft_Key"],
        "Aircraft Make": row["acft_make"],
        "Aircraft Model": row["acft_model"]
    })

# 5. Group injuries by Event ID
injuries_by_event = {}

for row in injuries:
    event_id = row["ev_id"]

    injuries_by_event.setdefault(event_id, []).append({
        "Person Category": row["inj_person_category"],
        "Injury Level": row["injury_level"],
        "Person Count": row["inj_person_count"]
    })

# 6. Extract 20 events with aircraft and injury records
samples = []

for event in events:
    event_id = event["ev_id"]

    event_aircraft = aircraft_by_event.get(event_id, [])
    event_injuries = injuries_by_event.get(event_id, [])

    # Require event date, aircraft record, and injury record
    if not event_aircraft or not event_injuries:
        continue

    sample = {
        "Event ID": event_id,
        "Accident Date": event["ev_date"],
        "Accident Time": event["ev_time"],
        "City": event["ev_city"],
        "State": event["ev_state"],
        "Country": event["ev_country"],
        "Latitude": event["latitude"],
        "Longitude": event["longitude"],
        "Event Injury Severity": event["ev_highest_injury"],
        "Fatal Injuries": event["inj_tot_f"],
        "Serious Injuries": event["inj_tot_s"],
        "Minor Injuries": event["inj_tot_m"],
        "Aircraft": event_aircraft,
        "Injury Records": event_injuries
    }

    samples.append(sample)

    if len(samples) == 20:
        break

# 7. Save samples as JSON
output_file = os.path.join(output_folder, "sample_records.json")

with open(output_file, "w", encoding="utf-8") as file:
    json.dump(
        samples,
        file,
        ensure_ascii=False,
        indent=4,
        default=str
    )

conn.close()

print("Sample extraction completed successfully!")
print("Samples extracted:", len(samples))
print("JSON saved to:", output_file)