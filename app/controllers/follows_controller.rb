class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create]
  before_action :set_follow, only: [:destroy]

  def create
    user_to_follow = User.find(params[:following_id])
    @follow = Follow.new(follower: current_user, following: user_to_follow)

    if @follow.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to book_path(@follow.following) }
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @follow = Follow.find(params[:id])
    @follow.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to book_path(@follow.following) }
      end
  end

  private

  def set_user
    @user = User.find(params[:following_id])
  end

  def set_follow
    @follow = current_user.follows.find(params[:id])
  end
end
