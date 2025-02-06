class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]  # 本人のみ編集できるように制限

  def show
    @movies = @user.movies.order(created_at: :desc) # 投稿した映画一覧
  end

  def edit
  end

  def update
    if @user.update_without_password(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
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
