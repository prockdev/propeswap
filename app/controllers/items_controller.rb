# Detail page for one listing.
class ItemsController < ApplicationController
  before_action :require_login

  def show
    @listing = Listing.includes(:user).find(params[:id])
    asked   = ItemRequest.exists?(user_id: current_user.id, listing_id: @listing.id)
    visible = @listing.user_id == current_user.id || current_user.admin? || asked ||
              (!@listing.sold? && !@listing.expired? && !@listing.user.suspended?)
    redirect_to root_path, alert: "That item isn't available." unless visible
  end
end
