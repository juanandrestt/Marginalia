class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @review = Review.find(params[:review_id])
    @comments = @review.comments.includes(:user)
    @comment = Comment.new
  end

  def create
    @review = Review.find(params[:review_id])
    @comment = @review.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to review_comments_path(@review), notice: "Comment added!"
    else
      redirect_to review_comments_path(@review), alert: "Unable to add comment."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
