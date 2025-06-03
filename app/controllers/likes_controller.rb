class LikesController < ApplicationController
    before_action :authenticate_user!

  def create
    @review = Review.find(params[:review_id])
    @like = @review.likes.new(user: current_user)

    if @like.save
      respond_to do |format|
        format.html { redirect_to book_path(@review.book), notice: "Liked!" }
        format.turbo_stream
      end
    else
      redirect_to book_path(@review.book), alert: "Unable to like."
    end
  end

  def destroy
    @like = Like.find_by(user: current_user, review_id: params[:review_id])
    @like.destroy if @like

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to book_path(@like.review.book), notice: "Unliked!" }
    end
  end
end
