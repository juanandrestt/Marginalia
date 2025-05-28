class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_review_owner, only: [:edit, :update, :destroy]

  def new
    @book = Book.find(params[:book_id])
    @review = Review.new
  end


  def create
      @book = Book.find(params[:book_id])
      @review = Review.new(review_params)
      @review.book = @book
      @review.user = current_user
      # @review.user = User.first
      if @review.save
        redirect_to book_path(@book)
      else
        render :new, status: :unprocessable_entity
      end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to book_path(@review.book), notice: 'Review updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to book_path(@review.book), notice: 'Review deleted'
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def check_review_owner
    unless @review.user == current_user
      redirect_to root_path, alert: 'Impossible to modify or delete it'
    end
  end

  def review_params
    params.require(:review).permit(:content, :rating, :emotion, :favorite_characters)
  end
end
