Rails.application.routes.draw do
  devise_for :users
  resources :movies

  # ユーザーのプロフィールページを追加
  resources :users, only: [:show]  # 必要なら `edit` なども追加可能

  root "movies#index"  # トップページを映画一覧に設定
end
