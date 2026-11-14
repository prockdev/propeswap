module Admin
  class DashboardController < BaseController
    def index
      people = User.where(sample: false)
      requests = ItemRequest.group(:status).count

      @users = {
        total: people.count,
        buyers: people.buyer.count,
        sellers: people.seller.count,
        new_this_week: people.where("created_at > ?", 7.days.ago).count,
        suspended: people.where(suspended: true).count
      }
      @listings = {
        live: Listing.live.count,
        sold: Listing.where(sold: true).count,
        expired: Listing.where(sold: false).where("posted_at <= ?", Listing::EXPIRY.ago).count
      }
      @requests = {
        waiting: requests.fetch("waiting", 0),
        moved: requests.fetch("moved", 0),
        done: requests.fetch("done", 0)
      }
    end
  end
end
