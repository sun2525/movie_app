class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :movies, dependent: :destroy 
  has_many :chats, dependent: :destroy
  has_one_attached :avatar  # ActiveStorage でアバター画像を管理
  has_one :viewing, dependent: :destroy


# パスワードの条件: 半角英数字混合
validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i, message: 'must include both letters and numbers' }, allow_blank: true

# 名前関連
validates :name, presence: true, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'must be full-width characters' }


  def update_without_password(params, *options)
    params.delete(:password) if params[:password].blank?
    params.delete(:password_confirmation) if params[:password_confirmation].blank?
    update(params, *options)
  end

end
