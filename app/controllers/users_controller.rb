class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :remove_avatar]
  before_action :authenticate_user!, only: [:edit, :update, :remove_avatar]
  before_action :correct_user, only: [:edit, :update, :remove_avatar]  # 本人のみ編集できるように制限

  def show
    @movies = @user.movies.order(created_at: :desc) # 投稿した映画一覧
    @favorite_movies = Favorite.where(user: @user)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end  

  def remove_avatar
    @user.avatar.purge if @user.avatar.attached?
    redirect_to edit_user_path(@user), notice: "プロフィール画像を削除しました。"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :avatar)
  end

  def correct_user
    redirect_to root_path, alert: "この操作は許可されていません" unless current_user == @user
  end
end
