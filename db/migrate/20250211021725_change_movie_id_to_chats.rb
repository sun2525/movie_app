class ChangeMovieIdToChats < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :chats, :movies # 外部キー制約を削除
    change_column :chats, :movie_id, :string # movie_id を整数から文字列に変更
  end
end
