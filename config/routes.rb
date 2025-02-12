Rails.application.routes.draw do
  devise_for :users

  # **ユーザーのプロフィールページ**
  resources :users, only: [:show, :edit, :update]

  # **映画のルート（投稿機能は不要なので `only: [:index, :show]` に変更）**
  resources :movies, only: [:index, :show] do
    # **チャット機能（映画ごとに紐づく）**
    resources :chats, only: [:index, :create]

    # **視聴開始・終了のルートを追加**
    member do
      post :start_viewing  # 映画の視聴を開始
      post :stop_viewing   # 映画の視聴を終了
    end
  end

  # **トップページを映画一覧に設定**
  root "movies#index"

  # **映画検索**
  get 'movies/search', to: 'movies#search'
end
