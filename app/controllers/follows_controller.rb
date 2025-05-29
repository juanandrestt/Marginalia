class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create]
  before_action :set_follow, only: [:destroy]

  def create
    @follow = current_user.follows.build(following_id: @user.id)

    if @follow.save
      redirect_back(fallback_location: root_path, notice: "You are now following #{@user.email}")
    else
      redirect_back(fallback_location: root_path, alert: "Unable to follow this user")
    end
  end

  def destroy
    if @follow.destroy
      redirect_back(fallback_location: root_path, notice: "You have unfollowed #{@follow.following.email}")
    else
      redirect_back(fallback_location: root_path, alert: "Unable to unfollow this user")
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
