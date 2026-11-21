-- ==============================================================================
-- 001_create_tables.sql - Real-Time Airplane Crashes Analytics
-- Author: Monzer (Database Engineer)
-- Supervised by: Mostafa (Team Leader & Architect)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS accidents (
    event_id VARCHAR(50) PRIMARY KEY,
    event_date DATE NOT NULL,
    event_time VARCHAR(20),
    country VARCHAR(100),
    location TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    aircraft_make VARCHAR(150),
    aircraft_model VARCHAR(150),
    injury_severity VARCHAR(50),
    fatal_injuries INTEGER DEFAULT 0 CHECK (fatal_injuries >= 0),
    serious_injuries INTEGER DEFAULT 0 CHECK (serious_injuries >= 0),
    minor_injuries INTEGER DEFAULT 0 CHECK (minor_injuries >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance & analytics
CREATE INDEX IF NOT EXISTS idx_accidents_date ON accidents(event_date);
CREATE INDEX IF NOT EXISTS idx_accidents_country ON accidents(country);
CREATE INDEX IF NOT EXISTS idx_accidents_make ON accidents(aircraft_make);

-- Comments
COMMENT ON TABLE accidents IS 'جدول تخزين حوادث الطيران المعالجة لحظياً عبر Spark Streaming';
COMMENT ON COLUMN accidents.event_id IS 'المعرف الفريد للحادث - Primary Key';
