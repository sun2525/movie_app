Rails.application.routes.draw do
  devise_for :users
  # ユーザーのプロフィールページを追加
  resources :users, only: [:show, :edit, :update]

  resources :movies do
    resources :chats, only: [:index, :create]
  end
    
  root "movies#index"  # トップページを映画一覧に設定
  get 'movies/search', to: 'movies#search'

end
