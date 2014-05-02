Grrrando::Application.routes.draw do
  # The priority is based upon order of creation:
  # earlier in this file -> higher priority.

  root to: 'home#index', as: :home

  get '/cv', to: 'home#cv', as: :cv
  
  get '/blog/intro-to-heroku-addons', to: 'blog#heroku', as: :blog_heroku

end
