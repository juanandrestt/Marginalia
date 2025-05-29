class Bookmark < ApplicationRecord
  belongs_to :book
  belongs_to :list
  validates_presence_of :book, :list
  validates_uniqueness_of :book_id, scope: :list_id
end
