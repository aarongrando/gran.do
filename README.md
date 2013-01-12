# Ruby on Rails Grrrando
This project is a fast-start Grrrando for creating basic Ruby on Rails projects. It's designed to be highly compatible with the common development practices at [Red Tettemer + Partners](http://redtettemer.com) in Philadelphia. 


## What's included
- A Grrrando Gemfile with our most commonly used gems.
- HTML5 Grrrando (with normalize.css, modernizr, and log() js function for IE-friendly console.loggin'.) 
- SCSS-ified application.css
- A basic index action in a home controller.
- A good Grrrando .gitignore.
- AppEnv module for easier local dev/test config var access.
- App pre-configured to use the Unicorn HTTP server on Heroku with 3 workers per dyno.
- ActiveAdmin for easily managing your info in an admin interface.


## Getting Started
1. Rename your app. Run a full-project text search for "Grrrando" and replace it with your app's namespace in every case except this README.
2. Create your database, run `rake db:setup`
3. Run `rake db:migrate` to initialize the ActiveAdmin interface tables.
4. Run your server with foreman: `foreman start`
5. Proceed with building your app normally, without worrying about the more tedious and repetitive initial setup steps.
6. Refer to the ActiveAdmin docs to configure the admin interface (depends on your model setup): <https://github.com/gregbell/active_admin>
	- The default user/pass for Active admin is `admin@example.com`:`password`

## Colophon
- HTML5 Grrrando: <http://html5Grrrando.com>
- SASS: <http://sass-lang.com>
- Normalize.css: <http://necolas.github.com/normalize.css>
- Modernizr: <http://modernizr.com>
- ActiveAdmin: <https://github.com/gregbell/active_admin>
- Heroku: <http://heroku.com>