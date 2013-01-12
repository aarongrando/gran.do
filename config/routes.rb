Grrrando::Application.routes.draw do
  
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # The priority is based upon order of creation:
  # earlier in this file -> higher priority.

  root to: 'home#index', as: :home

end
