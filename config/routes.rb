Rails.application.routes.draw do
  resources :user
  post 'authenticate', to: 'authentication#authenticate'
  post 'ping', to: 'authentication#ping'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
