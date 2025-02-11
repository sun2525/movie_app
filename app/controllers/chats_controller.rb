class ChatsController < ApplicationController
  before_action :set_movie

  def index
    # TMDb の映画 ID に基づいてチャットを取得
    @chats = Chat.where(movie_id: @movie_id).order(created_at: :asc)
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.movie_id = params[:movie_id] # TMDb の映画 ID を保存
    @chat.user = current_user

    if @chat.save
      Rails.logger.info "📡 ブロードキャスト開始: chat_#{@chat.movie_id}"
      # リアルタイムチャットの配信
      ActionCable.server.broadcast "chat_#{@movie_id}", { 
        chat: @chat,
        user: {
          id: @chat.user.id,
          name: @chat.user.name
        }
      }
      head :no_content
    else
       # **エラー時にも @chats を設定**
      @chats = Chat.where(movie_id: @movie_id).order(created_at: :asc)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_movie
    if params[:movie_id].present?
      @movie_id = params[:movie_id] # TMDb API の ID
      tmdb_service = TmdbApiService.new
      @movie_details = tmdb_service.movie_details(@movie_id) # TMDb API から映画情報を取得
    else
      redirect_to movies_path, alert: "映画が見つかりません。"
    end
  end

  def chat_params
    params.require(:chat).permit(:message)
  end
end
