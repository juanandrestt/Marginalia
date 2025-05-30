class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers and underscore" }

  before_validation :set_default_avatar

  has_many :lists
  has_many :reviews
  has_many :readings
  has_many :bookclubs, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :follows, source: :following
  has_many :reverse_follows, class_name: 'Follow', foreign_key: :following_id, dependent: :destroy
  has_many :followers, through: :reverse_follows, source: :follower

  def following?(other_user)
    follows.exists?(following_id: other_user.id)
  end

  private

  def set_default_avatar
    return if avatar.present?

    initials = username.to_s[0..1].upcase
    self.avatar = "https://ui-avatars.com/api/?name=#{initials}&background=751F1F&color=FAF5EF&size=64&font-size=0.4"
  end
end
