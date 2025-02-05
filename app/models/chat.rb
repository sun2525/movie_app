class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :message, presence: true, length: { maximum: 500 }
end
