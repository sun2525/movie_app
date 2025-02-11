Rails.application.routes.draw do
  devise_for :users

  # **ユーザーのプロフィールページ**
  resources :users, only: [:show, :edit, :update]

  # **映画のルート（投稿機能は不要なので `only: [:index, :show]` に変更）**
  resources :movies, only: [:index, :show] do
    resources :chats, only: [:index, :create] # **チャット機能**
  end
  
  # **トップページを映画一覧に設定**
  root "movies#index"

  # **映画検索**
  get 'movies/search', to: 'movies#search'
end
