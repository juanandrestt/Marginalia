class Bookclub < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :bookclub_users
  has_many :members, through: :bookclub_users, source: :user
  has_many :discussions

  validates :name, presence: true
end
