class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie

  def index
    @chats = @movie.chats.includes(:user)
    @chat = Chat.new
  end

  def create
    @chat = @movie.chats.new(chat_params)
    @Movie = Movie.find(params[:movie_id]) #追加
    if @chat.save
      ChatChannel.broadcast_to @Movie, { chat: @chat, user: @chat.user }
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
    params.require(:chat).permit(:message).merge(user_id: current_user.id, movie_id: params[:movie_id])
  end
end
