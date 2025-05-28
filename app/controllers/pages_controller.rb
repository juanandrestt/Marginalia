class PagesController < ApplicationController
  def home
    @book = Book.limit(1)
    @books = Book.offset(20).limit(6)
    @last = Book.offset(10).limit(6)
  end
  def books
    @book = Book.find(params[:id])
  end

  def index
    if params[:query].present?
      @books = Book.where("title ILIKE ? OR author ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    else
      @books = Book.all
    end
  end
end
