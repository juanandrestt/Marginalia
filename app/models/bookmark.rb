class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :list
end
