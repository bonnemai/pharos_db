CREATE TABLE dbo.price (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    instrument_id INT NOT NULL,
    value DECIMAL(19,4) NOT NULL,
    price_type NVARCHAR(50) NOT NULL,
    valid_from DATETIME2(3) NOT NULL CONSTRAINT DF_price_valid_from DEFAULT SYSUTCDATETIME(),
    valid_to DATETIME2(3) NOT NULL CONSTRAINT DF_price_valid_to DEFAULT ('9999-12-31 23:59:59.997'),
    system_start_time DATETIME2(3) GENERATED ALWAYS AS ROW START NOT NULL,
    system_end_time DATETIME2(3) GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (system_start_time, system_end_time),
    CONSTRAINT FK_price_instrument FOREIGN KEY (instrument_id) REFERENCES dbo.instrument(id),
    CONSTRAINT CHK_price_valid_range CHECK (valid_from < valid_to)
)
WITH (
    SYSTEM_VERSIONING = ON (
        HISTORY_TABLE = dbo.price_history,
        DATA_CONSISTENCY_CHECK = ON
    )
);

CREATE INDEX IX_price_instrument_valid
    ON dbo.price (instrument_id, price_type, valid_from DESC);
