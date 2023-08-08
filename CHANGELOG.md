### Unreleased

* Fix load helpers on time #12

### 0.1.2

* Skip SQL events like CREATE_TABLE and ActiveRecord::InternalMetadata

### 0.1.1

* Skip SchemaMigration SQL events
* Safely ignore failures to create signalman_events when the table doesn't exist

### 0.1.0

* Initial release with basic functionality
