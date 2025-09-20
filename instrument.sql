CREATE TABLE dbo.instrument (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    instrument_type NVARCHAR(50) NOT NULL,
    status NVARCHAR(50) NOT NULL CHECK (status IN ('active', 'inactive', 'under_maintenance')),
    notes NVARCHAR(MAX) NULL,
    valid_from DATETIME2(3) NOT NULL CONSTRAINT DF_instrument_valid_from DEFAULT SYSUTCDATETIME(),
    valid_to DATETIME2(3) NOT NULL CONSTRAINT DF_instrument_valid_to DEFAULT ('9999-12-31 23:59:59.997'),
    system_start_time DATETIME2(3) GENERATED ALWAYS AS ROW START NOT NULL,
    system_end_time DATETIME2(3) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (system_start_time, system_end_time),
    CONSTRAINT CHK_instrument_valid_range CHECK (valid_from < valid_to)
)
WITH (
    SYSTEM_VERSIONING = ON (
        HISTORY_TABLE = dbo.instrument_history,
        DATA_CONSISTENCY_CHECK = ON
    )
);

CREATE INDEX IX_instrument_name
    ON dbo.instrument (name);
