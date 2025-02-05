Rails.application.routes.draw do
  get 'chats/index'
  get 'chats/create'
  devise_for :users
  # ユーザーのプロフィールページを追加
  resources :users, only: [:show]  # 必要なら `edit` なども追加可能
  resources :movies do
    resources :chats, only: [:index, :create]
  end
    
  root "movies#index"  # トップページを映画一覧に設定
end
