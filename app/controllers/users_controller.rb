class UsersController < ApplicationController
  before_action :set_user, only: [:show, :followers, :following, :books, :lists, :bookclubs]

  def show
    @followers_count = @user.followers.count
    @following_count = @user.followings.count
    @books = @user.readings.includes(:book).map(&:book).first(5)
  end

  def followers
    @followers = @user.followers
    render 'follow_list'
  end

  def following
    @following = @user.followings
    render 'follow_list'
  end

  def books
    @books = @user.readings
  end

  def lists
    @lists = @user.lists
  end

  def bookclubs
    @bookclubs = @user.bookclubs
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
