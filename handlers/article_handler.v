module handlers

import database
import models

// Get All Articles
pub fn get_all_articles() []models.Article {
	mut db := database.config_db() or {panic(err)}

	return sql db {
		select from models.Article
	} or { []models.Article{}}
}

// Get One Article
pub fn get_article(id int) !models.Article {
	mut db := database.config_db() or {panic(err)}
	res := sql db {
		select from models.Article where id == id
	}!
	return res.first()
}

// Add New Article
pub fn add_article(title string, content string) ! {
	mut db := database.config_db() or { panic(err)}	
	post := models.Article{
		title: title,
		content: content
	}
	sql db {
		insert post into models.Article
	} or {}
}

// Delete Article
pub fn delete_article(id int) {
	mut db := database.config_db() or {panic(err)}
		sql db {
		delete from models.Article where id == id
	} or {}
}

// Update article
pub fn update_article(post models.Article) {
	mut db := database.config_db() or {panic(err)}
	sql db {
		update models.Article set title = post.title, content = post.content where id == post.id
	} or {}
}