module models

@[table: 'users']
pub struct User {
pub:
	id int @[primary; sql:serial]
	name string @[sql_type: 'TEXT']
	username string @[sql_type: 'TEXT']
	password string @[sql_type: 'TEXT']
	role string @[sql_type: 'TEXT']
	created_at string @[default: 'CURRENT_TIMESTAMP']
}