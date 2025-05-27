class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  # PENSER A METTRE UNE VALIDATION POUR UNE REVIEW PAR LIVRE PAR USER
end
