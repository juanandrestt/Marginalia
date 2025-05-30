class Message < ApplicationRecord
  acts_as_message
  
  belongs_to :chat

  validates :content, presence: true, length: { minimum: 10, maximum: 1000 }, if: -> { role == "user" }
  validates :role, presence: true
  validates :chat, presence: true
end
