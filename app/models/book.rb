class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :readings, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookclubs, dependent: :destroy
end
