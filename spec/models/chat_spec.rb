require 'rails_helper'

RSpec.describe Chat, type: :model do
  before do
    @user = FactoryBot.create(:user) # ユーザーを作成
    @chat = FactoryBot.build(:chat, user: @user) # チャットのインスタンスを作成
  end

  describe 'チャットの投稿' do
    context '内容に問題がない場合' do
      it 'メッセージがあれば投稿できる' do
        expect(@chat).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'メッセージが空では投稿できない' do
        @chat.message = ''
        @chat.valid?
        expect(@chat.errors.full_messages).to include("Message can't be blank")
      end

      it 'メッセージが500文字以内でないと投稿できない' do
        @chat.message = 'a' * 501
        @chat.valid?
        expect(@chat.errors.full_messages).to include('Message is too long (maximum is 500 characters)')
      end
    end
  end
end
