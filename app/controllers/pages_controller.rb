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

  def dashboard
    if user_signed_in?
    @recent_lists = List.where(user_id: current_user.id).order(created_at: :desc).limit(5)
    @recent_readings = Reading.where(user_id: current_user.id).order(created_at: :desc).limit(5)
    else
      redirect_to new_user_session_path
    end
  end
end
