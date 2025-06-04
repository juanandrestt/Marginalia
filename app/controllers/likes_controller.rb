class LikesController < ApplicationController
    before_action :authenticate_user!

  def create
    @review = Review.find(params[:review_id])
    @like = @review.likes.new(user: current_user)

    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to book_path(@review.book), notice: "Liked!" }
      end
    else
      redirect_to book_path(@review.book), alert: "Unable to like."
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @review = @like.review if @like
    @like.destroy if @like

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to book_path(@like.review.book), notice: "Unliked!" }
    end
  end
end
