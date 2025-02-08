class ChatChannel < ApplicationCable::Channel
  def subscribed
    @movie = Movie.find(params[:movie_id]) # 追記
    stream_for @movie # 追記
  end

  def unsubscribed
    # Cleanup when the user leaves the chat
  end
end
