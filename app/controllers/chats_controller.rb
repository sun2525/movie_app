class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie

  def index
    @chats = @movie.chats.includes(:user).order(created_at: :asc)
    @chat = Chat.new
  end

  def create
    @chat = @movie.chats.build(chat_params)
    @chat.user = current_user
    if @chat.save
      redirect_to movie_chats_path(@movie), notice: "メッセージを送信しました！"
    else
      @chats = @movie.chats.includes(:user).order(created_at: :asc)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def chat_params
    params.require(:chat).permit(:message)
  end
end
