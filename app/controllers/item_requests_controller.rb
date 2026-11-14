class ItemRequestsController < ApplicationController
  before_action :require_login
  before_action :require_buyer
  before_action :set_item_request, only: %i[update no_reply done]

  def create
    listing = Listing.live.where.not(user_id: current_user.id).find(params[:listing_id])
    item_request = current_user.item_requests.build(
      listing: listing, tried_ids: [listing.id], spot: ItemRequest::SPOTS.first
    )
    if item_request.save
      redirect_to root_path, notice: "Requested. See My requests below."
    else
      redirect_to root_path, alert: item_request.errors.map(&:message).to_sentence
    end
  end

  def update
    if @item_request.update(spot: params[:spot])
      redirect_to root_path
    else
      redirect_to root_path, alert: "Pick a valid meeting spot."
    end
  end

  def no_reply
    unless current_user.auto_move?
      return redirect_to root_path, alert: "Auto-move is off, so you keep waiting."
    end

    seller_listing = @item_request.move_to_next!
    if seller_listing
      km = seller_listing.distance_from(current_user.area).round(1)
      redirect_to root_path, notice: "Moved to #{seller_listing.user.name} (#{km} km away)."
    else
      redirect_to root_path, alert: "No other sellers nearby for now."
    end
  end

  def done
    @item_request.done!
    redirect_to root_path
  end

  private

  def set_item_request
    @item_request = current_user.item_requests.active.find(params[:id])
  end
end
