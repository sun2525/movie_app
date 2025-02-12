class FavoritesController < ApplicationController
  before_action :authenticate_user!  # ログイン必須

  def create
    favorite = Favorite.find_or_create_by(user: current_user, movie_id: params[:movie_id])
    redirect_back fallback_location: movies_path, notice: "お気に入りに追加しました！"
  end

  def destroy
    favorite = Favorite.find_by(user: current_user, movie_id: params[:movie_id])
    favorite.destroy if favorite
    redirect_back fallback_location: movies_path, notice: "お気に入りを解除しました。"
  end
end
