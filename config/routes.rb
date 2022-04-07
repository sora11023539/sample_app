Rails.application.routes.draw do
  # ルート「/」へのGETリクエストがstaticpagesコントローラのhomeアクションにルーティング
  root 'static_pages#home'
  # urlに対するリクエストをstatic_pageコントローラーのhomeアクションと結びつけている
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  get 'static_pages/contact'
end
