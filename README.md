Here is a data schema document for storing instruments:

# Instrument Schema

| Field Name  | Data Type     | Constraints / Description                                   |
|-------------|--------------|-------------------------------------------------------------|
| id          | Integer       | Primary Key, Auto-increment                                 |
| name        | String (100)  | Required. Name of the instrument                            |
| type        | String (50)   | Required. Type/category of the instrument                   |
| status      | String (50)   | Must be one of: 'active', 'inactive', 'under_maintenance'   |
| notes       | Text          | Optional. Additional notes about the instrument             |
| created_at  | Timestamp     | Defaults to current timestamp when record is created        |
| updated_at  | Timestamp     | Defaults to current timestamp, updates on modification      |

# Status values:
Please note that on PostGre we can potentially use enum. 
* active
* inactive

# Description:
This schema is designed to store information about instruments, including their name, type, current status, and any relevant notes. Timestamps track creation and updates

# TODO: 
* Maybe we should do a bi-temp DB. 