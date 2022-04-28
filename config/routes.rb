Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  # ルート「/」へのGETリクエストがstaticpagesコントローラのhomeアクションにルーティング
  root 'static_pages#home'
  # urlに対するリクエストをstatic_pageコントローラーのhomeアクションと結びつけている
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'

  # sessionsに対するrouting
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users
end
