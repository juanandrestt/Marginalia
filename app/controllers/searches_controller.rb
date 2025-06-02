class SearchesController < ApplicationController
  def index
    if params[:query].present?
      @books = Book.where("title ILIKE ? OR author ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    else
      @books = Book.all
    end
  end

end
