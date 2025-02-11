class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :movie, optional: true

  validates :message, presence: true, length: { maximum: 500 }
end
