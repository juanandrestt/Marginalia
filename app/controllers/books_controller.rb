class BooksController < ApplicationController
  before_action :set_book, only: [:show, :mark_as_read]

  def show
    @current_user_review = @book.reviews.where(user: current_user).first
    @reviews = @book.reviews.where.not(user: current_user)
    
    session[:last_viewed_book_url] = request.original_url
  end

  def new
    @book = Book.new
  end

  def index
    @books = Book.all
    if params[:query].present?
      sql_subquery = <<~SQL
        books.title @@ :query
        OR books.author @@ :query
        OR books.description @@ :query
      SQL
      @books = @books.where(sql_subquery, query: params[:query])
    end
  end

  def mark_as_read
    current_user.readings.find_or_create_by(book: @book) do |reading|
      reading.status = true
    end
    redirect_to book_path(@book)
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end
end
