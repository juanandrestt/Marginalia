class AddChatToMessages < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:messages, :chat_id)
      add_reference :messages, :chat, null: false, foreign_key: true
    end
  end
end
