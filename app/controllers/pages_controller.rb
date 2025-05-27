class PagesController < ApplicationController
  def home
    @book = Book.limit(1)
     @books = Book.offset(1).limit(3)
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
