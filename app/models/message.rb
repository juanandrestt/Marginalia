class Message < ApplicationRecord
  belongs_to :chat
  
  acts_as_message

  after_create_commit -> { broadcast_append_to chat, target: "messages", partial: "messages/message", locals: { message: self } }
  
  validates :content, presence: true, length: { minimum: 10, maximum: 1000 }, if: -> { role == "user" }
  validates :role, presence: true
  validates :chat, presence: true
end
