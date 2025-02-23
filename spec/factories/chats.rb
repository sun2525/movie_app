FactoryBot.define do
  factory :chat do
    message { 'これはテストメッセージです' }
    association :user
  end
end
