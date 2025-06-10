class DiscussionsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @bookclub = Bookclub.find(params[:bookclub_id])
    @discussion = @bookclub.discussions.new(discussion_params)
    @discussion.user = current_user

    if @discussion.save!
      redirect_to bookclub_path(@bookclub)
    else
      redirect_to bookclub_path(@bookclub)
    end
  end

  private

  def discussion_params
    params.require(:discussion).permit(:content)
  end
end
