class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: :asc)
    @message = Message.new
  end

  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params.merge(role: 'user', chat: @chat))
    
    if @message.valid?
      s@chat.with_instructions(system_prompt).ask(@message.content)
      redirect_to chat_path(@chat)
    else
      render "chats/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :role, :model_id)
  end

  def system_prompt
    "You are an expert librarian. \
      You will be given a book, a literary genre or subject, or a literary era. \
      You must recommend 3 books that are relevant to the user's request."
  end
end
