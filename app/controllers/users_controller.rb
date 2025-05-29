class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @followers_count = @user.followers.count
    @following_count = @user.followings.count
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers
    render 'follow_list'
  end

  def following
    @user = User.find(params[:id])
    @following = @user.followings
    render 'follow_list'
  end
end
