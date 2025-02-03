Rails.application.routes.draw do
  get 'movies/index'
  devise_for :users

  root to: "movies#index"
end
