class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: :asc)
    @message = Message.new
  end

  def create
    @chat = Chat.find(params[:chat_id])
    embedding = RubyLLM.embed(message_params[:content])
    books = Book.nearest_neighbors(:embedding, embedding.vectors, distance: "euclidean").first(3)
    instructions = system_prompt
    instructions += books.map { |book| book_prompt(book) }.join("\n") 
    
    @message = Message.new(message_params.merge(role: 'user', chat: @chat))
    
    if @message.valid?
      @chat.with_instructions(instructions).ask(@message.content) do |chunk|
        next if chunk.content.blank? # skip empty chunks
      
        message = @chat.messages.last
        message.content += chunk.content
        Turbo::StreamsChannel.broadcast_replace_to(@chat, target: helpers.dom_id(message), partial: "messages/message", locals: { message: message })
      end

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { chat: @chat, message: @message }) }
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :role, :model_id)
  end

  def system_prompt
    "You are an assistant for a social platform dedicated to people passionate about reading.
    Your task is to recommend the 3 most relevant books based on the request.
    Always share the name and url of the books given in the catalog. \
    Your answer should be in markdown. \
    Here are the nearest catalog books based on the user's question: "
  end

  def book_prompt(book)
    "BOOK id: #{book.id}, title: #{book.title}, Author: #{book.author}, Description: #{book.description}, Subjects: #{book.subjects}, Publishing year: #{book.publishing_year}, url: #{request.base_url}#{book_path(book)}"
  end
end
