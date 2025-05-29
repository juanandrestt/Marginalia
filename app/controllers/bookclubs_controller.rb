class BookclubsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookclubs = Bookclub.all
  end

  def show
    @bookclub = Bookclub.find(params[:id])
  end

  def new
    @book = Book.find(params[:book_id])
    @bookclub = Bookclub.new
    @bookclub.book = @book
  end

  def create
    @book = Book.find(params[:book_id])
    @bookclub = Bookclub.new(bookclub_params)
    @bookclub.book = @book
    @bookclub.user = current_user
    if @bookclub.save
      redirect_to book_bookclub_path(@book, @bookclub)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @book = Book.find(params[:book_id])
  end

  private

  def bookclub_params
    params.require(:bookclub).permit(:name, :description)
  end
end
