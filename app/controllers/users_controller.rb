class UsersController < ApplicationController
  before_action :require_login, only: :update_settings

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      redirect_to(@user.seller? ? sell_path : root_path, notice: "Account created. Welcome to PropeSwap!")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_settings
    current_user.update!(auto_move: params[:auto_move] == "1")
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :password, :area, :role)
  end
end
