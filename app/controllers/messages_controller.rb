class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: :asc)
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.role = 'user'

    if @message.save
      @chat = RubyLLM.chat
      response = @chat.with_instructions(system_prompt).ask(@message.content)
      Message.create(role: "assistant", content: response.content)
      redirect_to messages_path
    else
      @messages = Message.order(created_at: :asc)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def system_prompt
    @books = Book.all
    book_links = @books.map { |book| "<a href='books/#{book.id}'>#{book.title}</a>" }.join(", ")
    "You are an expert librarian. \
      You will be given a book, a literary genre or subject, or a literary era. \
      You must recommend 3 books that are relevant to the user's request. \
      For each recommendation, you must include the book title as a clickable link using the format: <a href='/books/[id]'>[title]</a>. \
      Here are the books in the library: #{book_links}"
  end
end
