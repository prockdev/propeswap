# What a seller sees when someone requests one of their items.
class IncomingRequestsController < ApplicationController
  before_action :require_login
  before_action :require_seller

  def index
    @requests = incoming.includes(:user, :listing).order(created_at: :desc)
  end

  def show
    @request = incoming.includes(:user, :listing).find(params[:id])
  end

  def seen
    incoming.find(params[:id]).update!(seen_at: Time.current)
    redirect_to incoming_requests_path
  end

  private

  # Only requests on the signed-in seller's own listings.
  def incoming
    ItemRequest.joins(:listing)
               .where(listings: { user_id: current_user.id })
               .where.not(status: "done")
  end
end
