module database

import db.sqlite

pub fn config_db() !sqlite.DB {
	mut db := sqlite.connect('mydb.db')!
	return db
}