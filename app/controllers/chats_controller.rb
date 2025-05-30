class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = current_user.chats
    @chat = Chat.new
    @message = Message.new
  end

  def show
    @chat = Chat.includes(:messages).find(params[:id])
    if Rails.env.development?
      @input_tokens = @chat.messages.pluck(:input_tokens).compact.sum
      @output_tokens = @chat.messages.pluck(:output_tokens).compact.sum
      @context_window = RubyLLM.models.find(@chat.model_id).context_window
    end
    @message = Message.new
  end

  def create
    @chat = Chat.new(model_id: "gpt-4o-mini")
    @chat.user = current_user
    if @chat.save
      redirect_to chat_path(@chat)
    else
      render :index
    end
  end
end
