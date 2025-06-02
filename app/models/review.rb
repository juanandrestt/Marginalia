class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  after_create :mark_book_as_read

  private
  def mark_book_as_read
    Reading.find_or_create_by(user_id: self.user_id, book_id: self.book_id) do |reading|
      reading.status = true
    end
  end
end
