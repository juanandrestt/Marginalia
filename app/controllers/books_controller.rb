class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @current_user_review = @book.reviews.where(user: current_user).first
    @reviews = @book.reviews.where.not(user: current_user)
  end

  def new
    @book = Book.new
  end
end
