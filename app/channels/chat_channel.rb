class ChatChannel < ApplicationCable::Channel
  def subscribed
    movie = Movie.find(params[:movie_id]) # 映画IDを取得
    stream_for movie # 映画ごとに個別のストリームを作成
  end

  def unsubscribed
    # Cleanup when the user leaves the chat
  end
end
