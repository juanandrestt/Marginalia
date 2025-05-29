class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :lists
  has_many :reviews
  has_many :readings

  has_many :follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :follows, source: :following

  has_many :reverse_follows, class_name: 'Follow', foreign_key: :following_id, dependent: :destroy
  has_many :followers, through: :reverse_follows, source: :follower

  def following?(other_user)
    follows.exists?(following_id: other_user.id)
  end
end
