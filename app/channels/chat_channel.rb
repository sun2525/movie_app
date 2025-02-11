class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:movie_id]}"  # `stream_from` の設定を確認
    Rails.logger.info "📡 ChatChannel サブスクライブ: chat_#{params[:movie_id]}"
  end

  def unsubscribed
    # Cleanup when the user leaves the chat
  end
end
