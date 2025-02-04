Rails.application.routes.draw do
  devise_for :users  # Devise を使ったユーザー管理
  root "movies#index"  # トップページを `movies#index` に設定
  resources :movies  # 映画のCRUD機能を自動で設定（一覧・詳細・作成・編集・削除）
end
