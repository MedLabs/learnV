module models

@[table: 'articles']
pub struct Article {
pub:	
	id	int	@[primary; sql:serial]
	title	string @[sql_type: 'TEXT']
	content	string @[sql_type: 'TEXT']
}