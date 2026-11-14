class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :new_request_count

  private

  # Suspended accounts are treated as signed out.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id], suspended: false)
  end

  def logged_in?
    current_user.present?
  end

  # Unseen requests on the signed-in seller's listings (shown as a badge).
  def new_request_count
    return 0 unless current_user&.seller?
    ItemRequest.joins(:listing)
               .where(listings: { user_id: current_user.id }, seen_at: nil)
               .where.not(status: "done").count
  end

  def require_login
    redirect_to login_path, alert: "Please log in first." unless logged_in?
  end

  def require_seller
    redirect_to root_path, alert: "That page is for sellers." unless current_user&.seller?
  end

  def require_buyer
    redirect_to sell_path, alert: "That action is for buyers." unless current_user&.buyer?
  end

  def require_admin
    redirect_to root_path, alert: "You don't have access to that page." unless current_user&.admin?
  end

  def sign_in(user)
    reset_session # prevents session fixation
    session[:user_id] = user.id
  end
end
