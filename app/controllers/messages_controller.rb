class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: :asc)
    @message = Message.new
  end

  def create
    @chat = Chat.find(params[:chat_id])
    embedding = RubyLLM.embed(message_params[:content])
    books = Book.nearest_neighbors(:embedding, embedding.vectors, distance: "euclidean")
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
    <<~PROMPT
      You are an assistant for a social platform dedicated to people passionate about reading.
      Your task is to recommend the 3 most relevant books based on the request.
  
      Each recommendation must include:
      - The **book title as a Markdown link** using the provided URL.
      - A brief description (from the `description` field).
      
      Use only the provided book list below.
      Do **not** make up any books or URLs.
      Here are the nearest catalog books:
    PROMPT
  end
  

  def book_prompt(book)
    <<~BOOK
      BOOK id: #{book.id}
      Title: #{book.title}
      Author: #{book.author}
      Description: #{book.description}
      Subjects: #{book.subjects}
      Publishing year: #{book.publishing_year}
      URL: #{request.base_url}#{book_path(book)}
    BOOK
  end  
end
