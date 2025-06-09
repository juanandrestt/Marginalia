class BookclubUsersController < ApplicationController
  def create
    @bookclub = Bookclub.find(params[:bookclub_id])
    @bookclub_user = @bookclub.bookclub_users.build(bookclub_user_params)

    if @bookclub_user.save
      redirect_to bookclub_path(@bookclub), notice: "Member added successfully"
    else
      redirect_to bookclub_path(@bookclub), alert: "Could not add member"
    end
  end

  private

  def bookclub_user_params
    params.require(:bookclub_user).permit(:user_id)
  end
end
