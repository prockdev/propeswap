module Admin
  class ListingsController < BaseController
    def index
      @listings = Listing.includes(:user).order(posted_at: :desc)
      @listings = @listings.search(params[:q]) if params[:q].present?
      @listings = @listings.limit(50)
    end

    def destroy
      listing = Listing.find(params[:id])
      Listing.transaction do
        ItemRequest.where(listing_id: listing.id).destroy_all # don't rely on model callbacks
        AdminAction.record!(current_user, "remove_listing", listing,
                            "#{listing.title} (seller ##{listing.user_id})")
        listing.destroy!
      end
      redirect_to admin_listings_path(q: params[:q]), notice: "Removed “#{listing.title}”."
    end
  end
end
