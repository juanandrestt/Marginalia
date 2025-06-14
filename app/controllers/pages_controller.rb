class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
    @book = Book.limit(1)
    @books = Book.offset(20).limit(6)
    @booksreco = Book.offset(30).limit(6)
    @last = Book.offset(10).limit(6)
    @bookslider = Book.limit(6)
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
