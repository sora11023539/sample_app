Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  # get 'users/new'
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
  
  # いつも使うやつをまとめて定義
  # show new edit index create update destroy
  resources :users
  # 名前付ルートを扱えるように
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
end
