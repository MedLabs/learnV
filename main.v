module main

import x.vweb
import rand
import database
import models
import handlers
import term
import markdown
import os


pub struct Context {
  vweb.Context
pub mut:
  article models.Article
  articles []models.Article
  users []models.User
}
pub struct App {
  vweb.StaticHandler
pub mut:
  title string 
  counter Counter
  age int
  name string
  about_text string
}

struct Counter {
pub mut:
  count int
}

pub fn (ctx Context) before_request() {
  mut method := ctx.req.method.str()
  match method {
    "GET" { method = term.green('${ctx.req.method}')}
    "POST" { method = term.blue('${ctx.req.method}')}
    "PUT" { method = term.magenta('${ctx.req.method}')}
    "DELETE" { method = term.yellow('${ctx.req.method}')}
    else {method = term.cyan('${ctx.req.method}')}
  }
  // Dont log the assets requests
  if !ctx.req.url.starts_with("/assets"){
    println("Watching: [${method}] request on ${ctx.req.url}")
  }
}

fn main() {
  mut db := database.config_db() or {panic(err)}
  sql db {
      create table models.Article
      create table models.User
  }!
  db.close() or { panic("Error creating tables, Error: ${err}") }
  
  mut app:= &App{
    title: "VwebApp",
    counter: Counter{count: 2},
    age: 42,
    name: "Lassaad"
  }

  app.static_mime_types['.map'] = 'txt/plain'
  app.handle_static("assets", false)!
  vweb.run[App, Context](mut app, 8081)
}

@['/']
pub fn (mut app App) index(mut ctx Context) vweb.Result {
  app.title = 'VwebApp - Home'
  app.age = 30 + 12
  app.name = 'MedLabs'

  md_file := os.read_file("templates/md/demo.md") or {panic("cound not open md file: ${err}")}
  md_content := markdown.to_html(md_file)
  md_to_html := vweb.RawHtml(md_content)
  return $vweb.html()
}

@['/about']
pub fn (mut app App) about(mut ctx Context) vweb.Result {
  app.title = 'VwebApp - About'
  app.about_text = "This project is made using the V web framework Vweb\nCheck the source code and try to reproduce it from scratch, it\'s the best way to learn V"
  return $vweb.html()
}

@['/articles'; get]
pub fn (mut app App) articles(mut ctx Context) vweb.Result {
  app.title = 'VwebApp - Articles'
  ctx.articles = handlers.get_all_articles()
  return $vweb.html()
}

@['/articles/:id']
pub fn (mut app App) post(mut ctx Context, id int) vweb.Result {
  post := handlers.get_article(id) or {models.Article{}}
/*   mut wc := 0
  if post.id == 0 {
    wc = 0
  } else {
    wc = handlers.post_wc(post.content)
  } */
  app.title = "VWebApp - ${post.title}"
  return $vweb.html()
}
@['/post-edit/:id'; get; post]
pub fn (mut app App) post_form(mut ctx Context, id int) vweb.Result {
  mut post := handlers.get_article(id) or {models.Article{}}
/*   mut wc := 0
  if post.id == 0 {
    wc = 0
  } else {
    wc = handlers.post_wc(post.content)
  } */
  if ctx.req.method == .post {
  return $vweb.html("templates/components/post_form.html")
  }
  else {
  return $vweb.html("templates/components/post_view.html")
  }
}


@['/articles/add'; post]
pub fn (mut app App) add_post(mut ctx Context, title string, content string) vweb.Result {
  if title == '' {
		ctx.res.set_status(.bad_request)
		return ctx.text('Post Title should not be empty')
	}
	else {
    handlers.add_article(title, content) or { panic(err)}
  }
  return ctx.redirect('/articles')
}

@['/articles/:id/delete'; post]
pub fn (mut app App) delete_post(mut ctx Context, id int) vweb.Result {
  handlers.delete_article(id)
  return ctx.redirect('/articles')
}

@['/toggle-confirm/:id'; post]
pub fn (mut app App) toggle_confirm(mut ctx Context, id int) vweb.Result {
  return $vweb.html("templates/components/confirm_delete_article.html")
}

@['/post-edit/:id...'; put]
pub fn (mut app App) update_article(mut ctx Context, id int) vweb.Result {
  post := models.Article{
    id: id,
    title: ctx.form["title"],
    content: ctx.form["content"]
  }
  handlers.update_article(post)
  return $vweb.html("templates/components/post_view.html")
}

@['/users']
pub fn (mut app App) users(mut ctx Context) vweb.Result {
  app.title = "VwebApp - Users"
  ctx.users = handlers.get_all_users()
  return $vweb.html()
}

@['/users/add'; post]
pub fn (mut app App) create_user(mut ctx Context, name string, username string, password string, role string) vweb.Result {
  user := models.User{
    name: name,
    username: username,
    password: password,
    role: role
  }
  if user.name == "" || user.username == "" {
    ctx.res.set_status(.bad_request)
    return ctx.text("user name or username should not be empty")
  } else {
    handlers.create_user(user) or {panic(err)}
  }
  return ctx.redirect('/users')
}

@['/users/:id/delete'; post]
pub fn (mut app App) delete_user(mut ctx Context, id int) vweb.Result {
  handlers.delete_user(id)
  return ctx.redirect('/users')
}

@['/htmx']
pub fn (mut app App) htmx(mut ctx Context) vweb.Result {
  app.title = "VwebApp - HTMX"
  ctx.article = models.Article{}
  return $vweb.html()
}

// random_article Route to get a random article
@['/random_article'; get]
pub fn (mut app App) random_article(mut ctx Context) vweb.Result {
	mut db := database.config_db() or {panic(err)}
	result := sql db {
		select from models.Article order by id desc
	} or {[]models.Article{}}
  random_post := rand.element(result) or {models.Article{}}
	return $vweb.html("templates/components/random_article.html")
}

// last_user Route to get the last added user
@['/last_user'; get]
pub fn (mut app App) last_user(mut ctx Context) vweb.Result {
	mut db := database.config_db() or {panic(err)}
	result := sql db {
		select from models.User order by id desc
	} or {[]models.User{}}
    last := result.first()
	return $vweb.html("templates/components/random_user.html")
}

@['/increment'; put]
pub fn (mut app App) increment(mut ctx Context) vweb.Result {
  app.counter.count += 1
  return ctx.text(app.counter.count.str())
}

@['/decrement'; put]
pub fn (mut app App) decrement(mut ctx Context) vweb.Result {
  if app.counter.count > 0 {
    app.counter.count -= 1
  }
  return ctx.ok(app.counter.count.str())
}

// REST API RETURNING JSON DATA
pub fn (app &App) api(mut ctx Context) vweb.Result {
  return ctx.text("Welcome to VwebApp API.\nTry accessing /api/articles")
}

@['/api/articles'; get]
pub fn (app &App) articles_json (mut ctx Context) vweb.Result {
  mut db := database.config_db() or {panic(err)}
  res := sql db {
    select from models.Article
  } or {[]models.Article{}}
  return ctx.json(res)
}
