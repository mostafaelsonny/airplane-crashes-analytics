# 🗄️ PostgreSQL Database Module

المسؤول: **منذر (Monzer)** | Database Engineer

---

## 📌 جدول الحوادث المعتمد (`accidents`)
* **Primary Key:** `event_id`
* **Idempotent Upsert Query:**
```sql
INSERT INTO accidents (
    event_id, event_date, event_time, country, location, 
    latitude, longitude, aircraft_make, aircraft_model, 
    injury_severity, fatal_injuries, serious_injuries, minor_injuries, updated_at
) VALUES (
    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, CURRENT_TIMESTAMP
)
ON CONFLICT (event_id) DO UPDATE SET
    event_date = EXCLUDED.event_date,
    event_time = EXCLUDED.event_time,
    country = EXCLUDED.country,
    location = EXCLUDED.location,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    aircraft_make = EXCLUDED.aircraft_make,
    aircraft_model = EXCLUDED.aircraft_model,
    injury_severity = EXCLUDED.injury_severity,
    fatal_injuries = EXCLUDED.fatal_injuries,
    serious_injuries = EXCLUDED.serious_injuries,
    minor_injuries = EXCLUDED.minor_injuries,
    updated_at = CURRENT_TIMESTAMP;
```

---

## 🔌 Connection Strings
* **من داخل Docker (مثل Spark في الحاوية):** `postgresql://postgres:postgres@postgres:5432/airplane_crashes_db`
* **من خارج Docker (جهاز المطور):** `postgresql://postgres:postgres@localhost:5432/airplane_crashes_db`
