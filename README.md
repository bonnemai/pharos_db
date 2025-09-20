# Instrument & Price Schema (SQL Server)

This project defines two bi-temporal tables in SQL Server for storing instruments and their prices. Each table tracks both business-valid periods and system-recorded history using system-versioned temporal tables.

## Instrument Table (`dbo.instrument`)

| Column              | Data Type        | Notes |
|---------------------|------------------|-------|
| id                  | INT IDENTITY     | Primary key |
| name                | NVARCHAR(100)    | Required instrument name |
| instrument_type     | NVARCHAR(50)     | Required category/type |
| status              | NVARCHAR(50)     | `active`, `inactive`, or `under_maintenance` |
| notes               | NVARCHAR(MAX)    | Optional descriptive notes |
| valid_from          | DATETIME2(3)     | Business validity start; default `SYSUTCDATETIME()` |
| valid_to            | DATETIME2(3)     | Business validity end; default `9999-12-31 23:59:59.997` |
| system_start_time   | DATETIME2(3)     | Auto-populated row start (system time) |
| system_end_time     | DATETIME2(3)     | Auto-populated row end (system time) |

Additional constraints:
- `status` values enforced by `CHK_instrument_valid_range`.
- `valid_from < valid_to` is enforced.
- `SYSTEM_VERSIONING = ON` with history table `dbo.instrument_history`.

## Price Table (`dbo.price`)

| Column              | Data Type        | Notes |
|---------------------|------------------|-------|
| id                  | INT IDENTITY     | Primary key |
| instrument_id       | INT              | FK to `dbo.instrument(id)` |
| value               | DECIMAL(19,4)    | Monetary amount |
| price_type          | NVARCHAR(50)     | Price category (e.g., close, open) |
| valid_from          | DATETIME2(3)     | Business validity start; default `SYSUTCDATETIME()` |
| valid_to            | DATETIME2(3)     | Business validity end; default `9999-12-31 23:59:59.997` |
| system_start_time   | DATETIME2(3)     | Auto-populated row start (system time) |
| system_end_time     | DATETIME2(3)     | Auto-populated row end (system time) |

Additional constraints:
- `FK_price_instrument` maintains referential integrity.
- `valid_from < valid_to` enforced by `CHK_price_valid_range`.
- Temporal history stored in `dbo.price_history`.
- Index `IX_price_instrument_valid` supports querying by instrument, price type, and validity range.

## Working with Bi-Temporal Data

- Use business-valid columns (`valid_from`, `valid_to`) to control when a record applies in real-world terms. Close a period by updating `valid_to`, then insert a successor row for future data.
- SQL Server maintains system-time history automatically. Query past states with `FOR SYSTEM_TIME` clauses (e.g., `FOR SYSTEM_TIME AS OF '2024-01-01T00:00:00Z'`).
- Prevent overlapping business-valid periods per instrument/price type via application logic or stored procedures if required.

## Status Values

- `active`
- `inactive`
- `under_maintenance`

## Next Steps

1. Deploy the DDL in SQL Server 2016+ (or Azure SQL) to create the tables and history tables.
2. Implement logic for managing valid periods (e.g., stored procedures that enforce non-overlapping ranges).
3. Define reporting queries that leverage `FOR SYSTEM_TIME` to audit historical changes.
