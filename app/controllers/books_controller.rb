class BooksController < ApplicationController
  before_action :set_book, only: [:show, :mark_as_read]

  def show
    @current_user_review = @book.reviews.where(user: current_user).first
    @reviews = @book.reviews.where.not(user: current_user)
  end

  def new
    @book = Book.new
  end

  def index
    if params[:query].present?
      @books = Book.where("title ILIKE ?", "%#{params[:query]}%")
    else
       @books = Book.all
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
