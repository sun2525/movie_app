class Movie < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :chats, dependent: :destroy  # 映画が削除されたらチャットも削除

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 } # 10文字以上
  validates :streaming_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "有効なURLを入力してください" }, allow_blank: true
end
