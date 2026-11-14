class ListingsController < ApplicationController
  before_action :require_login
  before_action :require_seller, only: %i[mine create sold renew destroy]
  before_action :set_listing, only: %i[sold renew destroy]

  # Buyer home: live listings nearest to the buyer's area
  def index
    return redirect_to(sell_path) if current_user.seller?

    @listings = Listing.live.includes(:user)
                       .where.not(user_id: current_user.id)
                       .in_category(params[:category])
                       .search(params[:q])
                       .sort_by { |l| l.distance_from(current_user.area) }
    @item_requests = current_user.item_requests.active
                                 .includes(listing: :user).order(created_at: :desc)
  end

  # Seller home: post form + own listings
  def mine
    @listing = Listing.new(area: current_user.area)
    load_my_listings
  end

  def create
    @listing = current_user.listings.build(listing_params)
    if @listing.save
      redirect_to sell_path, notice: "Posted. It stays live for 7 days."
    else
      load_my_listings
      render :mine, status: :unprocessable_entity
    end
  end

  def sold
    @listing.update!(sold: true)
    redirect_to sell_path, notice: "Marked as sold."
  end

  def renew
    @listing.update!(posted_at: Time.current)
    redirect_to sell_path, notice: "Renewed for 7 more days."
  end

  def destroy
    @listing.destroy
    redirect_to sell_path, notice: "Listing deleted."
  end

  private

  def set_listing
    @listing = current_user.listings.find(params[:id]) # sellers can only touch their own
  end

  def load_my_listings
    @listings = current_user.listings.order(posted_at: :desc)
  end

  def listing_params
    params.require(:listing).permit(:title, :category, :price, :area)
  end
end
