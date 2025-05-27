class ReviewsController < ApplicationController
  def new
    @book = Book.find(params[:book_id])
    @review = Review.new
  end


  def create
      @book = Book.find(params[:book_id])
      @review = Review.new(review_params)
      @review.book = @book
      # @review.user = User.first
      if @review.save
        redirect_to book_path(@book)
      else
        render :new, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating, :emotion, :favorite_characters)
  end
end
