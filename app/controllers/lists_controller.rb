class ListsController < ApplicationController
  before_action :set_list, only: [:show, :destroy]

  def new
    @list = List.new
    @book = Book.find(params[:book_id]) if params[:book_id]
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user

    if params[:list][:book_id]
      book = Book.find(params[:list][:book_id])
      @list.books << book
    end

    if @list.save
      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @list.destroy
    redirect_to lists_path
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name)
  end
end
