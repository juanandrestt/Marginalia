class User < ApplicationRecord
  has_many :lists
  has_many :reviews
  has_many :readings
end
