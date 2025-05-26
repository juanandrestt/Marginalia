class Book < ApplicationRecord
  has_many :reviews
  has_many :readings
  has_many :bookmarks
end
