class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(phone: User.normalize_phone(params[:phone]))
    if user&.authenticate(params[:password].to_s)
      if user.suspended?
        flash.now[:alert] = "This account is suspended. Contact PropeSwap support."
        return render :new, status: :unprocessable_entity
      end
      sign_in(user)
      redirect_to(user.seller? ? sell_path : root_path, notice: "Welcome back, #{user.name}.")
    else
      flash.now[:alert] = "Wrong phone number or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Signed out."
  end
end
