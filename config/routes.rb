Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: 'home#index'

  get "launchpad", to: "home#launchpad"
  get "nexus", to: "home#nexus"
  get "nexus-chat", to: redirect("/nexus#cs-adoption"), as: :nexus_chat
  get "mod-heat", to: "home#mod_heat", as: :mod_heat
  get "geo", to: "home#geo"
  get "resume", to: "home#resume"

end
