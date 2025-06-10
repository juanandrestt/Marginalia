class Discussion < ApplicationRecord
  belongs_to :user
  belongs_to :bookclub
  validates_presence_of :content
end
