module routes

import x.vweb
import database
import models

pub struct Context {
  vweb.Context
}


@['/api/users']
pub fn get_users(mut ctx Context) vweb.Result {
	mut db := database.config_db() or {panic(err)}
	res := sql db {
		select from models.User
	} or {[]models.User{}}
	return ctx.json(res)
}