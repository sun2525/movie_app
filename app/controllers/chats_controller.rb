class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie

  def index
    @chats = @movie.chats.includes(:user)
    @chat = Chat.new
  end

  def create
    @chat = @movie.chats.new(chat_params)
    if @chat.save
      # ブロードキャストデータの送信
      ChatChannel.broadcast_to @movie, { 
        chat: @chat, 
        user: {
          id: @chat.user.id,
          name: @chat.user.name
        }
      }
      head :no_content
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
    params.require(:chat).permit(:message).merge(user_id: current_user.id)
  end
end
