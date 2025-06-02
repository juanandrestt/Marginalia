class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # PENSER A METTRE UNE VALIDATION POUR UNE REVIEW PAR LIVRE PAR USER
end
