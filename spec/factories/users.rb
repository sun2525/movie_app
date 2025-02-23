# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
