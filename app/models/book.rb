class Book < ApplicationRecord
  after_create :set_embedding

  has_neighbors :embedding
  
  has_many :reviews, dependent: :destroy
  has_many :readings, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookclubs, dependent: :destroy

  has_one_attached :cover

  private

  def set_embedding
    embedding = RubyLLM.embed("Title: #{title}.
                               Author: #{author}.
                               Description: #{description}.
                               Subjects: #{subjects}.
                               Publishing year: #{publishing_year}.
                               ")
    update(embedding: embedding.vectors)
  end
end
