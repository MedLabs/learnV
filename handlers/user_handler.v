module handlers

import database
import models

// Get all Users
pub fn get_all_users() []models.User {
	mut db := database.config_db() or {panic(err)}

	return sql db {
		select from models.User
	} or { []models.User{}}
}

// Create new user
pub fn create_user(user models.User) ! {
	mut db := database.config_db() or {panic(err)}

	sql db {
		insert user into models.User
	} or {}
}

// Delete user
pub fn delete_user(id int) {
	mut db := database.config_db() or {panic(err)}
	sql db {
		delete from models.User where id == id
	} or {}
}
